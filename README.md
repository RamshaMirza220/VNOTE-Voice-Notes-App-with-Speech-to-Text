# 🗣️ VNOTE – Voice Notes App with Speech-to-Text  

A modern Flutter app that allows users to **record, convert, and manage voice notes using Speech-to-Text technology**.  
Designed with a clean UI, efficient state management, and platform support for Android, iOS, and web.  

---

## 🚀 Features  

| Feature | Description |
|----------|--------------|
| 🎤 **Speech to Text** | Convert your voice notes into editable text using real-time speech recognition. |
| 📝 **Save Notes** | Save, view, and edit notes within the app. |
| 🔍 **Search Functionality** | Quickly find saved notes using keywords. |
| 💾 **Local Storage** | Notes are securely stored locally on your device. |
| 🌗 **Dark & Light Themes** | Toggle between dark and light mode for better accessibility. |
| 📱 **Cross-Platform Support** | Works on Android, iOS, Web, Windows, macOS, and Linux. |

---

## 🛠️ Technologies Used  

- **Flutter (Dart)** – cross-platform framework  
- **Speech-to-Text API** – for real-time voice recognition  
- **Hive / Shared Preferences** – for local data storage  
- **Provider / Riverpod** – state management (if used)  

---

## 🧩 Project Structure  

``` vnote/
│
├── lib/ # Main Flutter code (UI, logic, views)
│ ├── main.dart # Entry point of the app
│ ├── screens/ # App screens (home, note detail, etc.)
│ ├── widgets/ # Reusable UI components
│ └── services/ # Speech recognition & storage logic
│
├── assets/ # Icons, images, fonts
├── android/ # Android-specific files
├── ios/ # iOS-specific setup
├── web/ # Web build files
└── pubspec.yaml # Dependencies & metadata
```



