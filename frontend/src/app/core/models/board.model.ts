import { User } from './user.model';
import { List } from './list.model';
import { BoardMember } from './board-member.model';

export type Visibility = 'private' | 'public';

export interface BoardSummary {
  id: number;
  name: string;
  description: string | null;
  visibility: Visibility;
  ownerId: number;
  myRole?: BoardMember['role'];
}

export interface Board extends BoardSummary {
  owner: User;
  lists: List[];
  memberships: BoardMember[];
}
