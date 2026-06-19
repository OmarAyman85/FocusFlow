import { Component, EventEmitter, Input, Output, OnChanges, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule, FormBuilder, Validators } from '@angular/forms';
import { Card } from '../../../core/models/card.model';
import { BoardMember } from '../../../core/models/board-member.model';

@Component({
  selector: 'app-card-detail',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  templateUrl: './card-detail.html',
})
export class CardDetail implements OnChanges {
  private fb = inject(FormBuilder);

  @Input({ required: true }) card!: Card;
  @Input() members: BoardMember[] = [];
  @Input() canWrite = false;

  @Output() close = new EventEmitter<void>();
  @Output() save = new EventEmitter<Partial<Card>>();
  @Output() assign = new EventEmitter<number | null>();
  @Output() delete = new EventEmitter<void>();

  readonly form = this.fb.group({
    title: ['', Validators.required],
    description: [''],
    priority: ['medium' as Card['priority']],
    dueDate: [''],
  });

  ngOnChanges(): void {
    this.form.setValue({
      title: this.card.title,
      description: this.card.description ?? '',
      priority: this.card.priority,
      dueDate: this.card.dueDate ? this.card.dueDate.substring(0, 10) : '',
    });
  }

  submit(): void {
    if (this.form.invalid) return;
    const value = this.form.getRawValue();
    this.save.emit({
      title: value.title!,
      description: value.description || undefined,
      priority: value.priority!,
      dueDate: value.dueDate || undefined,
    });
  }

  onAssigneeChange(event: Event): void {
    const value = (event.target as HTMLSelectElement).value;
    this.assign.emit(value ? Number(value) : null);
  }
}
