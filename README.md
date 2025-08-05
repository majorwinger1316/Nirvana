# Nirvana Music Player 🎵

A beautiful, modern iOS music player app built with SwiftUI that combines local music playback with online music discovery.

## Screenshots

### Home Screen
<!-- Add screenshot of the main Nirvana tab with album grid -->
![Home Screen]<img width="1179" height="2556" alt="simulator_screenshot_B450BA58-720F-4B54-B1EE-D3B08700837B" src="https://github.com/user-attachments/assets/08fed3dd-12e6-4342-86d9-d3de9c001e8a" />

### Local Music Library
<!-- Add screenshot of the Offline tab showing local songs -->
![Local Library]<img width="1179" height="2556" alt="simulator_screenshot_38B737DC-6F92-4A5B-893B-8C7E8998DF61" src="https://github.com/user-attachments/assets/ef02975a-1736-4722-b9ef-e21091483714" />

### Mini Player
<!-- Add screenshot showing the mini player at bottom -->
![Mini Player]<img width="1179" height="248" alt="Simulator Screenshot - iPhone 16 - 2025-08-06 at 04 22 26" src="https://github.com/user-attachments/assets/bf3555d0-ebe1-4b9b-b1e0-6d21b0b054ab" />

### Full Screen Player

<!-- Add screenshot of the expanded player modal -->
![Full Player]![simulator_screenshot_52E46697-11D2-4D30-9861-FD730D31D6B0](https://github.com/user-attachments/assets/6c79357a-103e-4b65-a76a-9b5f8164ec6d)

### Queue Management
<!-- Add screenshot of the queue tab in player modal -->
![Queue]<img width="1179" height="2556" alt="simulator_screenshot_DCABF275-2A69-4278-9265-71FA59B5DEAC" src="https://github.com/user-attachments/assets/6fd7ebff-4af5-4176-bcbd-a176aafe202c" />

### Online Music Discovery
<!-- Add screenshot of The Weeknd albums page -->
![Online Discovery]<img width="1179" height="1366" alt="Simulator Screenshot - iPhone 16 - 2025-08-06 at 04 26 41" src="https://github.com/user-attachments/assets/34e3092e-4cbb-420d-8b4b-ed137550dcc2" />

## Features

### 🎧 **Local Music Playback**
- Import MP3 files from your device
- Full audio controls (play, pause, skip, previous)
- Background audio playback
- Queue management with reordering
- Shuffle and repeat modes (none, one, all)

### 🌐 **Online Music Discovery**
- Browse Coldplay and The Weeknd albums
- Beautiful grid layout with album artwork
- Integration with TheAudioDB API
- YouTube integration for full song playback
- Search functionality across albums

### 🎨 **Beautiful UI/UX**
- Modern SwiftUI design
- Animated gradient backgrounds
- Native iOS tab bar styling
- Smooth animations and transitions
- Dark/Light mode support
- Mini player with matched geometry effects

### 📱 **Core Features**
- **Local Storage**: SwiftData integration for persistent music library
- **File Management**: Document picker for importing MP3 files
- **Audio Session**: Proper AVAudioSession configuration
- **Queue System**: Smart queue management with drag-to-reorder
- **Search**: Real-time search across local and online content
- **Context Menus**: Long-press actions for songs and albums

## Technology Stack

- **Framework**: SwiftUI + iOS 17+
- **Data Persistence**: SwiftData
- **Audio Playback**: AVFoundation
- **Networking**: URLSession
- **APIs**: TheAudioDB API
- **Architecture**: MVVM pattern

## Installation

### Prerequisites
- Xcode 15.0+
- iOS 17.0+
- Swift 5.9+

### Setup
1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/nirvana-music-player.git
   cd nirvana-music-player
   ```

2. **Open in Xcode**
   ```bash
   open Nirvana.xcodeproj
   ```

3. **Add required assets**
   - Add your default music file (`Gangsta_Paradise.mp3`) to the bundle
   - Add corresponding album artwork (`coolio.jpg`) to Assets catalog

4. **Build and run**
   - Select your target device/simulator
   - Press `Cmd + R` to build and run

### Configuration

#### API Keys
The app uses TheAudioDB API which doesn't require authentication, but if you want to extend functionality:

```swift
// APIConstants.swift
enum APIConstants {
    static let coldplayDiscographyURL = "https://theaudiodb.com/api/v1/json/2/discography.php?s=coldplay"
    static let weekndAlbumsURL = "https://www.theaudiodb.com/api/v1/json/2/album.php?i=112024"
    static let weekndMusicVideosURL = "https://www.theaudiodb.com/api/v1/json/2/mvid.php?i=112024"
}
```

## Project Structure

```
Nirvana/
├── App/
│   ├── NirvanaApp.swift              # App entry point
│   └── ContentView.swift             # Main container view
├── Views/
│   ├── OnlineView.swift              # Online music discovery
│   ├── LocalSongsView.swift          # Local music library
│   ├── WeekndAlbumsView.swift        # Artist-specific view
│   ├── PlayerModalView.swift         # Full-screen player
│   ├── MiniPlayerView.swift          # Bottom mini player
│   └── Components/
│       ├── AnimatedGradientView.swift
│       ├── ToastView.swift
│       └── VisualEffectView.swift
├── ViewModels/
│   └── OnlineViewModel.swift         # Online content management
├── Models/
│   ├── Song.swift                    # Song data model
│   ├── Album.swift                   # Album data model
│   ├── Item.swift                    # SwiftData models
│   └── OnlineMusic.swift             # API response models
├── Services/
│   ├── AudioPlayer.swift             # Audio playback engine
│   └── APIConstants.swift            # API endpoints
├── Utilities/
│   ├── DocumentPicker.swift          # File import utility
│   └── Extensions.swift              # Helper extensions
└── Resources/
    ├── Assets.xcassets               # Images and colors
    └── Gangsta_Paradise.mp3          # Default audio file
```

## How to Use

### Adding Local Music
1. Open the **Offline** tab
2. Tap the **+** button in the navigation bar
3. Select MP3 files from your device
4. Songs will be imported and appear in your library

### Playing Music
- **Tap any song** to start playback
- Use the **mini player** at the bottom for basic controls
- **Tap the mini player** to open the full-screen player
- **Swipe down** to dismiss the full-screen player

### Managing Queue
1. Open the full-screen player
2. Switch to the **Queue** tab
3. **Drag to reorder** songs
4. **Tap X** to remove songs from queue

### Online Discovery
1. Browse albums in the **Nirvana** tab
2. **Tap album covers** to add to your library
3. **Long press** for additional options
4. Songs will open in YouTube for full playback

## API Integration

### TheAudioDB API
The app integrates with TheAudioDB API for music metadata:

- **Artist Albums**: Fetches discography data
- **Album Artwork**: High-quality cover images
- **Music Videos**: YouTube integration for playback
- **Metadata**: Release dates, track information

### Response Examples
```json
{
  "album": [
    {
      "strAlbum": "Parachutes",
      "intYearReleased": "2000",
      "strAlbumThumb": "https://example.com/artwork.jpg"
    }
  ]
}
```

## Customization

### Adding New Artists
1. **Update APIConstants.swift** with new API endpoints
2. **Extend OnlineViewModel** with fetch methods
3. **Add UI sections** in OnlineView
4. **Create artist-specific views** if needed

### Theming
```swift
// Update color scheme in AnimatedGradientView
private let colors = [
    Color.purple.opacity(0.4),
    Color.bg.opacity(0.4),      // Your custom color
    Color.indigo.opacity(0.4)
]
```

### Audio Formats
Currently supports MP3. To add more formats:
```swift
// Update DocumentPicker.swift
let picker = UIDocumentPickerViewController(
    forOpeningContentTypes: [.mp3, .m4a, .wav] // Add desired formats
)
```

## Contributing

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/amazing-feature`)
3. **Commit your changes** (`git commit -m 'Add some amazing feature'`)
4. **Push to the branch** (`git push origin feature/amazing-feature`)
5. **Open a Pull Request**

