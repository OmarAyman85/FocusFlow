import { Component, inject, signal } from '@angular/core';
import { ReactiveFormsModule, FormBuilder, Validators } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { BoardService } from '../../core/services/board.service';
import { BoardSummary } from '../../core/models/board.model';
import { Navbar } from '../../layout/navbar/navbar';

type Tab = 'mine' | 'shared' | 'public';

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [ReactiveFormsModule, RouterLink, Navbar],
  templateUrl: './dashboard.html',
})
export class Dashboard {
  private boardService = inject(BoardService);
  private fb = inject(FormBuilder);
  private router = inject(Router);

  readonly tabs: Tab[] = ['mine', 'shared', 'public'];
  readonly tab = signal<Tab>('mine');
  readonly boards = signal<BoardSummary[]>([]);
  readonly loading = signal(true);
  readonly showCreate = signal(false);
  readonly errorMessage = signal<string | null>(null);

  readonly createForm = this.fb.group({
    name: ['', [Validators.required, Validators.minLength(2)]],
    description: [''],
    visibility: ['private' as 'private' | 'public'],
  });

  constructor() {
    this.loadTab('mine');
  }

  tabLabel(tab: Tab): string {
    return tab === 'mine' ? 'My Boards' : tab === 'shared' ? 'Shared with me' : 'Public boards';
  }

  selectTab(tab: Tab): void {
    this.tab.set(tab);
    this.loadTab(tab);
  }

  private loadTab(tab: Tab): void {
    this.loading.set(true);
    const source =
      tab === 'mine'
        ? this.boardService.getMyBoards()
        : tab === 'shared'
          ? this.boardService.getSharedBoards()
          : this.boardService.getPublicBoards();

    source.subscribe({
      next: (boards) => {
        this.boards.set(boards);
        this.loading.set(false);
      },
      error: () => this.loading.set(false),
    });
  }

  openCreate(): void {
    this.showCreate.set(true);
  }

  closeCreate(): void {
    this.showCreate.set(false);
    this.createForm.reset({ visibility: 'private' });
  }

  submitCreate(): void {
    if (this.createForm.invalid) {
      this.createForm.markAllAsTouched();
      return;
    }
    this.errorMessage.set(null);
    const value = this.createForm.getRawValue();
    this.boardService
      .createBoard({
        name: value.name!,
        description: value.description ?? undefined,
        visibility: value.visibility ?? 'private',
      })
      .subscribe({
        next: (board) => {
          this.closeCreate();
          this.router.navigate(['/boards', board.id]);
        },
        error: (err) => this.errorMessage.set(err.error?.message ?? 'Could not create board'),
      });
  }
}
