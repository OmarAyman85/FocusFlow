# 🧠 FocusFlow

**FocusFlow** is a collaborative workspace and task management app built with **Flutter** and **Firebase**, designed to help teams stay productive and aligned. It features workspaces, projects, Kanban-style task boards, real-time collaboration, and clean architecture for scalable development.

---

## 📌 Features

- 🔐 Authentication with Firebase
- 👥 Workspace & Project Management
- 🧩 Kanban-Style Task Boards
- 🗨️ Task Comments & Activity Logs
- 📱 Cross-platform (iOS, Android, Web)
- 🧱 Clean Architecture with feature-first modularization

---

## 🧭 App Workflow (User Flow Breakdown)

Here's how the user moves through the app — this flow maps to features in the folder structure:

### 1. **Auth Feature**
- Signup/login (via Firebase Auth)
- Store user info in Firestore under `/users`

### 2. **Workspace Feature**
- After login, user can:
  - Create or join a **workspace**
  - Inside a workspace, create/view **projects**

### 3. **TaskBoard Feature**
- Select a project
- Inside a project:
  - Show Kanban board
  - Manage columns (To Do, In Progress, Done)
  - Add/edit tasks, assign users, add comments

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

## 🧠 Clean Architecture 

Clean architecture divides your app into three layers:

1. **Presentation Layer** – UI + state management
2. **Domain Layer** – Business logic, use cases, abstract repositories
3. **Data Layer** – Firebase or any other data source implementation

Each **feature** is isolated in its own folder (`features/auth`, `features/workspace`, `features/workspace`, etc.), and follows this layered design internally.

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
│   ├── workspace/
|   |   ├── data/
│   |   |   ├── workspace_repository_impl.dart
│   |   |   └── project_repository_impl.dart
|   |   ├── domain/
|   |   │   ├── entities/
│   │   |   |   ├── workspace.dart
│   │   |   |   └── project.dart
│   |   |   ├── repositories/
│   |   |   │   ├── workspace_repository.dart
│   |   |   │   └── project_repository.dart
│   |   |   └── usecases/
│   |   |   |   ├── create_workspace.dart
│   |   |   |   ├── create_project.dart
│   |   |   |   ├── list_projects.dart
│   |   |   |   └── join_workspace.dart
│   |   ├── presentation/
│   |   │   ├── workspace_screen.dart
│   |   │   └── project_selector_widget.dart
│   │
│   ├── taskboard/              # Kanban-style task boards
│       ├── data/
│       ├── domain/
│       └── presentation/
│
└── main.dart                   # App entry point
```

---

## ✅ Summary: Why This Structure Works

| Layer        | Purpose                                | Real Example                         |
|--------------|-----------------------------------------|--------------------------------------|
| `features/`  | Modularize by feature                   | Auth, Workspace, TaskBoard           |
| `domain/`    | Abstract business logic                 | `CreateProjectUseCase`, `Project`    |
| `data/`      | Firebase implementations                | Reads/writes Firestore               |
| `presentation/` | UI & state management               | `ProjectListScreen`, `TaskCard`      |
| `core/`      | Shared stuff like constants, errors     | Network checker, validators          |

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

## 🔄 Data Relationships (Firebase Schema Mapping)

```
users/{userId}
workspaces/{workspaceId}
projects/{projectId} → has workspaceId
taskBoards/{boardId} → has projectId
tasks/{taskId} → has boardId
```
---

## 📃 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---
