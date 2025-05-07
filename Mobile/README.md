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

## ⚙️ Firebase Functions

Firebase Functions was selected as the backend solution as it powers serverless backend logic with secure and scalable automation. Perfect for task notifications, role assignments, and background jobs.


### 🔍 Key Factors Influencing the Decision:

- **Tight Integration**: Auth, Firestore, and Storage work seamlessly.
- **Auto-scaling**: No need for manual server provisioning.
- **Serverless**: Managed hosting with zero maintenance.
- **Cost-effective**: Free tier ideal for early-stage teams.

### 🔁 Compared To:

| Alternative          | Firebase Edge |
|----------------------|----------------|
| Laravel + API        | Requires backend hosting and scaling setup; better for traditional web apps but slower to integrate with Firebase-native tools. |
| Supabase Edge        | Good Postgres integration, but limited compared to Firebase's serverless maturity and real-time database support. |
| Python Flask/FastAPI | Great flexibility, but requires full backend infrastructure, monitoring, and manual auth integration. |

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
   git clone https://github.com/OmarAyman85/collab-workspace-app-OmarAyman.git
   cd collab-workspace-app-OmarAyman
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

## Firestore (Firebase) benefits:

- Real-time updates (ideal for chat, task collaboration).
- Native Flutter SDK support.
- Seamless Firebase Authentication integration.

---

### 🔁 Compared To:
| Alternative                | Firesotre Edge |
|----------------------------|----------------|
| Supabase (PostgreSQL)      | Structured and powerful for relational queries but adds complexity for highly dynamic, nested data like members, task assignments and task attachments |
| MySQL                      | Robust for strict schemas but lacks real-time capabilities and needs manual sync logic for Flutter |

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
### 🔥 Firebase Storage

Firebase Storage is optimized for file uploads directly from mobile clients with built-in authentication support, making it a natural fit for a Flutter + Firebase stack.

## Firebase Storage Advantages:

- Strong security via Firebase rules.
- Direct file uploads from client-side.
- Simple download URL management.

### 🔁 Compared To:

| Alternative          | Firebase Edge |
|----------------------|----------------|
| Amazon S3        | More configurable and scalable for enterprise-scale apps, but requires additional effort to integrate with Firebase Auth and manage access rules |
| Supabase Storage        | Good for PostgreSQL integration but lacks the maturity and tooling Firebase offers for mobile-first development |

---

## 🚀 Implementation Plan:

- High-level overview of how database and storage are structured and connected to the app:
  
FocusFlow uses Firebase as the backend service to handle authentication, real-time data storage, and file management. The app is structured using a Clean Architecture approach, separating logic into Data, Domain, and Presentation layers.

- **Authentication:** Firebase Authentication manages user sign-in/sign-up, and user data is stored in Cloud Firestore under the /users collection.
  
- **Firestore Database:** Structured into collections for users, workspaces, boards, and tasks. Each entity has its own subcollections and is linked via IDs for nested relationships (e.g., boards under a workspace, tasks under a board).
  
- **Firebase Storage:** Planned for future use to handle file uploads like attachments, avatars, and profile pictures.
  
- **Data Layer:** Implements repository interfaces using Firebase as the source of truth. It handles all reads/writes from Firestore and Storage.
  
- **Presentation Layer:** Uses Cubit (Bloc) for reactive state management. UI reacts to Firebase data changes via streams or real-time listeners.
  
This setup allows modular, scalable interaction between the app and Firebase services, ensuring seamless real-time collaboration and secure data handling.

---

# Technical Questions

## 1. Backend Architecture: Scaling to Support 1 Million Workspaces

To support scalability as the user base and number of workspaces grow to 1 million or more, the backend should be designed with **scalability**, **resilience**, and **modularity** in mind. The following architectural strategies are recommended:


### 🧱 Microservices Architecture

Decompose the monolithic application into independent, loosely coupled services — such as:

- `AuthService`
- `WorkspaceService`
- `BoardService`
- `TaskService`

**Benefits:**

- Independent deployment and scaling of services  
- Better fault isolation and maintainability  
- Language and technology flexibility across services  


### 🧩 Database Sharding

Implement **horizontal partitioning (sharding)** of the database based on `user ID` or `workspace ID`.

**Benefits:**

- Distributes workload across multiple databa instances  
- Reduces query latency under high load  
- Prevents performance bottlenecks in single-node architectures  


### ⚡ Caching Layer

Incorporate a high-performance caching solutions as **Redis** to:

- Reduce database reads for frequently accessed data (e.g., workspace metadata, task summaries)  
- Improve latency and throughput of read-heavy operations  


### 🔁 Asynchronous Processing

