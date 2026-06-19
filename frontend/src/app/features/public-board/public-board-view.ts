import { Component, computed, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, Router, RouterLink } from '@angular/router';
import { BoardService } from '../../core/services/board.service';
import { AuthService } from '../../core/services/auth.service';
import { Board } from '../../core/models/board.model';

@Component({
  selector: 'app-public-board-view',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './public-board-view.html',
})
export class PublicBoardView {
  private route = inject(ActivatedRoute);
  private router = inject(Router);
  private boardService = inject(BoardService);
  auth = inject(AuthService);

  readonly boardId = Number(this.route.snapshot.paramMap.get('id'));
  readonly board = signal<Board | null>(null);
  readonly loading = signal(true);
  readonly errorMessage = signal<string | null>(null);
  readonly joining = signal(false);

  readonly isMember = computed(() => {
    const userId = this.auth.currentUser()?.id;
    return !!userId && !!this.board()?.memberships.some((m) => m.userId === userId);
  });

  constructor() {
    this.boardService.getBoard(this.boardId).subscribe({
      next: (board) => {
        this.board.set(board);
        this.loading.set(false);
      },
      error: (err) => {
        this.loading.set(false);
        this.errorMessage.set(err.error?.message ?? 'This board is not available');
      },
    });
  }

  join(): void {
    this.joining.set(true);
    this.boardService.joinBoard(this.boardId).subscribe({
      next: () => this.router.navigate(['/boards', this.boardId]),
      error: (err) => {
        this.joining.set(false);
        alert(err.error?.message ?? 'Could not join board');
      },
    });
  }
}
