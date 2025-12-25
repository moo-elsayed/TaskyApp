# TaskyApp ✅

TaskyApp is a Flutter-based task management mobile application that helps users organize their daily tasks efficiently with a clean UI and smooth user experience.

The app focuses on authentication, task management, notifications, and scalable state management using modern Flutter best practices.

---

## ✨ Features

- User authentication using Firebase Authentication
- Google Sign-In support
- Create, update, and manage tasks
- Persistent user data using Cloud Firestore
- Local notifications for task reminders
- Smooth onboarding experience
- Clean and responsive UI
- State management using Bloc
- Dependency injection using GetIt

---

## 🛠 Tech Stack

- **Flutter & Dart**
- **State Management:** Bloc
- **Dependency Injection:** GetIt
- **Authentication:** Firebase Authentication
- **Database:** Cloud Firestore
- **Local Storage:** SharedPreferences
- **Notifications:** flutter_local_notifications
- **Timezone Handling:** timezone, flutter_timezone
- **UI & Animations:** Google Fonts, flutter_svg, animate_do
- **Utilities:** permission_handler, toastification, fluttertoast

---

## 🧱 Architecture Overview

The project follows a layered architecture with a clear separation of concerns:

- **Presentation Layer**
  - UI Screens
  - Bloc (State Management)

- **Business Logic Layer**
  - Events & States
  - Application logic

- **Data Layer**
  - Firebase Authentication
  - Cloud Firestore

This structure improves maintainability, testability, and scalability.

---

## 🚀 Getting Started

 Clone the repository:
   ```bash
   git clone https://github.com/your-username/tasky-app.git