### Contribution Guidelines
- Follow Swift style guide
- Add unit tests for new features
- Update documentation as needed
- Ensure UI accessibility compliance

## Known Issues

- Online songs currently redirect to YouTube (no in-app streaming)
- Limited to MP3 format for local files
- Queue persistence between app launches not implemented
- No lyrics integration

## Future Enhancements

### Planned Features
- [ ] **Lyrics Integration** - Display synchronized lyrics
- [ ] **Equalizer** - Audio enhancement controls
- [ ] **Playlists** - User-created playlists
- [ ] **Social Features** - Share songs and playlists
- [ ] **CarPlay Support** - In-vehicle integration
- [ ] **Apple Watch** - Remote control functionality
- [ ] **Audio Streaming** - Direct audio playback for online songs
- [ ] **More Artists** - Expand online catalog

### Technical Improvements
- [ ] **Offline Sync** - Download songs for offline playback
- [ ] **Background Downloads** - Queue-based downloading
- [ ] **Core Data Migration** - Enhanced data persistence
- [ ] **Unit Tests** - Comprehensive test coverage
- [ ] **Performance Optimization** - Memory and battery improvements

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- **TheAudioDB** - Music metadata API
- **Apple** - SwiftUI and AVFoundation frameworks
- **Community** - Open source SwiftUI components and inspiration

## Support

If you enjoy this project, please consider:
- ⭐ **Starring the repository**
- 🐛 **Reporting issues**
- 💡 **Suggesting new features**
- 🔄 **Contributing code**

---
