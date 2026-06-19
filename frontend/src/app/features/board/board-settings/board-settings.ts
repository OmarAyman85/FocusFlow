import { Component, EventEmitter, Input, Output, OnChanges, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule, FormBuilder, Validators } from '@angular/forms';
import { Board, Visibility } from '../../../core/models/board.model';

@Component({
  selector: 'app-board-settings',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  templateUrl: './board-settings.html',
})
export class BoardSettings implements OnChanges {
  private fb = inject(FormBuilder);

  @Input({ required: true }) board!: Board;
  @Input() isOwner = false;
  @Input() canManage = false;

  @Output() close = new EventEmitter<void>();
  @Output() save = new EventEmitter<{ name: string; description: string }>();
  @Output() visibilityChange = new EventEmitter<Visibility>();
  @Output() deleteBoard = new EventEmitter<void>();
  @Output() leaveBoard = new EventEmitter<void>();

  readonly form = this.fb.group({
    name: ['', Validators.required],
    description: [''],
  });

  ngOnChanges(): void {
    this.form.setValue({ name: this.board.name, description: this.board.description ?? '' });
  }

  submit(): void {
    if (this.form.invalid) return;
    const value = this.form.getRawValue();
    this.save.emit({ name: value.name!, description: value.description ?? '' });
  }

  toggleVisibility(): void {
    this.visibilityChange.emit(this.board.visibility === 'public' ? 'private' : 'public');
  }
}
