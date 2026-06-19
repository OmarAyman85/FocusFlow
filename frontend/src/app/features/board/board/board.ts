import { Component, computed, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule, FormBuilder, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { CdkDropListGroup, CdkDragDrop, moveItemInArray, transferArrayItem } from '@angular/cdk/drag-drop';

import { BoardService } from '../../../core/services/board.service';
import { ListService } from '../../../core/services/list.service';
import { CardService } from '../../../core/services/card.service';
import { AuthService } from '../../../core/services/auth.service';
import { Board as BoardModel, Visibility } from '../../../core/models/board.model';
import { List } from '../../../core/models/list.model';
import { Card } from '../../../core/models/card.model';
import { BoardRole } from '../../../core/models/board-member.model';

import { Navbar } from '../../../layout/navbar/navbar';
import { BoardList } from '../board-list/board-list';
import { CardDetail } from '../card-detail/card-detail';
import { BoardMembers } from '../board-members/board-members';
import { BoardSettings } from '../board-settings/board-settings';

@Component({
  selector: 'app-board',
  standalone: true,
  imports: [
    CommonModule,
    ReactiveFormsModule,
    CdkDropListGroup,
    Navbar,
    BoardList,
    CardDetail,
    BoardMembers,
    BoardSettings,
  ],
  templateUrl: './board.html',
})
export class BoardPage {
  private route = inject(ActivatedRoute);
  private router = inject(Router);
  private boardService = inject(BoardService);
  private listService = inject(ListService);
  private cardService = inject(CardService);
  auth = inject(AuthService);
  private fb = inject(FormBuilder);

  readonly boardId = Number(this.route.snapshot.paramMap.get('id'));
  readonly board = signal<BoardModel | null>(null);
  readonly loading = signal(true);
  readonly errorMessage = signal<string | null>(null);

  readonly activeCard = signal<Card | null>(null);
  readonly showMembers = signal(false);
  readonly showSettings = signal(false);
  readonly addingList = signal(false);

  readonly listForm = this.fb.group({ name: ['', Validators.required] });

  readonly myMembership = computed(() => {
    const b = this.board();
    const userId = this.auth.currentUser()?.id;
    if (!b || !userId) return null;
    return b.memberships.find((m) => m.userId === userId) ?? null;
  });

  readonly canWrite = computed(() =>
    ['owner', 'admin', 'member'].includes(this.myMembership()?.role ?? '')
  );
  readonly canManage = computed(() => ['owner', 'admin'].includes(this.myMembership()?.role ?? ''));
  readonly isOwner = computed(() => this.myMembership()?.role === 'owner');

  constructor() {
    this.load();
  }

  private load(): void {
    this.loading.set(true);
    this.boardService.getBoard(this.boardId).subscribe({
      next: (board) => {
        this.board.set(board);
        this.loading.set(false);
      },
      error: (err) => {
        this.loading.set(false);
        this.errorMessage.set(err.error?.message ?? 'Could not load board');
      },
    });
  }

  submitAddList(): void {
    if (this.listForm.invalid) return;
    const name = this.listForm.getRawValue().name!;
    this.listService.createList(this.boardId, name).subscribe((list) => {
      this.board.update((b) => (b ? { ...b, lists: [...b.lists, { ...list, cards: [] }] } : b));
      this.listForm.reset();
      this.addingList.set(false);
    });
  }

  /** Angular's zoneless change detection skips a child whose @Input reference is
   * unchanged, so list/card updates must replace every nested level (board, lists,
   * the affected list, its cards) rather than mutate in place. */
  private updateList(listId: number, fn: (list: List) => List): void {
    this.board.update((b) =>
      b ? { ...b, lists: b.lists.map((l) => (l.id === listId ? fn(l) : l)) } : b
    );
  }

  renameList(list: List, name: string): void {
    this.listService.updateList(this.boardId, list.id, name).subscribe(() => {
      this.updateList(list.id, (l) => ({ ...l, name }));
    });
  }

  deleteList(list: List): void {
    if (!confirm(`Delete list "${list.name}" and all its cards?`)) return;
    this.listService.deleteList(this.boardId, list.id).subscribe(() => {
      this.board.update((b) => (b ? { ...b, lists: b.lists.filter((l) => l.id !== list.id) } : b));
    });
  }

  addCard(list: List, title: string): void {
    this.cardService.createCard(this.boardId, list.id, { title }).subscribe((card) => {
      this.updateList(list.id, (l) => ({ ...l, cards: [...l.cards, card] }));
    });
  }

  onCardClicked(card: Card): void {
    this.activeCard.set(card);
  }

  onCardDropped(event: CdkDragDrop<Card[]>): void {
    const movedCard: Card = event.item.data;
    const board = this.board();
    if (!board) return;

    const sourceList = board.lists.find((l) => l.cards === event.previousContainer.data);
    const targetList = board.lists.find((l) => l.cards === event.container.data);
    if (!sourceList || !targetList) return;

    if (event.previousContainer === event.container) {
      moveItemInArray(event.container.data, event.previousIndex, event.currentIndex);
    } else {
      transferArrayItem(
        event.previousContainer.data,
        event.container.data,
        event.previousIndex,
        event.currentIndex
      );
    }

    // CDK mutates the bound arrays in place; give the affected lists fresh
    // references (reusing the now-correct contents) so the view notices.
    const targetCards = [...targetList.cards];
    this.board.update((b) =>
      b
        ? {
            ...b,
            lists: b.lists.map((l) => {
              if (l.id === targetList.id) return { ...l, cards: targetCards };
              if (l.id === sourceList.id) return { ...l, cards: [...sourceList.cards] };
              return l;
            }),
          }
        : b
    );

    this.cardService
      .moveCard(this.boardId, {
        cardId: movedCard.id,
        sourceListId: sourceList.id,
        targetListId: targetList.id,
        orderedCardIdsInTargetList: targetCards.map((c) => c.id),
      })
      .subscribe();
  }

  saveCard(updates: Partial<Card>): void {
    const card = this.activeCard();
    if (!card) return;
    this.cardService.updateCard(this.boardId, card.id, updates).subscribe((updated) => {
      this.updateList(card.listId, (l) => ({
        ...l,
        cards: l.cards.map((c) => (c.id === card.id ? { ...c, ...updated } : c)),
      }));
      this.activeCard.set(null);
    });
  }

  assignCard(assigneeId: number | null): void {
    const card = this.activeCard();
    if (!card) return;
    this.cardService.assignCard(this.boardId, card.id, assigneeId).subscribe((updated) => {
      const member = this.board()?.memberships.find((m) => m.userId === assigneeId);
      const assignee = member?.user ?? null;
      this.updateList(card.listId, (l) => ({
        ...l,
        cards: l.cards.map((c) => (c.id === card.id ? { ...c, ...updated, assignee } : c)),
      }));
      this.activeCard.set({ ...card, ...updated, assignee });
    });
  }

  deleteCard(): void {
    const card = this.activeCard();
    if (!card) return;
    if (!confirm('Delete this card?')) return;
    this.cardService.deleteCard(this.boardId, card.id).subscribe(() => {
      this.updateList(card.listId, (l) => ({ ...l, cards: l.cards.filter((c) => c.id !== card.id) }));
      this.activeCard.set(null);
    });
  }

  inviteMember(email: string): void {
    this.boardService.inviteMember(this.boardId, email).subscribe({
      next: () => this.load(),
      error: (err) => alert(err.error?.message ?? 'Could not invite member'),
    });
  }

  changeMemberRole(event: { userId: number; role: BoardRole }): void {
    this.boardService.updateMemberRole(this.boardId, event.userId, event.role).subscribe(() => this.load());
  }

  removeMember(userId: number): void {
    this.boardService.removeMember(this.boardId, userId).subscribe(() => this.load());
  }

  saveSettings(updates: { name: string; description: string }): void {
    this.boardService.updateBoard(this.boardId, updates).subscribe((updated) => {
      this.board.update((b) => (b ? { ...b, ...updated } : b));
    });
  }

  changeVisibility(visibility: Visibility): void {
    this.boardService.setVisibility(this.boardId, visibility).subscribe((updated) => {
      this.board.update((b) => (b ? { ...b, ...updated } : b));
    });
  }

  deleteBoard(): void {
    if (!confirm('Delete this board permanently?')) return;
    this.boardService.deleteBoard(this.boardId).subscribe(() => this.router.navigate(['/dashboard']));
  }

  leaveBoard(): void {
    if (!confirm('Leave this board?')) return;
    this.boardService.leaveBoard(this.boardId).subscribe(() => this.router.navigate(['/dashboard']));
  }
}
