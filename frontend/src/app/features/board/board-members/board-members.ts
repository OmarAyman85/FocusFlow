import { Component, EventEmitter, Input, Output, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule, FormBuilder, Validators } from '@angular/forms';
import { BoardMember, BoardRole } from '../../../core/models/board-member.model';

@Component({
  selector: 'app-board-members',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  templateUrl: './board-members.html',
})
export class BoardMembers {
  private fb = inject(FormBuilder);

  @Input() members: BoardMember[] = [];
  @Input() canManage = false;
  @Input() isOwner = false;
  @Input() currentUserId: number | null = null;

  @Output() close = new EventEmitter<void>();
  @Output() invite = new EventEmitter<string>();
  @Output() roleChange = new EventEmitter<{ userId: number; role: BoardRole }>();
  @Output() removeMember = new EventEmitter<number>();

  readonly roles: BoardRole[] = ['owner', 'admin', 'member', 'viewer'];

  readonly inviteForm = this.fb.group({
    email: ['', [Validators.required, Validators.email]],
  });

  submitInvite(): void {
    if (this.inviteForm.invalid) return;
    this.invite.emit(this.inviteForm.getRawValue().email!);
    this.inviteForm.reset();
  }

  onRoleSelect(userId: number, event: Event): void {
    const role = (event.target as HTMLSelectElement).value as BoardRole;
    this.roleChange.emit({ userId, role });
  }
}
