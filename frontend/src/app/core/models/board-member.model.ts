import { User } from './user.model';

export type BoardRole = 'owner' | 'admin' | 'member' | 'viewer';

export interface BoardMember {
  id: number;
  boardId: number;
  userId: number;
  role: BoardRole;
  user: User;
}
