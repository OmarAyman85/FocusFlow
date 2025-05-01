# focusflow

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Folder Structure

lib/
│
├── core/                        # Shared utilities, constants, themes, etc.
│   ├── errors/
│   ├── usecases/
│   └── utils/
│
├── features/
│   ├── auth/                    # Authentication feature
│   │   ├── data/                # FirebaseAuth implementation
│   │   ├── domain/              # Repositories and usecases
│   │   └── presentation/        # UI: login/signup screens
│   │
│   ├── workspace/               # Workspaces & Projects
│   │   ├── data/                # Firebase workspace/project providers
│   │   ├── domain/              # Entities & usecases
│   │   └── presentation/        # UI widgets, screens
│   │
│   ├── taskboard/              # Task Board (Kanban) logic
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│
├── app/                        # Main app setup
│   ├── router/                 # GoRouter or Navigator setup
│   ├── theme/
│   └── app.dart                # App widget
│
└── main.dart

