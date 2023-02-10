import { Component, OnInit } from '@angular/core';
import { SideNavService } from '../../services/sidenav/sidenav.service';
import { animateText, animateSideNav } from '../../animations/nav.animate';
import { Router } from '@angular/router';
// import { SideNavService } from '../../services/nav.service';

interface NavLink {
  icon: string;
  name: string;
  link: string;
}

interface NavGroup {
  icon: string;
  name: string;
  link?: string;
  group?: NavLink[]
}

@Component({
  selector: 'app-menu',
  templateUrl: './menu.component.html',
  styleUrls: ['./menu.component.scss'],
  animations: [animateSideNav, animateText]
})
export class MenuComponent implements OnInit {
  public isSideNavOpen: boolean = false;
  public isLinkTextShown: boolean = false;

  public navs: NavGroup[] = [
    { icon: 'home', name: 'Home', link: '/' },
    { icon: 'auto_awesome_mosaic', name: 'Dashboards', link: '/dashboard' },
    { icon: 'auto_awesome_mosaic', name: 'Dashboards and others', link: '/dashboard' },
    { icon: 'auto_awesome_mosaic', name: 'Dashboards and many more other things', link: '/dashboard' }
  ];

  constructor(public router: Router, private sideNavService: SideNavService) { }

  ngOnInit(): void { }

  toggleSideNav() {
    this.isSideNavOpen = !this.isSideNavOpen

    setTimeout(() => {
      this.isLinkTextShown = this.isSideNavOpen;
    }, 200)
    this.sideNavService.isSideNavOpen.next(this.isSideNavOpen)
  }

}
