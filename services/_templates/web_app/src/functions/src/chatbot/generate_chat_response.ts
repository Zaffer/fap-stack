import config from './config';
import { GenerateMessageOptions } from './types';
// import { fetchHistory } from './firestore';
import { getGenerativeClient } from './generative-client';
import { DocumentSnapshot } from 'firebase-functions/v1/firestore';
import { fetchThread } from './firestore';

/**
 * Takes a prompt, calls the llm, returns the update object (with or without candidates accordingly).
 *
 **/
export const generateChatResponse = async (
  prompt: string,
  after: DocumentSnapshot
) => {
  let requestOptions: GenerateMessageOptions = {
    // context: config.context,
    // maxOutputTokens: config.maxOutputTokens,
    // safetySettings: config.safetySettings || [],
  };

  if (config.enableThreadRetrieval) {
    const ref = after.ref;
    const thread = await fetchThread(ref);
    requestOptions = { ...thread };
  }

  // NOTE not needed if using threads
  // if (!config.enableThreadRetrieval) {
  //   const ref = after.ref;
  //   const history = await fetchHistory(ref);
  //   requestOptions = { history };
  // }

  // NOTE not needed if not using discussions
  // if (config.enableDiscussionOptionOverrides) {
  //   const discussionOptions = await fetchDiscussionOptions(ref);
  //   requestOptions = {...requestOptions, ...discussionOptions};
  // }

  const discussionClient = getGenerativeClient();
  const result = await discussionClient.send(prompt, requestOptions);

  return { [config.responseField]: result.response };

  // NOTE only needed if not using candidates
  // return config.candidatesField &&
  //   config.candidateCount &&
  //   config.candidateCount > 1
  //   ? {
  //       [config.responseField]: result.response!,
  //       [config.candidatesField!]: result.candidates!,
  //     }
  //   : {
  //       [config.responseField]: result.response,
  //     };
};