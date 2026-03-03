# Mojocinema

A high-performance, premium movie discovery application built with Flutter. Mojocinema provides a sleek, glassmorphic interface for exploring the latest global and Indian cinema, web series, and trailers.

## Visual Experience

<table>
  <tr>
    <td><img src="screenshots/1.png" width="300" alt="Home Screen"></td>
    <td><img src="screenshots/2.png" width="300" alt="Movie Details"></td>
  </tr>
  <tr>
    <td><img src="screenshots/3.png" width="300" alt="Search Page"></td>
    <td><img src="screenshots/4.png" width="300" alt="Video Player"></td>
  </tr>
</table>

## Detailed Feature Walkthrough

### 1. Home Dashboard (`home_page.dart`)
The core entry point of Mojocinema, designed for maximum engagement and content discoverability.
- **Hero Carousel**: A dynamic, interactive slider that prioritizes high-impact Indian content. It automatically filters out movies with missing assets to maintain an elite aesthetic.
- **Glassmorphic Background**: Features a real-time blurred backdrop that synchronizes with the current hero card, creating a deep, immersive atmosphere.
- **Categorization Engine**: Three distinct modes (All, Movies, TV) that intelligently reorganize the feed based on the active tab.
- **Regional Prioritization**: Dynamically adjusts data sources to highlight Indian movies and web series first, followed by global trending sections.

### 2. Cinematic Detail System (`MovieDeatils.dart`)
A centralized hub for deep-diving into any title.
- **Visual Header**: Features a high-resolution hero image with a custom-engineered glassmorphic "Mojocinema Bookmark" button.
- **Deep Metadata**: Comprehensive display of release year, runtime, star ratings, and age certifications.
- **Interactive Keywords**: Hashtag-style tags that allow users to understand the tone and themes of the content instantly.
- **Real-time Stats**: Displays popularity scores and total vote counts formatted for readability (e.g., 1.2M, 500K).

### 3. Media Hub & Player (`vid.dart`)
- **Smart Trailer Detection**: Automatically fetches all available YouTube trailers and extras for any specific title.
- **Graceful Placeholders**: If no video assets are found, the app displays a professional glassmorphic "videocam_off" placeholder instead of a broken player.
- **Integrated Playlist**: Allows users to switch between official trailers, teasers, and behind-the-scenes clips without leaving the page.

### 4. Cast & Actor Exploration (`crew.dart`, `actor_detail_page.dart`)
- **Horizontal Cast Scroll**: A high-fidelity list of actors with their character names and profile photos.
- **Deep Linking**: Tapping any cast member takes you to a dedicated Actor Detail Page showing their biography, career stats, and filmography.

### 5. My Watchlist (`watchlist_page.dart`)
- **Local Persistence**: Save any movie or show to your personal collection.
- **Synchronized Status**: Tapping the glassmorphic bookmark in the details page instantly updates your collection and provides immediate visual feedback.

### 6. Search & Navigation (`search_page.dart`, `drawer_widget.dart`)
- **Mojocinema Drawer**: A sleek side menu providing quick access to the TV Hub, Discover Page, and Actor Search.
- **Glassmorphic Navigation**: A semi-transparent, blurred bottom navigation bar that allows the content to stay visible even during scrolling.

## Key Features


- **Global & Indian Content**: Prioritized sections for Indian movies and web series alongside worldwide trending data.
- **Premium UI/UX**: Custom glassmorphic design system with smooth animations and high-fidelity transitions.
- **Real-time Discovery**: Integrated with TMDB API for live data on upcoming, popular, and trending media.
- **Watchlist Management**: Local persistence for saving movies and shows to watch later.
- **Media Hub**: Integrated YouTube player for high-quality trailer playback and movie extras.
- **Robust Error Handling**: Sophisticated media validation to ensure no broken images or invalid data crashes.

## Tech Stack

- **Framework**: Flutter (Dart)
- **State Management**: ValueListenable & Stateful Widgets
- **Networking**: Http with JSON serialization
- **Media**: CachedNetworkImage for optimized image delivery
- **Styling**: ScreenUtil for responsive layouts, Iconsax for iconography
- **Video**: youtube_player_flutter for media integration

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Android Studio / VS Code
- A TMDB API Key (Get one at [themoviedb.org](https://www.themoviedb.org/documentation/api))

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/mojocinema.git
   ```

2. Navigate to the project directory:
   ```bash
   cd mojocinema
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Configure API Key:
   Open `lib/api/apikey.dart` and replace the placeholder with your actual TMDB API key:
   ```dart
   const String apikey = "YOUR_API_KEY_HERE";
   ```

5. Run the application:
   ```bash
   flutter run
   ```

## Project Structure

- `lib/api/`: API endpoints and configuration.
- `lib/Pages/Home/`: Primary dashboard and category management.
- `lib/Pages/details/`: Comprehensive media information and cast details.
- `lib/Pages/Videospage/`: Trailer indexing and playback logic.
- `lib/Pages/Watchlist/`: Local data persistence and user list features.

## Contributing

Contributions are welcome. Please follow these steps:

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License & Attribution

Distributed under the **MIT License**.

### 🎨 UI Design Attribution (Mandatory)
The User Interface (UI) design, glassmorphic layout, and visual aesthetic of **Mojocinema** are proprietary to the original author. Any redistribution, modification, or use of the code that includes the visual design/UI components **MUST** include a prominent credit in the following format:
- **"UI Design by Sachin Sharma (Mojocinema)"**
- Link to original repository: https://github.com/maisachinsharmahu/MojoCinema

See `LICENSE` for more information.

