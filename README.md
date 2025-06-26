# bill_mate

bill_mate is a Flutter application designed for billing management. It provides features such as user login, bill creation, sales tracking, and store management. The app uses modern Flutter development practices including Bloc state management and responsive design.

## Features

- User authentication and login
- Create and manage bills with product details
- View all sales and billing history
- Store management functionalities
- Responsive UI using flutter_screenutil
- PDF generation and printing support
- Local database storage using sqflite
- Network requests with Dio and cookie management

## Getting Started

### Prerequisites

- Flutter SDK (version >= 3.3.4 < 4.0.0)
- Compatible IDE (VSCode, Android Studio, etc.)
- Device or emulator for running the app

### Installation

1. Clone the repository:
   ```
   git clone <repository-url>
   ```
2. Navigate to the project directory:
   ```
   cd bill_mate
   ```
3. Install dependencies:
   ```
   flutter pub get
   ```
4. Run the app:
   ```
   flutter run
   ```

### Permissions

The app requests storage permission on startup to enable saving and accessing files locally.

## Project Structure

- `lib/` - Main source code including UI screens, BLoC state management, models, services, and utilities
- `assets/` - Images, gifs, and other static resources
- `android/`, `ios/`, `macos/`, `windows/`, `linux/` - Platform-specific code and configurations

## Dependencies

Key dependencies used in this project include:

- flutter_bloc: State management using BLoC pattern
- flutter_screenutil: Responsive UI design
- dio: HTTP client for API requests
- sqflite: SQLite database for local storage
- pdf & printing: PDF generation and printing support
- permission_handler: Runtime permission handling

For a full list, see `pubspec.yaml`.

## Useful Links

- [Flutter Documentation](https://docs.flutter.dev/)
- [Bloc Package](https://pub.dev/packages/flutter_bloc)
- [Flutter ScreenUtil](https://pub.dev/packages/flutter_screenutil)
- [Dio HTTP Client](https://pub.dev/packages/dio)
- [Sqflite Database](https://pub.dev/packages/sqflite)

## License

This project is licensed under the MIT License.
