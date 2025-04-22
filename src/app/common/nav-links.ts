import { Injectable } from "@angular/core";
import { LinkObj } from "./link-obj";

@Injectable({providedIn: 'any'})
export class NavLinks {
    public links = [
        new LinkObj('Welcome', '/landing'),
        new LinkObj('About', '/site-info'),
        new LinkObj('BlackJack', '/black-jack-help')
    ];
}
