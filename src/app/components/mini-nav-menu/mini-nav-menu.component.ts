import { Component, HostListener } from '@angular/core';
import { NavLinks } from '../../common/nav-links';
import { LinkObj } from '../../common/link-obj';

@Component({
  selector: 'app-mini-nav-menu',
  standalone: true,
  imports: [],
  templateUrl: './mini-nav-menu.component.html',
  styleUrl: './mini-nav-menu.component.css'
})
export class MiniNavMenuComponent {
  sidebarActive = true;

  links!: LinkObj[];

  constructor(private navLinks: NavLinks) {
    this.links = this.navLinks.links;
  }

  @HostListener('document:mousewheel', ['$event'])
  onDocumentMousewheelEvent(event: any){
    if (!this.sidebarActive) {
      this.sidebarActive = true;
    }
  }

  toggleSidebar() {
    this.sidebarActive = !this.sidebarActive;
  }

  selectedLink() {
    this.sidebarActive = true;
  }
}
