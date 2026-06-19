import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Board, BoardSummary, Visibility } from '../models/board.model';
import { BoardMember, BoardRole } from '../models/board-member.model';

@Injectable({ providedIn: 'root' })
export class BoardService {
  constructor(private http: HttpClient) {}

  getMyBoards(): Observable<BoardSummary[]> {
    return this.http.get<BoardSummary[]>('/api/boards/mine');
  }

  getSharedBoards(): Observable<BoardSummary[]> {
    return this.http.get<BoardSummary[]>('/api/boards/shared');
  }

  getPublicBoards(): Observable<BoardSummary[]> {
    return this.http.get<BoardSummary[]>('/api/boards/public');
  }

  getBoard(boardId: number): Observable<Board> {
    return this.http.get<Board>(`/api/boards/${boardId}`);
  }

  createBoard(payload: { name: string; description?: string; visibility?: Visibility }): Observable<BoardSummary> {
    return this.http.post<BoardSummary>('/api/boards', payload);
  }

  updateBoard(boardId: number, payload: { name?: string; description?: string }): Observable<BoardSummary> {
    return this.http.put<BoardSummary>(`/api/boards/${boardId}`, payload);
  }

  setVisibility(boardId: number, visibility: Visibility): Observable<BoardSummary> {
    return this.http.patch<BoardSummary>(`/api/boards/${boardId}/visibility`, { visibility });
  }

  deleteBoard(boardId: number): Observable<{ message: string }> {
    return this.http.delete<{ message: string }>(`/api/boards/${boardId}`);
  }

  joinBoard(boardId: number): Observable<BoardMember> {
    return this.http.post<BoardMember>(`/api/boards/${boardId}/join`, {});
  }

  leaveBoard(boardId: number): Observable<{ message: string }> {
    return this.http.post<{ message: string }>(`/api/boards/${boardId}/leave`, {});
  }

  getMembers(boardId: number): Observable<BoardMember[]> {
    return this.http.get<BoardMember[]>(`/api/boards/${boardId}/members`);
  }

  inviteMember(boardId: number, email: string): Observable<BoardMember> {
    return this.http.post<BoardMember>(`/api/boards/${boardId}/members`, { email });
  }

  updateMemberRole(boardId: number, userId: number, role: BoardRole): Observable<BoardMember> {
    return this.http.patch<BoardMember>(`/api/boards/${boardId}/members/${userId}`, { role });
  }

  removeMember(boardId: number, userId: number): Observable<{ message: string }> {
    return this.http.delete<{ message: string }>(`/api/boards/${boardId}/members/${userId}`);
  }
}
