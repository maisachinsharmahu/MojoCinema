# Mojocinema 🎬 | Premium Flutter Movie & Series Discovery App

[![Flutter Version](https://img.shields.io/badge/Flutter-3.x-blue.svg?style=for-the-badge&logo=flutter)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![Stars](https://img.shields.io/github/stars/maisachinsharmahu/MojoCinema?style=for-the-badge&color=gold)](https://github.com/maisachinsharmahu/MojoCinema/stargazers)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey?style=for-the-badge)](https://flutter.dev)

**Mojocinema** is a high-performance, open-source movie discovery application built with **Flutter**. It features a state-of-the-art **Glassmorphic UI** designed for a premium user experience. Explore the latest global trending cinema, deep-dive into **Indian Web Series**, and watch high-quality trailers—all in one place.

---

## ⚡ Visual Experience (Glassmorphism & Material 3)

<div align="center">
  <table>
    <tr>
      <td><img src="screenshots/1.png" width="300" alt="Home Screen - Flutter Movie App"></td>
      <td><img src="screenshots/2.png" width="300" alt="Movie Details - TMDB Client"></td>
    </tr>
    <tr>
      <td><img src="screenshots/3.png" width="300" alt="Search Page - Cinema Discovery"></td>
      <td><img src="screenshots/4.png" width="300" alt="Trailer Hub - YouTube Player Integration"></td>
    </tr>
  </table>
</div>

---

## 🚀 Key Features & Discovery Engine

### 🌍 Global Content & Regional Focus
- **Indian Cinema Priority**: Specialized sections for **Indian Upcoming Movies** and **Trending Indian Web Series**.
- **Worldwide Trending**: Real-time integration with the **TMDB API** for a comprehensive global media feed.

### 💎 Next-Gen UI/UX Design
- **Glassmorphic Design System**: Advanced blur effects, sleek gradients, and high-fidelity transitions.
- **Dynamic Backdrop Synchronization**: The app's atmosphere changes in real-time to match the content on screen.
- **Responsive Layouts**: Optimized for every screen size using `flutter_screenutil`.

### 🎞️ Pro Media Hub
- **Integrated YouTube Player**: Seamless trailer playback with smart fallback for missing assets.
- **Deep Metadata Retrieval**: Access runtime, age certifications (U/A, A), high-res posters, and detailed cast biographies.
- **Watchlist Persistence**: Save your favorite movies locally for offline planning.

---

## 🛠️ Technical Implementation Walkthrough

### 1. Unified Dashboard (`home_page.dart`)
Optimized for **Content Discovery SEO** through an intelligent categorization engine. Features a dynamic **Hero Carousel** that filters data quality to ensure a premium look.

### 2. Deep Intelligence Engine (`MovieDetails.dart`)
A centralized information hub. We use **ValueListenable** patterns for zero-lag state management and sophisticated regex-based metadata extraction for movie certifications.

### 3. Smart Media Validation
Every image and video link is validated before rendering, preventing 404 errors and broken layouts using **CachedNetworkImage** and custom error widgets.

---

## 📦 Tech Stack & Performance Architecture
- **Framework**: [Flutter](https://flutter.dev) (High-performance Dart)
- **Data Provider**: [TMDB API](https://www.themoviedb.org/documentation/api) (The Movie Database)
- **UI Architecture**: Glassmorphism + Material 3
- **State Management**: Reactive State (ValueListenable)
- **Local Storage**: Data persistence for Watchlists
- **Asset Optimization**: Sophisticated font tree-shaking and image caching

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Stable)
- [TMDB API Key](https://www.themoviedb.org/documentation/api)

### Installation
1. **Clone & Navigate**:
   ```bash
   git clone https://github.com/maisachinsharmahu/MojoCinema.git
   cd MojoCinema
   ```
2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```
3. **Configure API**:
   Rename `lib/api/example_apikey.dart` to `apikey.dart` and add your key.
4. **Launch**:
   ```bash
   flutter run --release
   ```

---

## 🤝 Contributing to Open Source
We love contributions! Whether it's a new feature, bug fix, or UI refinement, feel free to open a Pull Request.
1. Fork the repo.
2. Create your feature branch.
3. Commit and push.
4. Open a PR.

---

## 📜 License & Attribution

Distributed under the **MIT License**.

### 🎨 UI Design Attribution (Legal Requirement)
The **Glassmorphic UI Design** and visual aesthetic are proprietary to **Sachin Sharma**. You are free to use the code, but a prominent credit to the original author is required:
- **"UI Design by Sachin Sharma (Mojocinema)"**
- Link to original repository: [https://github.com/maisachinsharmahu/MojoCinema](https://github.com/maisachinsharmahu/MojoCinema)

---
<div align="center">
  <b>Built with ❤️ by <a href="https://github.com/maisachinsharmahu">Sachin Sharma</a></b>
</div>
