import { Component } from '@angular/core';

@Component({
  selector: 'app-freelance',
  standalone: false,
  templateUrl: './freelance.component.html',
  styleUrl: './freelance.component.css'
})
export class FreelanceComponent {
  readonly tabs = [
    {
      id: 'services',
      title: 'What services I offer',
      description: 'Core delivery areas for freelance web projects.',
    },
    {
      id: 'wordpress',
      title: 'Move Beyond WordPress',
      description: 'I offer a migration process from WordPress to a modern stack for better performance, security, and scalability.',
    },
    {
      id: 'stack',
      title: 'Tech stack',
      description: 'Tools I use to build and ship production work.',
    },
  ] as const;

  activeTab: (typeof this.tabs)[number]['id'] = 'services';

  setActiveTab(tabId: (typeof this.tabs)[number]['id']): void {
    this.activeTab = tabId;
  }

}
