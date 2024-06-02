# Stage 1: Clone the Grafana repo
FROM alpine/git as clone-stage
WORKDIR /app
RUN git clone https://github.com/grafana/grafana.git .

# Switch to a selected version tag
RUN git checkout v11.0.0


#  Stage 2: Node build stage
FROM grafana/grafana:11.0.0 as build-stage
USER root

# Set the Node.js memory limit to 4 GB
ENV NODE_OPTIONS=--max-old-space-size=4096
ENV NODE_ENV production
ENV PYTHON=/usr/bin/python3

# Install Yarn and Node and other dependencies
RUN apk add --no-cache nodejs yarn python3 make g++

# Set working directory
WORKDIR /usr/share/grafana

# Now install node modules and build the frontend assets
COPY --from=clone-stage /app/package.json /app/yarn.lock /app/.yarnrc.yml ./
## TODO THIS IS A MAJOR BLOCKER ON CURRENT VESRIONS: this dir seems wrong of versions 11
COPY --from=clone-stage /app/packages/grafana-plugin-configs/webpack.config.ts ./grafana-plugin-configs/scripts/webpack/webpack.prod.js
COPY --from=clone-stage /app/.yarn .yarn
COPY --from=clone-stage /app/packages packages
COPY --from=clone-stage /app/plugins-bundled plugins-bundled
COPY --from=clone-stage /app/public public
RUN yarn install --immutable
COPY --from=clone-stage /app/tsconfig.json /app/.editorconfig /app/.browserslistrc /app/.prettierrc.js ./
COPY --from=clone-stage /app/public public
COPY --from=clone-stage /app/scripts scripts
COPY --from=clone-stage /app/emails emails

# Replace your custom assets
COPY ./src/assets/fav32.png ./public/img/fav32.png
COPY ./src/assets/grafana_icon.svg ./public/img/grafana_icon.svg

# Replace Grafana branding files
COPY ./src/components/Branding.tsx ./public/app/core/components/Branding/Branding.tsx
# RUN sed -i 's/"Grafana"/"FastDash"/g' ./public/app/core/components/Branding/Branding.tsx

# https://grafana.com/static/assets/img/logo_new_transparent_200x48.png
# https://grafana.com/static/assets/img/logo_new_transparent_light_400x100.png

# replace email images
RUN sed -i 's|https://grafana.com/static/assets/img/logo_new_transparent_200x48.png|https://repository-images.githubusercontent.com/578973863/6ff42f1d-f4b2-48e7-9458-40d5ab309cdf|g' /usr/share/grafana/public/emails/*
RUN sed -i 's|https://grafana.com/static/assets/img/logo_new_transparent_light_400x100.png|https://repository-images.githubusercontent.com/578973863/6ff42f1d-f4b2-48e7-9458-40d5ab309cdf|g' /usr/share/grafana/public/emails/*

RUN yarn build


# Stage 3: Final stage where you set up your actual container
FROM grafana/grafana:latest
USER root

# Overwrite the default grafana.ini with your custom file
COPY ./src/grafana.ini /etc/grafana/grafana.ini

# Copy built frontend from node-build-stage
COPY --from=build-stage /usr/share/grafana/public /usr/share/grafana/public
COPY --from=build-stage /tmp/ /tmp/

# Install your required Grafana plugins
RUN grafana-cli plugins install nline-plotlyjs-panel
# RUN grafana-cli plugins install williamvenner-timepickerbuttons-panel

# Revert to the grafana user
USER grafana
