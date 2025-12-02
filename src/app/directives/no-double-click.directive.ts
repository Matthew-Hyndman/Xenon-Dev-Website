import { Directive, HostListener, inject } from '@angular/core';

@Directive({
    selector: '[appNoDoubleClick]',
    standalone: false
})
export class NoDoubleClickDirective {

  constructor() { }

  @HostListener('click', ['$event'])
  clickEvent(event: any) {
    event.srcElement.setAttribute('disabled', true);
    setTimeout(function(){ 
      event.srcElement.removeAttribute('disabled');
    }, 200);
  }

}
