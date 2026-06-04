# 🏋️‍♂️ FitMind

FitMind is a Flutter-based fitness and wellness application designed for students and parents. The app helps users track health metrics, monitor fitness progress, maintain healthy habits, and stay motivated throughout their fitness journey.

## ✨ Features

### 🔐 Authentication

* Firebase Authentication
* User Registration
* User Login
* Secure Account Management

### 👨‍🎓 User Dashboard

* Personal Profile Management
* Age, Height, Weight Tracking
* Diet Preference Management
* Allergy Information Storage
* Fitness Progress Monitoring
* Health Data Recording

### 📊 Health Tracking

* Weight Tracking
* Height Tracking
* BMI Calculation Support
* Daily Progress Monitoring
* Fitness Journey Analytics

### 🎨 Modern UI

* Beautiful Animated Background
* Responsive Design
* Dark Theme Interface
* Smooth Animations
* User-Friendly Navigation

---

## 🛠️ Tech Stack

### Frontend

* Flutter
* Dart

### Backend

* Firebase Authentication
* Cloud Firestore

### State Management

* Stateful Widgets

### Database

* Firebase Cloud Firestore

---

## 📱 Screens

### Authentication

* Login Screen
* Registration Screen

### Student Module

* Student Dashboard
* Profile Management
* Fitness Tracking

### Parent Module

* Parent Dashboard
* Child Monitoring
* Health Reports

---

## 📂 Project Structure

```text
lib/
│
├── main.dart
├── login_screen.dart
├── student_dashboard.dart
├── parent_dashboard.dart
│
├── screens/
├── widgets/
├── services/
└── models/
```

---

## 🚀 Installation

### 1. Clone Repository

```bash
git clone https://github.com/jainam258/FitMind.git
```

### 2. Open Project

```bash
cd FitMind
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Configure Firebase

* Create Firebase Project
* Add Android App
* Download `google-services.json`
* Place it inside:

```text
android/app/google-services.json
```

### 5. Run Project

```bash
flutter run
```

---

## 🔥 Firebase Setup

Enable:

* Firebase Authentication
* Cloud Firestore

Authentication Methods:

* Email & Password

Firestore Collection:

```text
users
```

Example User Document:

```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "role": "student",
  "age": 18,
  "height": 170,
  "weight": 65
}
```

---

## 🎯 Future Improvements

* Step Counter
* Water Intake Tracker
* Workout Planner
* AI Fitness Recommendations
* Nutrition Analysis
* Progress Charts
* Push Notifications
* Google Sign-In
* Fitness Challenges
* Goal Tracking System

---

## 📸 Screenshots

Add your screenshots here:

```markdown
![Login Screen](screenshots/login.png)

![Student Dashboard](screenshots/student_dashboard.png)

![Parent Dashboard](screenshots/parent_dashboard.png)
```

---

## 👨‍💻 Developer

**Jainam Shah**

Diploma Graduate & B.Tech Student

Flutter Developer | Firebase Developer

GitHub:
https://github.com/jainam258

---

## 📄 License

This project is created for educational and learning purposes.

---

## ⭐ Support

If you like this project:

⭐ Star the repository

🍴 Fork the repository

📢 Share with others

---

### "Track • Train • Transform"

FitMind — Your Smart Fitness Companion
