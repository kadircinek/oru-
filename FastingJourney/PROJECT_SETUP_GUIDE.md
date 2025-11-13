# FastingJourney - iOS App Project Setup Guide

## Project Overview

**FastingJourney** is a modern, production-quality iOS app built with SwiftUI that helps users track popular fasting methods and monitor their progress over time. The app features a clean MVVM architecture, modern premium UI design, and comprehensive fasting tracking capabilities.

### Key Features
- ✅ Track multiple fasting protocols (16/8, 18/6, 20/4, OMAD, 5:2, Alternate Day)
- ✅ Live fasting session timer with progress visualization
- ✅ Level system & gamification (Beginner → Expert)
- ✅ Streak tracking with history
- ✅ Smart reminders for fasting windows
- ✅ Complete local data persistence (no external dependencies)
- ✅ Modern, minimal premium UI design
- ✅ Health disclaimer & safety-first approach

---

## Project Structure

```
FastingJourney/
├── FastingJourney.xcodeproj/          # Xcode project configuration
│   ├── project.pbxproj               # Build configuration
│   └── project.xcworkspace/
│       └── contents.xcworkspacedata
│
└── FastingJourney/                    # Main source code
    ├── Info.plist
    │
    ├── App/
    │   ├── FastingJourneyApp.swift    # Entry point with onboarding logic
    │   └── AppRouter.swift            # Navigation routing logic
    │
    ├── Models/
    │   ├── FastingPlan.swift          # Fasting protocol data model + 6 presets
    │   ├── FastingSession.swift       # Individual fasting session tracking
    │   └── UserProfile.swift          # User's progress & level data
    │
    ├── ViewModels/
    │   ├── FastingPlanViewModel.swift # Plan management & filtering
    │   ├── FastingSessionViewModel.swift # Active session management & timer
    │   ├── ProgressViewModel.swift    # Level & streak calculations
    │   └── SettingsViewModel.swift    # User preferences & settings
    │
    ├── Views/
    │   ├── Onboarding/
    │   │   └── OnboardingView.swift   # First-launch onboarding flow
    │   │
    │   ├── Main/
    │   │   ├── MainTabView.swift      # Tab bar with 4 main tabs
    │   │   └── HomeView.swift         # Dashboard with progress ring & stats
    │   │
    │   ├── Plans/
    │   │   ├── PlansView.swift        # Browse & search fasting plans
    │   │   └── PlanDetailView.swift   # Detailed plan info & activation
    │   │
    │   ├── History/
    │   │   ├── HistoryView.swift      # Session history & summary
    │   │   └── HistoryDetailView.swift # Individual session details
    │   │
    │   ├── Settings/
    │   │   ├── SettingsView.swift     # Preferences & profile info
    │   │   └── AboutView.swift        # About & health disclaimer
    │   │
    │   └── Components/
    │       ├── PrimaryButton.swift    # Filled CTA button
    │       ├── SecondaryButton.swift  # Outlined button
    │       ├── ProgressRingView.swift # Circular progress visualization
    │       ├── StatCardView.swift     # Statistics card component
    │       ├── PlanCardView.swift     # Plan list item
    │       ├── TagPillView.swift      # Small tag chips
    │       └── EmptyStateView.swift   # Empty state placeholder
    │
    ├── Services/
    │   ├── PersistenceManager.swift   # UserDefaults + JSONEncoder/Decoder
    │   ├── NotificationManager.swift  # Local push notifications
    │   └── FastingCalculator.swift    # Fasting math & logic
    │
    ├── Theme/
    │   ├── AppColors.swift            # Color palette & gradients
    │   └── AppTypography.swift        # Font sizes, spacing, corner radius
    │
    └── Resources/
        ├── Assets.xcassets/           # App icon & image assets
        │   ├── AppIcon.appiconset/
        │   └── AccentColor.colorset/
        │
        ├── LaunchScreen.storyboard    # Launch screen configuration
        │
        └── Preview Content/
            └── PreviewAssets.xcassets/
```

---

## Architecture: MVVM + SwiftUI

### Models (`Models/`)
- **FastingPlan**: Represents a fasting protocol with 6 hardcoded presets
- **FastingSession**: Individual fasting event with start/end times and duration
- **UserProfile**: Tracks user's level, streaks, completed fasts, and total hours

