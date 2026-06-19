import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Card, Priority } from '../models/card.model';

export interface MoveCardPayload {
  cardId: number;
  sourceListId: number;
  targetListId: number;
  orderedCardIdsInTargetList: number[];
}

@Injectable({ providedIn: 'root' })
export class CardService {
  constructor(private http: HttpClient) {}

  createCard(
    boardId: number,
    listId: number,
    payload: { title: string; description?: string; priority?: Priority; dueDate?: string }
  ): Observable<Card> {
    return this.http.post<Card>(`/api/boards/${boardId}/lists/${listId}/cards`, payload);
  }

  updateCard(
    boardId: number,
    cardId: number,
    payload: Partial<Pick<Card, 'title' | 'description' | 'priority' | 'dueDate'>>
  ): Observable<Card> {
    return this.http.put<Card>(`/api/boards/${boardId}/cards/${cardId}`, payload);
  }

  deleteCard(boardId: number, cardId: number): Observable<{ message: string }> {
    return this.http.delete<{ message: string }>(`/api/boards/${boardId}/cards/${cardId}`);
  }

  assignCard(boardId: number, cardId: number, assigneeId: number | null): Observable<Card> {
    return this.http.patch<Card>(`/api/boards/${boardId}/cards/${cardId}/assign`, { assigneeId });
  }

  moveCard(boardId: number, payload: MoveCardPayload): Observable<Card> {
    return this.http.patch<Card>(`/api/boards/${boardId}/cards/move`, payload);
  }
}