Use message brokers like **RabbitMQ** or **Apache Kafka** to handle non-blocking, long-running tasks such as:

- Email notifications  
- Activity logging  

This decouples the user experience from backend processing and improves responsiveness.


### 🌐 API Gateway

Leverage an API Gateway (e.g., **AWS API Gateway**, **NGINX**) to:

- Route and load balance traffic across microservices  
- Enforce security policies (authentication, authorization)  
- Implement rate limiting, logging, and request transformation

---
## 2. Authentication Strategy: Securing Authentication Across Mobile and Web Applications and Handling token expiration and refresh flows

A robust authentication strategy is critical to ensuring secure access across mobile and web platforms. The implementation should combine industry standards with secure storage and proper token management. The following components form a comprehensive approach:


### 🔐 Authentication Protocols

Leverage modern authentication protocols such as:

- **OAuth 2.0 / OpenID Connect**  
  For federated login using identity providers like Google, Apple, or traditional email/password authentication.

- **JWT (JSON Web Tokens)**  
  Used for stateless authentication and Role-Based Access Control (RBAC), where tokens encode user roles, permissions, and metadata.


### 🔑 Token Types and Secure Storage

Implement a dual-token system to balance usability and security:

- **Access Token** (short-lived):  
  Valid for ~15 minutes to minimize exposure risk.

- **Refresh Token** (long-lived):  
  Valid for 7–30 days depending on security requirements.

**Secure Token Storage:**

- **Mobile:**
  - *iOS:* Store tokens in the **Keychain**
  - *Android:* Use **EncryptedSharedPreferences** or **Android Keystore**

- **Web:**
  - Use **HttpOnly**, **Secure Cookies** to prevent XSS attacks  
  - Avoid using `localStorage` or `sessionStorage` for sensitive tokens


### 🔄 Token Expiration and Refresh Flows

Ensure a seamless user experience while maintaining security.

1. **Token Lifecycle**
   - The access token is included in each API request.
   - When it expires, the client silently uses the refresh token to obtain a new access token.

2. **Refresh Flow Handling**
   - On receiving a `401 Unauthorized` response, a refresh token request is triggered.
   - On success, replace the old tokens and retry the original request.

3. **Failure Handling**
   - If the refresh token is invalid or expired (e.g., revoked, tampered):
     - Clear stored credentials
     - Force user logout
     - Redirect to the login screen

This mechanism ensures continued secure access without frequent interruptions while guarding against unauthorized access through compromised tokens.

---
## 3. Database Modeling: Structuring Users, Workspaces, Boards, and Tasks in Firestore

When designing a scalable and maintainable data model in **Firestore**, it’s important to follow NoSQL principles like **data denormalization**, **subcollections**, and **document references**. Below is a schema tailored for collaboration-based applications such as task managers or project boards.


### Core Entities and Their Attributes

Each entity is represented as a Firestore document within a collection:

* **Users**

  ```
  users/{userId} → {
    name: string,
    email: string,
    photoUrl: string,
    ...
  }
  ```

* **Workspaces**

  ```
  workspaces/{workspaceId} → {
    name: string,
    createdBy: reference (users/{userId}),
    createdAt: timestamp,
    ...
  }
  ```

* **Boards (within Workspaces)**

  ```
  workspaces/{workspaceId}/boards/{boardId} → {
    name: string,
    description: string,
    createdAt: timestamp,
    ...
  }
  ```

* **Tasks (within Boards)**

  ```
  workspaces/{workspaceId}/boards/{boardId}/tasks/{taskId} → {
    title: string,
    description: string,
    dueDate: timestamp,
    assignedTo: array of references (users/{userId}),
    createdAt: timestamp,
    ...
  }
  ```


### Modeling Relationships

Although Firestore lacks support for native joins, relationships can still be represented through **document references** and **subcollections**.

#### One-to-Many Relationships

* **User → Workspaces (as owner)**
  `workspaces/{workspaceId}` has a `createdBy` field referencing `users/{userId}`.

* **Workspace → Boards**
  Boards are modeled as a subcollection:
  `workspaces/{workspaceId}/boards/{boardId}`

* **Board → Tasks**
  Tasks are stored in a nested subcollection:
  `workspaces/{workspaceId}/boards/{boardId}/tasks/{taskId}`

#### Many-to-Many Relationships

* **Users ↔ Workspaces (as members)**
  Store an array of user references or member objects in each workspace document under a `members` field.

* **Tasks ↔ Users (as assignees)**
  Use an array of user references in the `assignedTo` field within each task document.


This data model ensures logical organization, high scalability, and efficient querying for collaborative applications in Firestore.

---
## 4. State Management (Frontend)