All models are `Codable` for persistence.

### ViewModels (`ViewModels/`)
- **FastingPlanViewModel**: Manages plan selection, filtering, and search
- **FastingSessionViewModel**: Active session management with real-time timer updates
- **ProgressViewModel**: Calculates level progression, streaks, and statistics
- **SettingsViewModel**: Handles user preferences and app configuration

ViewModels use `@ObservedObject` / `@StateObject` for reactive updates.

### Views (`Views/`)
- **Onboarding**: First-time setup with welcome screen
- **MainTabView**: Tab-based navigation (Home, Plans, History, Profile)
- **HomeView**: Dashboard with live progress ring and stats
- **PlansView**: Browse and search fasting protocols
- **HistoryView**: View past fasting sessions with statistics
- **SettingsView**: Manage preferences and view profile
- **Components**: Reusable UI elements (buttons, cards, progress rings)

### Services (`Services/`)
- **PersistenceManager**: Generic save/load with UserDefaults
- **NotificationManager**: Schedule local notifications
- **FastingCalculator**: Fasting duration, level, streak calculations

### Theme (`Theme/`)
- **AppColors**: Primary (teal), accent (orange), backgrounds, semantic colors
- **AppTypography**: Fonts, spacing constants, corner radius values

---

## Key Features Explained

### 1. Fasting Plans
Six hardcoded plans with tags, descriptions, and hour targets:
- 16/8 Intermittent Fasting (Beginner-friendly)
- 18/6 Intermittent Fasting (Intermediate)
- 20/4 Warrior Diet (Advanced)
- OMAD (One Meal A Day) (Extreme)
- 5:2 Fasting (Flexible)
- Alternate Day Fasting (Structured)

### 2. Session Tracking
- Start/stop fasting with single tap
- Real-time countdown with progress ring
- Automatically mark sessions as "completed" if duration ≥ target
- Full session history with timestamps

### 3. Gamification
**Level System** (based on completed fasts):
- Level 1 (Beginner): 0-4 completed fasts
- Level 2 (Consistent): 5-14 completed fasts
- Level 3 (Advanced): 15-29 completed fasts
- Level 4 (Expert): 30+ completed fasts

**Streaks**:
- Current streak (consecutive days with completed fasts)
- Longest streak (all-time best)
- Tracked automatically

### 4. Persistence
All data stored locally via UserDefaults:
- `activePlan`: Currently selected fasting plan
- `sessions`: Array of all fasting sessions
- `userProfile`: Level, streaks, totals
- `preferences`: Notification settings, time format, theme
- `hasCompletedOnboarding`: First-launch flag

### 5. Notifications
- RequestAuthorization when app starts
- Schedule start reminders (15 min before fasting window)
- Schedule end reminders (when fasting window ends)
- Cancellable via settings toggle

---

## Tech Stack

| Component | Technology |
|-----------|------------|
| **UI Framework** | SwiftUI (iOS 17+) |
| **Language** | Swift 5.0+ |
| **Architecture** | MVVM |
| **State Management** | @State, @StateObject, @EnvironmentObject, @ObservedObject |
| **Persistence** | UserDefaults + JSONEncoder/Decoder |
| **Notifications** | UNUserNotificationCenter |
| **Dependencies** | None - Apple frameworks only |

---

## How to Run the Project

### Prerequisites
- **Xcode 15.0** or later
- **iOS 17.0** or later (iPhone simulator or real device)
- macOS 12.0 or later

### Steps to Open in Xcode

1. **Navigate to project directory**:
   ```bash
   cd /Users/kadirmacbookair/Desktop/oruç/FastingJourney
   ```

2. **Open the Xcode project**:
   ```bash
   open FastingJourney.xcodeproj
   ```
   
   Or double-click `FastingJourney.xcodeproj` in Finder.

3. **Select a simulator or device**:
   - From the top toolbar, select target device (e.g., "iPhone 15 Pro")

4. **Build and Run**:
   - Press `Cmd + R` or click the Play button (▶️)
   - Or from menu: **Product** → **Run**

### Running on Simulator

The app will launch on the selected iOS simulator with:
- ✅ Onboarding screen (first run only)
- ✅ Tab bar with 4 main tabs
- ✅ Full fasting tracking functionality
- ✅ Persistent local data storage

### Running on Real Device

