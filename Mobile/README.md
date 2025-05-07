# 🧠 FocusFlow

**FocusFlow** is a collaborative workspace and task management app built with **Flutter** and **Firebase**, designed to help teams stay productive, aligned, and on schedule. It supports real-time collaboration, Kanban-style boards, Gantt chart visualization, and a modular clean architecture approach for scalable development.

---

## 📌 Features

### 🔐 1. User Authentication

- Sign up, log in, and log out using Firebase Authentication.
- Basic user profile Page.

### 🧩 2. Workspace Dashboard

- View all workspaces the user is part of.
- Each workspace displays a short description, member count and Task boards count.

### 🗂️ 3. Workspace Details Page

- View list of boards inside the selected workspace.
- Create new boards.

### 📋 4. Board Details Page

- Each board includes a Kanban layout with task cards.
- Tasks have a title, description, status (To-Do, In Progress, Done), priority (Low, Medium, High) and optional due date.

### 👥 5. Task Assignment

- Assign tasks to specific users within each board in each workspace.

### 📆 6. Gantt Chart

- Visualize task durations and dependencies across the board.

### 🔔 7. Notifications

- Simulated email notifications (via console logs) when tasks are assigned.

### 🧱 8. Custom Drag-and-Drop Kanban Board

- Interactive task management using drag-and-drop between status columns.

---

## 🧭 App Workflow Overview

### 1. **Authentication**

- Users sign up or log in via Firebase Auth.
- User details stored in Firestore under `/users`.

### 2. **Workspace Flow**

- Users land on their workspace dashboard post-authentication.
- Users can create new workspaces or join existing ones.

### 3. **Board & Task Management**

- Inside each workspace, users manage boards.
- Boards contain drag-and-drop task columns and Gantt chart timelines.
- Tasks are assignable and editable with real-time sync.

---

## 🚀 Future Improvements

- 🔐 Workspace roles and permission control (admin, member).
- 🔗 Firebase Storage for file uploads (attachments, avatars, profile pictures, etc...).
- 📶 Offline access via local storage caching.
- 📱 Push notifications for mobile and web.
- 🌓 UI theming: Dark mode support.
- 🔁 Real-time sync with Firebase listeners or WebSockets.

---

## 🛠️ Tech Stack

- **Frontend**: Flutter (iOS, Android, Web)
- **Backend**: Firebase (Auth, Firestore, Storage)
- **Architecture**: Clean Architecture (Domain, Data, Presentation)
- **State Management**: Cubit (Bloc)
- **UI**: Modular widget components and drag-and-drop functionality

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
   git clone https://github.com/OmarAyman85/FocusFlow.git
   cd Mobile
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

FocusFlow follows a **feature-first Clean Architecture** approach, ensuring scalability, testability, and separation of concerns. The app is structured into three well-defined layers:

1. **Presentation Layer**

   - Contains UI widgets, pages, and Cubit-based state management.
   - Handles user interactions and reflects state changes.

2. **Domain Layer**

   - Encapsulates core business logic through **use cases**.
   - Defines abstract **repositories** and **entities**, independent of external dependencies.

3. **Data Layer**
   - Implements the repositories using **Firebase** as the data source.
   - Handles all communication with Firestore, Firebase Auth, and Firebase Storage.

### 🔧 Modular Feature Structure

Each major feature is self-contained under the `features/` directory in its own folder (`features/auth`, `features/workspace`, `features/board`, `features/task`), and follows the same internal structure.

---

## 🗂️ Project Structure

