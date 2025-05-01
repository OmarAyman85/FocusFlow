# 🧠 FocusFlow

**FocusFlow** is a collaborative workspace and task management app built with **Flutter** and **Firebase**, designed to help teams stay productive and aligned. It features workspaces, projects, Kanban-style task boards, real-time collaboration, and clean architecture for scalable development.

---

## 🚀 Getting Started

This project serves as a clean starting point for building production-grade Flutter applications using Firebase and Clean Architecture.

### Prerequisites

- Flutter SDK (latest stable)
- Dart SDK
- Firebase project setup (Authentication + Firestore)
- IDE: VSCode or Android Studio

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/OmarAyman85/focusflow.git
   cd focusflow
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

### Helpful Resources

- [Flutter Docs](https://docs.flutter.dev/)
- [Write Your First Flutter App](https://docs.flutter.dev/get-started/codelab)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)

---

## 🗂️ Project Structure

```plaintext
lib/
│
├── app/                        # Main app setup
│   ├── router/                 # App routing with GoRouter/Navigator
│   ├── theme/                  # Global theme configuration
│   └── app.dart                # Root app widget
│
├── core/                       # Reusable core utilities and configurations
│   ├── errors/                 # Error handling and exceptions
│   ├── usecases/               # Common application usecases
│   └── utils/                  # Helpers, extensions, etc.
│
├── features/                   # Feature-first architecture
│   ├── auth/                   # Authentication (Login/Signup)
│   │   ├── data/               # FirebaseAuth data layer
│   │   ├── domain/             # Abstract repo + usecases
│   │   └── presentation/       # UI and state management
│   │
│   ├── workspace/              # Workspace & Project logic
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── taskboard/              # Kanban-style task boards
│       ├── data/
│       ├── domain/
│       └── presentation/
│
└── main.dart                   # App entry point
```

---

## 🔥 Firebase Firestore Schema

```plaintext
users (collection)
└── {userId}
    ├── name
    ├── email
    └── photoUrl

workspaces (collection)
└── {workspaceId}
    ├── name
    ├── ownerId
    └── members: [userId1, userId2]

projects (collection)
└── {projectId}
    ├── workspaceId
    ├── name
    ├── description
    ├── createdAt
    └── members: [userId1, userId2]

taskBoards (collection)
└── {boardId}
    ├── projectId
    ├── name
    └── columns: ["To Do", "In Progress", "Done"]

tasks (collection)
└── {taskId}
    ├── boardId
    ├── title
    ├── description
    ├── status: "To Do" | "In Progress" | "Done"
    ├── assignedTo: userId
    ├── dueDate
    └── activityLog: [
          {
            userId,
            action: "moved to Done",
            timestamp
          }
        ]

comments (subcollection of task)
└── tasks/{taskId}/comments/{commentId}
    ├── userId
    ├── text
    └── timestamp
```

---

## 📌 Features

- 🔐 Authentication with Firebase
- 👥 Workspace & Project Management
- 🧩 Kanban-Style Task Boards
- 🗨️ Task Comments & Activity Logs
- 📱 Cross-platform (iOS, Android, Web)
- 🧱 Clean Architecture with feature-first modularization

---

## 📃 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---
