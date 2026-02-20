import { Component, OnInit } from '@angular/core';
import { LeaderboardResponse, LeaderboardService } from '../../services/leaderboard.service';

@Component({
  selector: 'app-leaderboard',
  standalone: false,
  templateUrl: './leaderboard.component.html',
  styleUrl: './leaderboard.component.css',
})
export class LeaderboardComponent implements OnInit {

  pageNo: number = 1;
  pageSize: number = 10 

  pageSizeRange: number[] = [10, 20, 30, 50, 70, 100];

  leaderboardData: LeaderboardResponse = undefined as any;

  constructor(private leaderboardService: LeaderboardService) { }

  ngOnInit() {
    this.loadLeaderboard();
    console.log('Leaderboard data:', this.leaderboardData);
  }

  async loadLeaderboard(): Promise<void> {
    await this.leaderboardService.getLeaderboard(this.pageNo, this.pageSize).subscribe(
      (data) => {
        this.leaderboardData = data;
      });
  }

}