```plaintextlib/
│
├── app/                        # Main app setup
│   ├── app.dart                # Root app widget
│   └── router.dart             # App routing with GoRouter/Navigator
│
├── core/                       # Reusable core utilities and configurations
│   ├── entities/               # Core entities, base classes
│   ├── errors/                 # Error handling and failures
│   ├── injection/              # Dependency injection (GetIt)
│   ├── services/               # Shared services (Auth, Members addition)
│   ├── theme/                  # Global theme configuration
│   ├── utils/                  # Helper functions, extensions, utilities
│   └── widgets/                # Reusable widgets (buttons, loaders, etc.)
│
├── features/                   # Feature-first architecture (separation of concerns)
│   │
│   ├── auth/                   # Authentication (Login/Signup/Signout)
│   │   ├── data/               # FirebaseAuth data layer
│   │   │   ├── models/         # Data models specific to auth
│   │   │   ├── repositories/   # Auth-related data repository
│   │   │   └── sources/        # Auth-related Data sources (e.g., Firestore, local storage)
│   │   ├── domain/             # Domain layer (business logic)
│   │   │   ├── entities/       # Auth-related domain entities
│   │   │   ├── repositories/   # Auth-related repositories
│   │   │   └── usecases/       # Usecases for managing authentication
│   │   └── presentation/       # UI and state management (e.g., Cubit, BLoC)
│   │       ├── bloc/           # State management logic (BLoC)
│   │       ├── pages/          # Authentication pages (Login, SignUp, Profile Picture)
│   │       └── widgets/        # Authentication UI components (form fields, buttons)
│   │
│   ├── board/                  # Board management (workspace, tasks, etc.)
│   │   ├── data/               # Data layer (models, repositories, sources)
│   │   │   ├── models/         # Board-related data models
│   │   │   ├── repositories/   # Board-related data repositories implementation
│   │   │   └── sources/        # Data sources (e.g., Firestore, local storage)
│   │   ├── domain/             # Domain layer (business logic)
│   │   │   ├── entities/       # Board-related entities
│   │   │   ├── repositories/   # Board-related domain abstract repositories
│   │   │   └── usecases/       # Usecases for managing boards
│   │   └── presentation/       # UI and state management for boards
│   │       ├── cubit/          # State management (e.g., Cubit)
│   │       ├── pages/          # Pages related to boards (board list, board creation form)
│   │       └── widgets/        # UI components for boards (board cards, board form fields, etc.)
│   │
│   ├── task/                   # Task feature (CRUD, assignment, due dates, etc.)
│   │   ├── data/               # Handles data interactions (remote/local)
│   │   │   ├── models/         # Data transfer objects (DTOs) and serialization logic
│   │   │   ├── repositories/   # Implementation of domain repositories
│   │   │   └── sources/        # Data sources (e.g., Firestore, REST APIs)
│   │   ├── domain/             # Core business logic (platform-agnostic)
│   │   │   ├── entities/       # Plain Dart models representing task domain objects
│   │   │   ├── repositories/   # Abstract repositories (contract interfaces)
│   │   │   └── usecases/       # Task-specific actions (CreateTask, UpdateTask, etc.)
│   │   └── presentation/       # UI and user-facing logic
│   │       ├── cubit/          # Task-related state management (Cubit, Bloc)
│   │       ├── pages/          # Screens and routes (e.g., TaskDetailPage, TaskFormPage)
│   │       ├── services/       # Feature-specific services (e.g., task sorting, filtering)
│   │       ├── utils/          # Feature-specific utilities (e.g., date formatting, status parser)
│   │       └── widgets/        # Reusable UI components (e.g., TaskCard, AssigneeChips, PriorityBadge)
│   │
│   ├── workspace/              # Workspace management (team collaboration)
│   │   ├── data/               # Data layer (models, repositories, sources)
│   │   ├── domain/             # Domain layer (business logic)
│   │   └── presentation/       # UI and state management for workspaces
│   │       ├── cubit/          # State management (e.g., Cubit)
│   │       ├── pages/          # Pages related to workspaces (workspace list, details)
│   │       └── widgets/        # UI components for workspaces (workspace cards, etc.)
│   │
├── firebase_options.dart       # Firebase configuration
└── main.dart                   # App entry point

```

---

## 🔥 Firebase Database Schema

Firestore offers real-time data synchronization, offline support, and a flexible, schema-less structure — making it a strong choice for collaborative and mobile-first applications.

This document outlines the enhanced Firestore schema used for a collaborative workspace management application. The schema is structured to support scalable, real-time features such as task tracking, user collaboration, workspace management, and project organization.

---


## 📌 Collections Overview

```
users/{userId}
workspaces/{workspaceId}
workspaces/{workspaceId}/boards/{boardId}
workspaces/{workspaceId}/boards/{boardId}/tasks/{taskId}
```

---

