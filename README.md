# 🍔 Food Ordering App – Admin & Client Panel (Flutter)

A full-stack Flutter application that includes two modules:

- **Admin App** – for managing products and categories
- **Client App** – for end-users to browse, order, and make payments

Built using **feature-wise MVVM architecture**, this project integrates **Firebase**, **Stripe**, and follows best practices for scalable, maintainable mobile apps.

---

## 🔧 Tech Stack

- **Flutter** with **Bloc/Cubit**, **MVVM**, **GetIt**, **GoRouter**, **Dartz**
- **Firebase** (Firestore, Storage, Authentication)
- **Stripe Payment Gateway**

---

## 🧩 Features

### 📦 Client App
- Browse products **by category**
- **Add to favorites** and **cart**
- **User authentication**: Sign up, Sign in, Forgot Password
- **Address management**
- **Payment options**:
  - Card (via Stripe)
  - Cash on Delivery
- **Order confirmation** after successful payment
- View past **orders**

### 🛠️ Admin App
- Add, edit, delete products and categories
- Upload product images to **Firebase Storage**
- Real-time updates synced with **Firestore**

---

## 🛠️ Architecture Overview

- Feature-wise **MVVM structure**
- **Bloc/Cubit** for state management
- **GetIt** for dependency injection
- **GoRouter** for route management
- **Dartz** for functional error handling

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ≥ 3.x
- Firebase project with Firestore, Auth, and Storage enabled
- Stripe account (test mode setup)

### Steps
1. Clone the repo  
   `git clone https://github.com/Sumit-9900/Food-Zone.git`
2. Run `flutter pub get`
3. Set up your `firebase_options.dart` via FlutterFire CLI
4. Add your Stripe API keys
5. Run on emulator or physical device  
   `flutter run`

---

## 📫 Contact

**Sumit Paul**  
📧 paulsumit9900@gmail.com  
🔗 [LinkedIn](https://www.linkedin.com/in/sumit-paul-640971218)  
🔗 [GitHub](https://github.com/Sumit-9900)
