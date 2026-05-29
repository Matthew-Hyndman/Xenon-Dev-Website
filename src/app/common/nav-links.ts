import { Injectable } from "@angular/core";
import { LinkObj } from "./link-obj";

@Injectable({providedIn: 'any'})
export class NavLinks {
    public links = [
        new LinkObj('Welcome', '/landing', true),
        new LinkObj('Freelance', '/freelance-info', true),
        new LinkObj('About', '/site-info', true),
        new LinkObj('Blog', '/blog', true),
        new LinkObj('BlackJack', '/black-jack-help', true),
        new LinkObj('Profile', '/user-profile', false),
        new LinkObj('Login', '/aws-login', true),
        new LinkObj('Logout', '', false)
    ];    
}
