import { Card } from './card.model';

export interface List {
  id: number;
  boardId: number;
  name: string;
  position: number;
  cards: Card[];
}
