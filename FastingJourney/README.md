# FastingJourney - iOS App

## 🚀 Quick Start

A modern, production-quality iOS app for tracking fasting methods and monitoring progress over time.

### Open in Xcode

```bash
cd /Users/kadirmacbookair/Desktop/oruç/FastingJourney
open FastingJourney.xcodeproj
```

Then:
1. Select **iPhone 15 Pro** (or your target device)
2. Press **Cmd + R** to build and run
3. Complete the onboarding screen
4. Start tracking!

---

## ✨ Features at a Glance

| Feature | Details |
|---------|---------|
| **6 Fasting Plans** | 16/8, 18/6, 20/4, OMAD, 5:2, Alternate Day |
| **Live Tracking** | Real-time timer with progress ring |
| **4 Levels** | Beginner → Consistent → Advanced → Expert |
| **Streaks** | Track current and longest streaks |
| **History** | Full fasting session history |
| **Notifications** | Smart reminders for fasting windows |
| **Local Data** | All data stored on device (privacy-first) |
| **Modern UI** | SwiftUI with premium design |

---

## 📱 App Structure

### 4 Main Tabs
1. **Home** - Dashboard with live fasting progress
2. **Plans** - Browse 6 popular fasting protocols
3. **History** - View past sessions and stats
4. **Profile** - Settings, levels, and preferences

### Built With
- **Language**: Swift 5.0+
- **Framework**: SwiftUI
- **Architecture**: MVVM
- **Persistence**: UserDefaults + JSONEncoder/Decoder
- **Dependencies**: None (pure Apple frameworks)
- **Min iOS**: 17.0

---

## 📊 Project Stats

- **33 Swift Files**
- **30 Main Source Files** (App, Models, Views, ViewModels, Services, Theme)
- **7 Reusable Components**
- **4 ViewModels** for state management
- **6 Built-in Fasting Plans**
- **0 External Dependencies**

---

## 🎯 How to Use

### Start Fasting
1. Tap **Home** tab
2. Select or confirm your fasting plan
3. Tap the progress ring → "Start Fasting"
4. Watch the countdown in real-time

### Track Progress
- See your **current streak** and **longest streak**
- Monitor **completed fasts** and **total hours fasted**
- Watch your **level progress**

### View History
1. Tap **History** tab
2. See all past fasting sessions
3. Tap a session for details

### Customize
1. Tap **Profile** tab
2. Toggle notifications on/off
3. Choose 12h or 24h time format
4. Select light/dark theme

---

## 📁 File Organization

```
FastingJourney/
├── App/                    # Entry point & routing
├── Models/                 # Data models (FastingPlan, Session, Profile)
├── ViewModels/             # MVVM state management
├── Views/
│   ├── Onboarding/        # First-launch flow
│   ├── Main/              # Home dashboard
│   ├── Plans/             # Plan browser
│   ├── History/           # Session history
│   ├── Settings/          # Settings & about
│   └── Components/        # Reusable UI elements
├── Services/              # Persistence, notifications, calculations
├── Theme/                 # Colors & typography
└── Resources/             # Assets, launch screen
```

---

## 🔄 Architecture Highlights

### MVVM Pattern
- **Models**: Data structures with `Codable`
- **ViewModels**: Business logic with `@Published`
- **Views**: Reactive UI with SwiftUI

### State Management
- `@StateObject` - ViewModel lifecycle
- `@EnvironmentObject` - Shared data
- `@Published` - Reactive updates

### Data Persistence
- `UserDefaults` - Simple key-value storage
- `JSONEncoder/Decoder` - Complex types
- No external servers or dependencies

---

## 🎨 Design System

### Colors
- **Primary**: Soft teal (progress rings, buttons)
- **Accent**: Warm orange (highlights)
- **Semantic**: Success (green), Error (red), Warning (orange)

### Typography
- Display, Title, Body, Label, Caption sizes
- Consistent font weights and spacing

### Components
- Reusable buttons, cards, progress indicators
- Consistent padding and corner radius

---

## ⚙️ Settings & Preferences

Users can customize:
- ✅ Notification reminders (enable/disable)
- ✅ Time format (12-hour or 24-hour)
- ✅ Theme (System, Light, Dark)
- ✅ Reset all data
- ✅ View health disclaimer

---

## 📊 Level System

Progress is gamified with 4 levels:

| Level | Completed Fasts | Icon |
|-------|-----------------|------|
| 1 | 0-4 | Beginner |
| 2 | 5-14 | Consistent |
| 3 | 15-29 | Advanced |
| 4 | 30+ | Expert |

Each level unlocks at specific milestones!

---

## 📝 Health & Safety

- ✅ App is for **informational purposes only**
- ✅ Not medical advice
- ✅ Users should consult healthcare professionals
- ✅ Prominent disclaimer throughout app
- ✅ Safe fasting practices encouraged

---

## 🧪 Testing

### On Simulator
- All features work on iOS 17+ simulator
- Can speed up time to test streaks
- Local notifications work with permission

### On Real Device
- Connect via USB
- Trust developer certificate when prompted
- All notifications work properly
- Full persistence across sessions

---

## 🔐 Data Privacy

- ✅ All data stored **locally on device**
- ✅ No servers or cloud sync (by design)
- ✅ No analytics or tracking
- ✅ No personal data collection
- ✅ User has full control

---

## 📚 Documentation

Three comprehensive guides included:

1. **PROJECT_SETUP_GUIDE.md** - Complete feature walkthrough
2. **FILE_STRUCTURE.md** - File organization reference
3. **COMPLETE_FILE_MANIFEST.md** - Full file listing

---

## 🚀 Next Steps

### To Open the App
```bash
cd /Users/kadirmacbookair/Desktop/oruç/FastingJourney
open FastingJourney.xcodeproj
# Then press Cmd+R
```

### To Extend the App
1. Add new fasting plans in `Models/FastingPlan.swift`
2. Create new views in `Views/`
3. Add ViewModels as needed in `ViewModels/`
4. Update `PersistenceManager.swift` for new data types

### For App Store Submission
- [ ] Update bundle identifier
- [ ] Add app icons (1024x1024 minimum)
- [ ] Create App Store screenshots
- [ ] Write app description
- [ ] Set privacy policy
- [ ] Configure TestFlight testing

---

## 💡 Tips

- **Test on Real Device**: Notifications work better on actual iPhone
- **Simulator Speed**: Use Simulator → Device → Slow Down Animations for testing
- **Dark Mode**: Built-in support with semantic colors
- **Accessibility**: Uses standard SwiftUI components (VoiceOver ready)

---

## 📞 Support

For questions about the code:
- All files are well-commented
- MVVM pattern is used throughout
- Check existing ViewModels for examples

---

## ✅ Project Status

- ✅ 30 Swift files implemented
- ✅ Complete MVVM architecture
- ✅ All UI screens functional
- ✅ Data persistence working
- ✅ Notifications configured
- ✅ Level system active
- ✅ Streak tracking ready
- ✅ Health disclaimer included
- ✅ Ready for Xcode & simulator

**Status: PRODUCTION READY** 🎉

---

## License

Personal use - modify and extend as needed!

---

Generated: November 13, 2025
