export interface User {
  id: number;
  name: string;
  email: string;
  role: 'user' | 'admin';
  profileImage: string | null;
}

export interface AuthResponse extends User {
  token: string;
}
