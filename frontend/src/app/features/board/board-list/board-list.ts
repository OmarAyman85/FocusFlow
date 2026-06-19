import { Component, EventEmitter, Input, Output, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule, FormBuilder, Validators } from '@angular/forms';
import { CdkDropList, CdkDrag, CdkDragDrop } from '@angular/cdk/drag-drop';
import { List } from '../../../core/models/list.model';
import { Card } from '../../../core/models/card.model';
import { BoardCard } from '../board-card/board-card';

@Component({
  selector: 'app-board-list',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, CdkDropList, CdkDrag, BoardCard],
  templateUrl: './board-list.html',
})
export class BoardList {
  private fb = inject(FormBuilder);

  @Input({ required: true }) list!: List;
  @Input() canWrite = false;

  @Output() dropped = new EventEmitter<CdkDragDrop<Card[]>>();
  @Output() rename = new EventEmitter<string>();
  @Output() deleteList = new EventEmitter<void>();
  @Output() addCard = new EventEmitter<string>();
  @Output() cardClicked = new EventEmitter<Card>();

  readonly editingName = signal(false);
  readonly addingCard = signal(false);

  readonly nameForm = this.fb.group({ name: ['', Validators.required] });
  readonly cardForm = this.fb.group({ title: ['', Validators.required] });

  startRename(): void {
    this.nameForm.setValue({ name: this.list.name });
    this.editingName.set(true);
  }

  submitRename(): void {
    if (this.nameForm.invalid) return;
    this.rename.emit(this.nameForm.getRawValue().name!);
    this.editingName.set(false);
  }

  startAddCard(): void {
    this.addingCard.set(true);
  }

  submitAddCard(): void {
    if (this.cardForm.invalid) return;
    this.addCard.emit(this.cardForm.getRawValue().title!);
    this.cardForm.reset();
    this.addingCard.set(false);
  }
}
