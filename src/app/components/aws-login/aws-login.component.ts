import { Component, OnDestroy, OnInit } from '@angular/core';
import { Subscription } from 'rxjs';
import { AwsLoginService, AwsUserProfile } from '../../services/aws-login.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-aws-login',
  standalone: false,
  templateUrl: './aws-login.component.html',
  styleUrl: './aws-login.component.css'
})
export class AwsLoginComponent implements OnInit, OnDestroy {
  userProfile: AwsUserProfile | null = null;
  isLoggedIn: boolean | null = null;
  private subs: Subscription[] = [];

  constructor(
    public awsLoginService: AwsLoginService,
    private router: Router,
  ) {}

  ngOnInit(): void {
    this.subs.push(
      this.awsLoginService.isLoggedIn$.subscribe((loggedIn) => {
        this.isLoggedIn = loggedIn;
      }),
      this.awsLoginService.userProfile$.subscribe((profile) => {
        this.userProfile = profile;
      }),
    );
  }

  ngOnDestroy(): void {
    this.subs.forEach((s) => s.unsubscribe());
  }

  async onSignOut(): Promise<void> {
    await this.awsLoginService.logout();
    this.router.navigate(['/landing']);
  }
}
