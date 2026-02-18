import { Component, OnInit } from '@angular/core';
import { LeaderboardResponse, LeaderboardService } from '../../services/leaderboard.service';

@Component({
  selector: 'app-leaderboard',
  standalone: false,
  templateUrl: './leaderboard.component.html',
  styleUrl: './leaderboard.component.css',
})
export class LeaderboardComponent implements OnInit {

  leaderboardData: LeaderboardResponse[] = [];

  constructor(private leaderboardService: LeaderboardService) { }

  async ngOnInit(): Promise<void> {
    await this.leaderboardService.getLeaderboard().subscribe(
      (data) => {
        this.leaderboardData = data;
      });
    console.log('Leaderboard data:', this.leaderboardData);
  }

}
