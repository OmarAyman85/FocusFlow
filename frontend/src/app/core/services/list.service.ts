import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { List } from '../models/list.model';

@Injectable({ providedIn: 'root' })
export class ListService {
  constructor(private http: HttpClient) {}

  createList(boardId: number, name: string): Observable<List> {
    return this.http.post<List>(`/api/boards/${boardId}/lists`, { name });
  }

  updateList(boardId: number, listId: number, name: string): Observable<List> {
    return this.http.put<List>(`/api/boards/${boardId}/lists/${listId}`, { name });
  }

  deleteList(boardId: number, listId: number): Observable<{ message: string }> {
    return this.http.delete<{ message: string }>(`/api/boards/${boardId}/lists/${listId}`);
  }

  reorderLists(boardId: number, orderedListIds: number[]): Observable<List[]> {
    return this.http.patch<List[]>(`/api/boards/${boardId}/lists/reorder`, { orderedListIds });
  }
}
