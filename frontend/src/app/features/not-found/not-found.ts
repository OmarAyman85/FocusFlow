import { Component } from '@angular/core';
import { RouterLink } from '@angular/router';

@Component({
  selector: 'app-not-found',
  standalone: true,
  imports: [RouterLink],
  template: `
    <div class="min-h-screen flex flex-col items-center justify-center gap-3 text-center px-4">
      <h1 class="text-3xl font-bold text-slate-900">Page not found</h1>
      <p class="text-slate-500">The page you're looking for doesn't exist.</p>
      <a routerLink="/dashboard" class="text-indigo-600 font-medium hover:underline">Back to dashboard</a>
    </div>
  `,
})
export class NotFound {}