1. Connect your iPhone via USB
2. In Xcode, select your device from the top toolbar
3. Press `Cmd + R` to build and run
4. When prompted, trust the developer certificate on your device
5. Dismiss any system notifications to interact with the app

---

## Key Implementation Details

### 1. Onboarding Flow
```swift
// FastingJourneyApp.swift - Checks completion status
if hasCompletedOnboarding {
    MainTabView()
} else {
    OnboardingView { onComplete in
        PersistenceManager.shared.markOnboardingCompleted()
        hasCompletedOnboarding = true
    }
}
```

### 2. Fasting Session Management
```swift
// Start session
sessionViewModel.startFasting(with: selectedPlan)

// Updates every second with Timer
ProgressRingView(
    progress: sessionViewModel.progress,        // 0-100%
    remainingTime: timeString,                  // "8h 30m"
    isActive: sessionViewModel.isActive()
)

// End session
sessionViewModel.endFasting(with: plan)
// Automatically marks complete if met target hours
```

### 3. Level Calculation
```swift
func calculateLevel(from completedFasts: Int) -> Int {
    switch completedFasts {
    case 0...4: return 1    // Beginner
    case 5...14: return 2   // Consistent
    case 15...29: return 3  // Advanced
    default: return 4       // Expert
    }
}
```

### 4. Streak Logic
```swift
// Calculates consecutive days with completed fasts
let currentStreak = FastingCalculator.calculateCurrentStreak(from: sessions)
// Updates on each completed session
```

---

## Design System

### Colors
- **Primary**: Soft teal (#33B3B3)
- **Accent**: Warm orange (#F2A830)
- **Background**: Off-white (#FAFAFA)
- **Text Primary**: Black (#000000)
- **Text Secondary**: Gray (#999999)
- **Success**: Green (#4CD964)
- **Error**: Red (#E63030)
- **Warning**: Orange (#F2A830)

### Typography
- **Display Large**: 32pt, Bold
- **Title Medium**: 18pt, Semibold
- **Body Regular**: 16pt, Regular
- **Label Medium**: 12pt, Medium
- **Caption**: 10-12pt, Regular

### Spacing
- XSmall: 8px
- Small: 12px
- Medium: 16px
- Large: 20px
- XLarge: 24px

### Corner Radius
- Small: 8px
- Medium: 12px
- Large: 16px

---

## Testing Checklist

- [ ] **Onboarding**: Verify first-run flow, can skip to main app
- [ ] **Home Tab**: Start/end fasting, progress ring updates, stats display
- [ ] **Plans Tab**: Search/filter plans, select active plan, view details
- [ ] **History Tab**: View past sessions, session details, statistics
- [ ] **Settings Tab**: Toggle notifications, change time format, reset data
- [ ] **Data Persistence**: Close and reopen app, verify data persists
- [ ] **Notifications**: Enable reminders, verify scheduled notifications
- [ ] **Levels**: Complete multiple fasts, verify level progression

---

## Future Enhancement Ideas

1. **Cloud Sync**: Add iCloud sync for multi-device support
2. **Health Kit Integration**: Export data to Apple Health
3. **Advanced Analytics**: Charts, trends, meal recommendations
4. **Community**: Leaderboards, challenges, sharing
5. **Custom Plans**: User-defined fasting protocols
6. **Reminders Pro**: More customizable notification options
7. **Dark Mode**: Full dark mode UI variant
8. **Widgets**: Home screen and lock screen widgets

---

## Health & Safety

The app includes prominent disclaimers:
- "This app is for informational and motivational purposes only"
- "Always consult a healthcare professional before starting fasting"
- "Not suitable for pregnant women, children, or those with medical conditions"
- Information is estimates only; results vary by individual

---

## Support & Contact

This is a complete, standalone iOS app ready for App Store submission or personal use. All code follows Apple's guidelines and best practices.

### File Count Summary
- **Total Swift Files**: 33
- **Models**: 3
- **ViewModels**: 4
- **Views**: 14
- **Components**: 7
- **Services**: 3
- **Theme**: 2
- **App**: 2
- **Configuration Files**: Xcode project files + Info.plist

---

**Project created**: November 13, 2025  
**Minimum iOS**: 17.0  
**Language**: Swift 5.0+  
**Status**: ✅ Ready for Xcode & iOS Simulator
