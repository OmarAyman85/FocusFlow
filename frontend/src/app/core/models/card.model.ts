import { User } from './user.model';

export type Priority = 'low' | 'medium' | 'high';

export interface Card {
  id: number;
  listId: number;
  boardId: number;
  title: string;
  description: string | null;
  priority: Priority;
  dueDate: string | null;
  assigneeId: number | null;
  assignee?: User | null;
  position: number;
}
