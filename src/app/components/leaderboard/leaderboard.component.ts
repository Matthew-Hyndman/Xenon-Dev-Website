import { Component, OnInit } from '@angular/core';
import { LeaderboardResponse, LeaderboardService } from '../../services/leaderboard.service';

@Component({
  selector: 'app-leaderboard',
  standalone: false,
  templateUrl: './leaderboard.component.html',
  styleUrl: './leaderboard.component.css',
})
export class LeaderboardComponent implements OnInit {

  private pageNo: number = 0;
  private pageSize: number = 20 

  pageSizeRange: number[] = [10, 20, 30, 50, 70, 100];

  leaderboardData: LeaderboardResponse[] = [];

  constructor(private leaderboardService: LeaderboardService) { }

  async ngOnInit(): Promise<void> {
    await this.leaderboardService.getLeaderboard(this.pageNo, this.pageSize).subscribe(
      (data) => {
        this.leaderboardData = data;
      });
    console.log('Leaderboard data:', this.leaderboardData);
  }

  //how are you going tho change page?

}