In Flutter development, choosing the right state management solution is critical for creating scalable, maintainable, and performant applications. Among the most widely adopted tools are **Provider**, **Riverpod**, and **BLoC (Business Logic Component)**. Each approach offers unique benefits and trade-offs, making it essential to evaluate them against the specific needs of the project. 

For this application, **BLoC** was the most suitable choice due to its:

- Robustness in managing complex state flows, such as transitions between Workspaces, Boards, and Tasks.
- Strict separation of concerns, promoting a clear distinction between UI and business logic.
- Testability, as business logic is encapsulated within blocs and can be independently tested.
- Support for event-driven architecture, ideal for real-time updates and multi-user collaboration.


### 📊 Comprehensive Comparison Table

| Feature/Criteria       | Provider                                                    | Riverpod                                                                 | BLoC                                                                                 |
|------------------------|-------------------------------------------------------------|--------------------------------------------------------------------------|--------------------------------------------------------------------------------------|
| **Boilerplate**        | Minimal setup; uses `ChangeNotifier` and `Consumer` widgets | Low boilerplate; relies on declarative providers                         | High; needs definition of events, states, blocs, and stream mapping                 |
| **Architecture Fit**   | Loose structure; can grow messy in large apps               | Promotes clean separation and immutability                               | Strong architectural enforcement; aligns with Clean Architecture principles         |
| **Scalability**        | Suitable for small to medium projects                       | Highly scalable; automatic disposal and modular provider hierarchy       | Excellent for enterprise-scale apps with well-defined business rules                |
| **Reactivity Model**   | Basic; manual notification with `notifyListeners()`         | Fine-grained reactivity with built-in caching and auto-dispose           | Stream-based reactivity; handles complex async workflows elegantly                   |
| **Performance**        | Good, but updates entire widget trees if not optimized      | Excellent; only rebuilds affected widgets                                | Good, but higher memory overhead due to stream usage                                 |
| **Testing Support**    | Moderate; tightly coupled to UI in some cases               | Strong; logic remains separate from widgets                              | Excellent; logic and state are fully decoupled, ideal for unit testing               |
| **Type Safety**        | Limited type safety and possible runtime issues             | Full type safety with compile-time checks                                | Strong type safety with enforced state transitions                                   |
| **Code Maintainability**| Degrades with scale; harder to manage complex logic        | Clean, modular, and easy to refactor                                     | High maintainability; each bloc encapsulates specific domain logic                   |
| **IDE Tooling & Support**| Excellent support with Flutter tools                      | Excellent; strong integration and auto-complete support                  | Excellent; full support in major IDEs like VS Code and Android Studio                |


---
## 5. Offline Handling

Ensuring robust offline support is critical for enhancing user experience, particularly in environments with intermittent connectivity. To enable users to continue working seamlessly offline and synchronize their changes once connectivity is restored, the following strategies can be implemented:

### 🗂️ Local Data Persistence

Implementing reliable local storage is the foundation of offline-first functionality:

- **Hive / SQLite**  
  Ideal for storing structured data such as workspaces, tasks, and user metadata locally.
  
- **Shared Preferences**  
  Suitable for persisting lightweight configuration or frequently accessed preferences.

- **Caching**  
  Cache backend responses (e.g., boards and task lists) locally to reduce network dependency and enhance load performance.


### 🔄 Change Tracking Mechanism

To support deferred synchronization, track and store user interactions performed while offline:

- Maintain an **operation queue** locally that records CRUD operations with timestamps.
- Classify operations (`create`, `update`, `delete`) and preserve metadata required for eventual synchronization.
- Implement **conflict resolution policies** (e.g., *last-write-wins* or *manual resolution prompts*) on sync.


### 🔁 Synchronization Strategy

Once the device regains internet connectivity, synchronize the local changes with the backend:

- **Batched Sync**  
  Group multiple queued operations into a single network request to optimize bandwidth and ensure transactional integrity.

- **Conflict Handling**  
  Detect discrepancies during sync and resolve using predefined rules or user intervention.


### ☁️ Firebase Firestore Integration

Firestore provides **native offline support** for both mobile and web:

- Automatically caches documents for offline use.
- Queues and syncs write operations when the network is restored.

However, manual control is needed for:

- Fine-grained caching strategies.
- Custom conflict resolution (especially for collaborative multi-user updates).


### 🌐 Connectivity Monitoring

Efficient synchronization depends on accurate network status monitoring:

- Use packages like `connectivity_plus` or `internet_connection_checker` to:
  - Monitor network status changes in real-time.
  - Trigger queued sync operations immediately upon reconnecting.
  - Notify users of offline status and pending actions.


---

## 📃 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---
