# 💰 Expense Tracker & Budget Planner

A modern, comprehensive personal finance and expense tracking application built with **Flutter** and **Riverpod**. Manage daily expenses, track budgets, set savings goals, manage recurring bills, and gain visual financial insights.

🌐 **Live Demo URL**: [https://akash80047.github.io/Expense-Tracker/](https://akash80047.github.io/Expense-Tracker/)

---

## ✨ Features

- 📊 **Smart Dashboard**: Real-time balance cards, income vs expense breakdowns, and dynamic interactive trend charts.
- 💸 **Expense & Income Tracking**: Categorized transactions with date, notes, and payment mode support.
- 🎯 **Savings Goals**: Set target amounts and monitor your saving milestones.
- 📑 **Recurring Bills & Subscriptions**: Track upcoming bills, due dates, and payment statuses.
- 📈 **Analytics & Reports**: Visual category distributions, spending habits, and exportable financial summaries.
- 👛 **Multiple Wallets / Accounts**: Manage cash, bank accounts, and digital wallets.
- 🤖 **AI Financial Assistant**: Integrated smart insights for budget optimization.
- 🧾 **Receipt Scanner**: Easily capture and attach receipt images.
- 🎨 **Modern & Responsive UI**: Smooth micro-animations, glassmorphism design, and dark mode support.

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`>= 3.13.2`)
- [Dart SDK](https://dart.dev/get-dart)
- Git

### Installation & Run

1. **Clone the repository:**
   ```bash
   git clone https://github.com/AKASH80047/Expense-Tracker.git
   cd Expense-Tracker
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run on Web:**
   ```bash
   flutter run -d chrome
   ```

4. **Run on Android / iOS / Desktop:**
   ```bash
   flutter run
   ```

---

## 🛠 Tech Stack

- **Framework**: Flutter
- **Language**: Dart
- **State Management**: Flutter Riverpod
- **Fonts & Icons**: Google Fonts, Cupertino Icons
- **Formatting**: `intl`
- **Hosting / CI/CD**: GitHub Actions & GitHub Pages

---

## 📦 Deployment (GitHub Pages)

This repository includes automated CI/CD via GitHub Actions (`.github/workflows/deploy.yml`). Any push to `main` branch builds the Flutter Web app and automatically deploys it to GitHub Pages.

To enable GitHub Pages in your repo settings:
1. Go to **Settings** > **Pages** in your GitHub repository.
2. Under **Build and deployment** > **Source**, select **GitHub Actions**.
3. Once the workflow finishes, your live app is available at:
   `https://akash80047.github.io/Expense-Tracker/`