```plaintext
users (collection) @ users/{userId}
└── {userId}
      ├── uid
      ├── name
      ├── email
      ├── password
      └── photoUrl

workspaces (collection) @ workspaces/{workspaceId}
└── {workspaceId}
      ├── name
      ├── description
      ├── numberOfBoards
      ├── numberOfMembers
      ├── createdBy: {userId, UserName}
      └── members: [
               {userId1, UserName1},
               {userId2, UserName2}
                     ]

boards (sub-collection) @ workspaces/{workspaceId}/boards/{boardId}
└── {boardId}
      ├── workspaceId
      ├── name
      ├── description
      ├── createdBy: {userId, UserName}
      ├── numberOfMembers
      ├── numberOfTasks
      └── members: [
              {userId1, UserName1},
               {userId2, UserName2}
                     ]

tasks (sub-collection) @ workspaces/{workspaceId}/boards/{boardId}/tasks/{taskId}
└── {taskId}
      ├── title
      ├── description
      ├── status: "To Do" | "In Progress" | "Done"
      ├── priority: "Low" | "Medium" | "High"
      ├── dueDate
      ├── createdAt
      ├── createdBy: {userId, UserName}
      ├── assignedTo: [
            {userId1, UserName1},
            {userId2, UserName2}
                     ]
      └── attachments: [{
            name
            url
            type
            uploadBy
            uploadAt
                      }]
```

---

## 👤 USERS :-

## users/{userId}

Stores information about each registered user.

| Field      | Type   | Description                                       |
| ---------- | ------ | ------------------------------------------------- |
| `uid`      | String | Firebase Auth UID (redundant for querying)        |
| `name`     | String | Full name of the user                             |
| `email`    | String | Unique email address                              |
| `password` | String | Hashed password (optional if using Firebase Auth) |
| `photoUrl` | String | Profile picture Urls in firebase storage          |

---

## 🏢 WORKSPACES :-

## workspaces/{workspaceId}

Represents a collaborative workspace that can contain multiple boards.

| Field             | Type   | Description                                 |
| ----------------- | ------ | ------------------------------------------- |
| `name`            | String | Name of the workspace                       |
| `description`     | String | Optional description of the workspace       |
| `numberOfMembers` | Number | Total number of members                     |
| `numberOfBoards`  | Number | Total number of boards within the workspace |
| `createdBy`       | Object | Creator info `{ userId, userName }`         |
| `members`         | Array  | List of members: `[ { userId, userName } ]` |

---

## 📁 BOARDS :-

## workspaces/{workspaceId}/boards/{boardId}

Represents a board within a workspace. Boards contain tasks and define specific categories.

| Field             | Type   | Description                                 |
| ----------------- | ------ | ------------------------------------------- |
| `name`            | String | Name of the board                           |
| `description`     | String | Optional board details                      |
| `numberOfMembers` | Number | Total number of members                     |
| `numberOfTasks`   | Number | Total number of boards within the workspace |
| `createdBy`       | Object | Creator info `{ userId, userName }`         |
| `workspaceId`     | String | ID of the workspace covering the board      |
| `members`         | Array  | List of members: `[ { userId, userName } ]` |

---

## 📝 TASKS :-

## workspaces/{workspaceId}/boards/{boardId}/tasks/{taskId}

Represents a task assigned to one or more users within a board.

| Field         | Type      | Description                                               |
| ------------- | --------- | --------------------------------------------------------- |
| `title`       | String    | Title of the task                                         |
| `description` | String    | Detailed description                                      |
| `status`      | String    | Workflow status: `"To Do"` \| `"In Progress"` \| `"Done"` |
| `priority`    | String    | Task urgency: `"Low"` \| `"Medium"` \| `"High"`           |
| `dueDate`     | Timestamp | Optional deadline                                         |
| `createdAt`   | Timestamp | Task creation time                                        |
| `createdBy`   | String    | ID and name of the user who created the task              |
| `assignedTo`  | Array     | List of users assigned to this task                       |
| `attachments` | Array     | List of attachment object                                 |

---

## 🔗 Relationships Summary

- **User → Workspace:** A user can be part of multiple workspaces (`members` array).
- **Workspace → Board:** A workspace contains multiple boards in a subcollection.
- **Board → Task:** A board contains multiple tasks in a subcollection.
- **User → Task:** Tasks reference users via `assignedTo` fields.

---

## 📃 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---
