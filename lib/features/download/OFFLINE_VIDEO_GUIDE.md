# 📱 Hướng Dẫn Sử Dụng Tính Năng Xem Phim Offline - UPDATED với GoRouter

## 🎯 Tổng Quan

Tính năng xem phim offline cho phép người dùng:
- Tải xuống phim để xem khi không có internet
- Quản lý danh sách phim đã tải
- Xem phim offline với player tùy chỉnh (sử dụng Chewie)
- Mini player khi chuyển màn hình (giống như xem phim online)
- Quản lý dung lượng lưu trữ
- **Navigation tập trung qua GoRouter và OfflineVideoHelper**

## 🏗️ Cấu Trúc Module

```
lib/features/download/
├── presentation/
│   └── widgets/
│       ├── downloaded_movies_page.dart          # Danh sách phim đã tải
│       ├── downloaded_episodes_page.dart        # Danh sách tập đã tải của 1 phim
│       ├── offline_video_player_page.dart       # Video player offline (Chewie)
│       └── offline_video_helper.dart            # Helper functions
```

## 📋 Các Màn Hình

### 1. DownloadedMoviesPage
**Mục đích:** Hiển thị tất cả bộ phim đã tải xuống

**Tính năng:**
- Grid view các bộ phim đã download
- Thông tin: số tập, dung lượng
- Stats header: tổng số phim, tập, dung lượng
- Navigation tới episodes của từng phim

**Cách truy cập:**
```dart
// Từ Profile Screen
OfflineVideoHelper.openDownloadedMovies(context);

// Hoặc trực tiếp
Navigator.push(context, MaterialPageRoute(
  builder: (context) => BlocProvider(
    create: (context) => downloadGetIt<DownloadBloc>(),
    child: const DownloadedMoviesPage(),
  ),
));
```

### 2. DownloadedEpisodesPage  
**Mục đích:** Hiển thị các tập đã tải của một bộ phim

**Tính năng:**
- List view các tập với thumbnail
- Thông tin: ngày tải, dung lượng
- Play buttons cho từng tập
- Delete individual/all episodes
- Movie header với stats

**Sử dụng:**
```dart
Navigator.push(context, MaterialPageRoute(
  builder: (context) => DownloadedEpisodesPage(
    movieName: "Tên Phim",
    episodes: listDownloadedEpisodes,
  ),
));
```

### 3. OfflineVideoPlayerPage
**Mục đích:** Phát video đã tải xuống offline

**Tính năng:**
- **Chewie Integration:** Sử dụng Chewie giống như online player
- **Mini Player Support:** Khi back sẽ hiển thị mini player
- **Fullscreen Mode:** Landscape orientation tự động
- **Episode Navigation:** Previous/Next episode overlay
- **Position Tracking:** Lưu vị trí xem (có thể mở rộng)
- **Error Handling:** Retry mechanism cho lỗi file

**Sử dụng:**
```dart
// Method 1: Qua Helper (Khuyến khích)
OfflineVideoHelper.playOfflineVideo(
  context,
  episode: downloadEntity,
  playlist: allEpisodesOfMovie,
  currentIndex: 0,
);

// Method 2: Trực tiếp (cần MultiBlocProvider)
Navigator.push(context, MaterialPageRoute(
  builder: (context) => MultiBlocProvider(
    providers: [
      BlocProvider.value(value: context.read<MiniPlayerBloc>()),
      BlocProvider.value(value: context.read<AuthenticationBloc>()),
    ],
    child: OfflineVideoPlayerPage(
      episode: episode,
      allEpisodes: episodes,
      currentIndex: index,
    ),
  ),
));
```

## 🔧 Helper Functions

### OfflineVideoHelper
```dart
// Mở màn hình downloaded movies
OfflineVideoHelper.openDownloadedMovies(context);

// Phát video offline (với mini player support)
OfflineVideoHelper.playOfflineVideo(
  context, 
  episode: episode,
  playlist: allEpisodes,
  currentIndex: 0,
);

// Format file size
String size = OfflineVideoHelper.formatFileSize(bytes);

// Format duration  
String time = OfflineVideoHelper.formatDuration(duration);

// Hiển thị storage info
OfflineVideoHelper.showStorageInfo(
  context,
  totalMovies: 5,
  totalEpisodes: 50, 
  totalSize: 1024000000,
);
```

## 🎮 User Journey

### Luồng 1: Từ Profile Screen
```
Profile Screen 
    → Tap "Phim đã tải"
    → DownloadedMoviesPage 
    → Tap một phim
    → DownloadedEpisodesPage
    → Tap play tập
    → OfflineVideoPlayerPage (Fullscreen + Chewie)
    → Back button → Mini Player hiển thị
```

### Luồng 2: Mini Player Interaction
```
OfflineVideoPlayerPage → Back
    → Mini Player (có thể drag, play/pause, close, maximize)
    → Tap maximize → Quay lại OfflineVideoPlayerPage
    → Tap close → Dừng video và ẩn mini player
```

## 📱 UI/UX Features

### OfflineVideoPlayerPage (NEW)
- **Chewie Integration:** Controls tự động ẩn/hiện, seek bar, fullscreen
- **Landscape Mode:** Tự động chuyển landscape + immersive UI
- **Episode Navigation:** Overlay bên phải với previous/next buttons
- **Position Tracking:** Timer mỗi 5s để save position
- **Error Recovery:** File không tồn tại → Error screen với retry
- **Mini Player:** PopScope handler để show mini player khi back

### Mini Player (UPDATED)
- **Offline Support:** ChewieController được tạo từ local VideoPlayerController
- **Same UX:** Drag, play/pause, maximize, close giống như online
- **File-based playback:** Support cho VideoPlayerController.file()

## 🔍 Technical Implementation

### Video Player Integration
```dart
// Khởi tạo cho offline video
_videoPlayerController = VideoPlayerController.file(File(localPath));
_chewieController = ChewieController(
  videoPlayerController: _videoPlayerController,
  autoInitialize: true,
  autoPlay: false,
  fullScreenByDefault: true,
  showControls: true,
  materialProgressColors: ChewieProgressColors(
    playedColor: AppColor.primaryDark,
    // ...
  ),
);
```

### Mini Player Integration
```dart
// PopScope để handle back button
PopScope(
  onPopInvokedWithResult: (didPop, result) async {
    // Pause video & restore orientation
    await _videoPlayerController.pause();
    
    // Show mini player
    context.read<MiniPlayerBloc>().add(
      ShowMiniPlayer(
        movie: _createMovieEntityFromEpisode(),
        controller: _videoPlayerController,
        // ...
      ),
    );
    Navigator.pop(context);
  },
  child: Scaffold(...)
)
```

### Mock Entity for Offline
```dart
// Tạo mock movie entity cho mini player
MockMovieEntity _createMovieEntityFromEpisode() {
  return MockMovieEntity(
    name: episode.movieName,
    thumbUrl: episode.thumbnailUrl,
    episodeTotal: allEpisodes.length.toString(),
    episodes: allEpisodes.map((e) => MockEpisode(
      serverName: 'Offline',
      serverData: [MockEpisodeData(
        name: e.episodeName,
        linkM3u8: e.localPath, // Local file path
      )],
    )).toList(),
  );
}
```

## 🚀 Sử Dụng Nhanh

```dart
// 1. Thêm nút vào UI
ElevatedButton(
  onPressed: () => OfflineVideoHelper.openDownloadedMovies(context),
  child: Text('Xem Phim Offline'),
)

// 2. Phát video trực tiếp với mini player support
OfflineVideoHelper.playOfflineVideo(
  context, 
  episode: myEpisode,
  playlist: allEpisodes,
);

// 3. Từ profile (đã tích hợp)
// User tap "Phim đã tải" → Auto mở DownloadedMoviesPage
// User play video → Auto có mini player khi back
```

## ⚡ Performance & Best Practices

### Optimizations
- **BlocProvider reuse:** MultiBlocProvider để share existing blocs
- **File validation:** Check file existence trước khi play
- **Memory management:** Dispose controllers properly
- **Orientation handling:** Auto restore portrait khi back

### Error Handling
- **File not found:** Clear error message + retry button
- **Invalid path:** Snackbar notification
- **Player initialization:** Loading state → Error state → Retry

## 🔄 Integration Points

### Existing Systems
- **MiniPlayerBloc:** Reuse existing logic cho offline videos
- **AuthenticationBloc:** Position tracking (có thể mở rộng)
- **Theme System:** AppColor, consistent styling
- **Navigation:** Seamless với existing router

### Future Enhancements
- **SharedPreferences:** Lưu watch position cho offline videos
- **Download Progress:** Real-time tracking trong player
- **Subtitle Support:** Local subtitle files
- **Quality Selection:** Multiple quality levels offline 

## 🔄 Navigation Architecture

### GoRouter Routes (app_router.dart)

```dart
// Download route constants
static const String downloadedMoviesScreenPath = '/profile_tab/downloaded_movies_screen';
static const String downloadedEpisodesScreenPath = '/profile_tab/downloaded_movies_screen/downloaded_episodes_screen'; 
static const String offlineVideoPlayerScreenPath = '/profile_tab/downloaded_movies_screen/offline_video_player_screen';
static const String downloadEpisodesScreenPath = '/home_tab/movie_detail/download_episodes_screen';
```

### Route Structure
```
ProfileTab/
├── DownloadedMoviesPage
│   └── DownloadedEpisodesPage
│       └── OfflineVideoPlayerPage

MovieDetail/
└── DownloadEpisodesPage
```

## 🔧 Helper Methods Cập Nhật

### OfflineVideoHelper (UPDATED)

```dart
// 1. Hiển thị download bottom sheet
OfflineVideoHelper.showDownloadBottomSheet(context);

// 2. Mở màn hình downloaded movies  
OfflineVideoHelper.openDownloadedMovies(context);

// 3. Mở màn hình downloaded episodes của một phim
OfflineVideoHelper.openDownloadedEpisodes(
  context,
  movieName: "Tên Phim",
  episodes: listEpisodes,
);

// 4. Mở màn hình download episodes (cho download)
OfflineVideoHelper.openDownloadEpisodes(
  context, 
  movie: movieEntity,
);

// 5. Phát video offline với mini player
OfflineVideoHelper.playOfflineVideo(
  context,
  episode: episode,
  playlist: allEpisodes,
  currentIndex: 0,
);
```

## 🚀 Cách Sử Dụng Mới

### 1. Từ Movie Detail - Download Episodes
```dart
// Thay vì Navigator.push
OfflineVideoHelper.openDownloadEpisodes(context, movie: movie);

// Hoặc từ download bottom sheet button "Xem tất cả"
OfflineVideoHelper.showDownloadBottomSheet(context);
```

### 2. Từ Profile - Xem Offline Movies
```dart
// Button trong Profile Screen
ElevatedButton(
  onPressed: () => OfflineVideoHelper.openDownloadedMovies(context),
  child: Text('Phim đã tải'),
)
```

### 3. Navigation Flow với GoRouter
```
Profile Screen → Tap "Phim đã tải"
   ↓ (GoRouter.push)
DownloadedMoviesPage → Tap một phim  
   ↓ (GoRouter.push với parameters)
DownloadedEpisodesPage → Tap play
   ↓ (GoRouter.push với episode data)  
OfflineVideoPlayerPage → Back button
   ↓ (PopScope → Mini Player)
Mini Player (draggable, maximize/close)
```

## 📋 Route Parameters

### DownloadedEpisodesPage
```dart
context.push(AppRouter.downloadedEpisodesScreenPath, extra: {
  'movieName': 'Tên Phim',
  'episodes': List<DownloadEntity>,
});
```

### OfflineVideoPlayerPage  
```dart
context.push(AppRouter.offlineVideoPlayerScreenPath, extra: {
  'episode': DownloadEntity,
  'allEpisodes': List<DownloadEntity>,
  'currentIndex': int,
});
```

### DownloadEpisodesPage
```dart
context.push(AppRouter.downloadEpisodesScreenPath, extra: {
  'movie': MovieEntity,
});
```

## 🔄 BlocProvider Management

### Automatic Setup trong Routes
```dart
// DownloadedMoviesPage
child: BlocProvider(
  create: (context) => downloadGetIt<DownloadBloc>(),
  child: const DownloadedMoviesPage(),
),

// OfflineVideoPlayerPage  
child: MultiBlocProvider(
  providers: [
    BlocProvider.value(value: context.read<MiniPlayerBloc>()),
    BlocProvider.value(value: context.read<AuthenticationBloc>()),
  ],
  child: OfflineVideoPlayerPage(...),
),
```

### Download Bottom Sheet Setup
```dart
// Helper tự động setup MultiBlocProvider
OfflineVideoHelper.showDownloadBottomSheet(context);
// Includes: DownloadBloc, MovieBloc, AuthenticationBloc
```

## ⚡ Migration Guide

### Before (Old Navigation)
```dart
// ❌ Old way
Navigator.push(context, MaterialPageRoute(
  builder: (context) => BlocProvider(
    create: (context) => downloadGetIt<DownloadBloc>(),
    child: DownloadedMoviesPage(),
  ),
));
```

### After (New Navigation)  
```dart
// ✅ New way
OfflineVideoHelper.openDownloadedMovies(context);
```

## 🎮 Complete User Journey

### Download Flow
```
Movie Detail → Tap Download Button
   ↓
DownloadBottomSheet (showDownloadBottomSheet)
   ↓ "Xem tất cả" button  
DownloadEpisodesPage (openDownloadEpisodes)
   ↓ Select episodes → Download
```

### Playback Flow
```
Profile → "Phim đã tải"
   ↓ (openDownloadedMovies)
DownloadedMoviesPage → Select movie
   ↓ (openDownloadedEpisodes)  
DownloadedEpisodesPage → Play episode
   ↓ (playOfflineVideo)
OfflineVideoPlayerPage → Mini Player
```

## 🔧 Advanced Features

### Route-based State Management
- GoRouter tự động handle back button
- Parameters được type-safe với extra maps
- BlocProvider setup tự động trong routes

### Error Recovery
- Route not found → Redirect về home
- Invalid parameters → Default values
- Missing BlocProviders → Proper error screens

## 📱 Updated Integration Points

### Movie Detail Screen
```dart
// Download button action
onPressed: () => OfflineVideoHelper.showDownloadBottomSheet(context),
```

### Profile Screen  
```dart
// Offline movies button
onPressed: () => OfflineVideoHelper.openDownloadedMovies(context),
```

### Download Bottom Sheet
```dart
// "Xem tất cả" button
onPressed: () {
  Navigator.pop(context);
  OfflineVideoHelper.openDownloadEpisodes(context, movie: movie);
}
```

## 🚀 Performance Benefits

- **Centralized Navigation:** Tất cả navigation logic trong một helper
- **Route Caching:** GoRouter cache routes cho performance tốt hơn
- **Memory Management:** BlocProviders được quản lý automatic
- **Type Safety:** Parameters với proper typing và validation

Việc sử dụng GoRouter và OfflineVideoHelper giúp code dễ maintain, consistent navigation experience, và better performance management.

## 🐛 Bug Fixes & Troubleshooting

### GoRouter Complex Data Warning
**Vấn đề:** `[GoRouter] An extra with complex data type _Map<String, dynamic> is provided without a codec`

**Giải pháp:** Sử dụng temporary data holders trong OfflineVideoHelper thay vì extra parameters:
```dart
// ❌ Before: Extra parameters
context.push('/route', extra: {'movie': movie, 'episodes': episodes});

// ✅ After: Temp data holders
OfflineVideoHelper._tempMovieHolder = movie;
OfflineVideoHelper._tempEpisodesHolder = episodes;
context.push('/route');
```

### Download Status Không Hiển Thị
**Vấn đề:** Episodes đã download không được đánh dấu đúng trong UI

**Nguyên nhân:** Episode name có server suffix `(ServerName)` nhưng logic check không match

**Giải pháp:** Cập nhật logic kiểm tra download status:
```dart
// Kiểm tra cả episode name gốc và có server
bool _isEpisodeDownloaded(String movieName, String episodeName) {
  return _downloads.any((download) =>
      download.movieName == movieName &&
      (download.episodeName == episodeName ||
       download.episodeName.startsWith(episodeName)) &&
      download.status == DownloadStatus.completed);
}
```

### Download Button Spinning
**Vấn đề:** Download button quay liên tục, không hiển thị trạng thái đúng

**Nguyên nhân:** Logic kiểm tra `isDownloading` và `isDownloaded` không consistent

**Giải pháp:** 
1. Sử dụng cùng logic `_findDownload()` cho tất cả checks
2. Update download list trong `BlocListener` để refresh UI
3. Kiểm tra episode name với và không có server suffix

### Navigation Data Loss
**Vấn đề:** Data bị mất khi navigate giữa các screens

**Giải pháp:** Temporary data holder pattern:
```dart
class OfflineVideoHelper {
  static List<DownloadEntity>? _tempEpisodesHolder;
  static String? _tempMovieNameHolder;
  
  // Store data before navigation
  static void openDownloadedEpisodes(BuildContext context, {
    required String movieName,
    required List<DownloadEntity> episodes,
  }) {
    _tempMovieNameHolder = movieName;
    _tempEpisodesHolder = episodes;
    context.push(AppRouter.downloadedEpisodesScreenPath);
  }
  
  // Retrieve and clear after use
  @override
  void initState() {
    movieName = OfflineVideoHelper.tempMovieName ?? widget.movieName;
    episodes = OfflineVideoHelper.tempEpisodes ?? widget.episodes;
    OfflineVideoHelper.clearTempData();
  }
}
```

### UI State Không Update
**Vấn đề:** UI không reflect trạng thái download mới nhất

**Giải pháp:** 
1. Load downloads trong `initState()` của mỗi screen
2. Listen to DownloadBloc state changes
3. Update local state khi DownloadLoaded

```dart
@override
void initState() {
  super.initState();
  context.read<DownloadBloc>().add(LoadDownloadsEvent());
}

BlocListener<DownloadBloc, DownloadState>(
  listener: (context, state) {
    if (state is DownloadLoaded) {
      setState(() {
        _downloads = state.downloads;
      });
    }
  },
  child: ...
)
```

## 🔧 Best Practices

### Navigation
- ✅ Sử dụng `OfflineVideoHelper` methods cho navigation
- ✅ Clear temp data sau khi sử dụng  
- ✅ Fallback với widget parameters nếu temp data null

### Download Status Check
- ✅ Kiểm tra cả episode name gốc và có server suffix
- ✅ Sử dụng cùng logic `_findDownload()` trong tất cả components
- ✅ Update UI khi DownloadBloc state thay đổi

### Error Handling  
- ✅ Validate data trước khi navigation
- ✅ Show meaningful error messages
- ✅ Graceful fallback khi data missing 

## 🎨 UI/UX Improvements

### Simplified Download Status Display
**Cải tiến:** Episodes hiển thị trạng thái download bằng icons đơn giản thay vì text chi tiết

**Benefits:**
- Clean và minimal UI design
- Dễ nhận biết trạng thái qua visual icons
- Performance tốt hơn (không render progress bars)

**Status Icons:**
```dart
// ✅ Completed - Green check icon
Icons.check_circle (Colors.green)

// 🔄 Downloading - Blue spinning progress
CircularProgressIndicator (AppColor.primaryDark)

// ❌ Failed - Red error icon  
Icons.error (Colors.red)

// ⏸️ Paused - Orange pause icon
Icons.pause_circle (Colors.orange)

// ⬇️ Available - Blue download icon
Icons.download (AppColor.primaryDark)
```

### Download Episodes Page Layout
- **Grid layout** với aspect ratio 3:1 để hiển thị nhiều tập trong một view
- **Episode name** căn giữa với status icon bên phải
- **Border color** indicates status (green = completed, blue = downloading)
- **Disabled state** cho episodes đã download hoặc đang download

### Download Bottom Sheet Optimization  
- **4 episodes preview** với option "Xem thêm X tập"
- **Server selection** với visual server indicators
- **Clean episode cards** chỉ hiển thị: thumbnail + name + server + status icon
- **No progress bars** trong bottom sheet để giữ UI clean

## 📱 Current User Experience

### Visual Status Indicators
```
┌─────────────────────────┐
│ Tập 1  [✓] ← Completed │ 
│ Tập 2  [○] ← Loading   │
│ Tập 3  [⬇] ← Available │
│ Tập 4  [❌] ← Failed    │
└─────────────────────────┘
```

### Download Flow UX
```
Movie Detail → Download Button 
    ↓
Download Bottom Sheet
    ├── Server Selection (visual tabs)
    ├── 4 Episodes Preview (status icons)
    └── "Xem thêm X tập" → Full Episode Grid
         ↓
Download Episodes Page
    ├── Movie Header (info + thumbnail) 
    ├── Server Selection (if multiple)
    └── Episodes Grid (2 columns, status icons)
```

### Performance Benefits  
- **No progress tracking** trong UI = better performance
- **Icon-only status** = faster rendering
- **Minimal text** = cleaner responsive design
- **Grid layout** = more episodes visible

## 🖼️ Image Error Handling

### CachedNetworkImage Error Fix
**Vấn đề:** `PathNotFoundException: Cannot retrieve length of file` với cached images

**Nguyên nhân:** Cache bị corrupted hoặc file không tồn tại trong cache directory

**Giải pháp đã implement:**

#### 1. Better Error Widgets
```dart
errorWidget: (context, url, error) {
  debugPrint('CachedNetworkImage error: $error');
  return Container(
    color: AppColor.greyScale700,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.image_not_supported, color: Colors.grey),
        Text('Ảnh lỗi', style: TextStyle(color: Colors.grey)),
      ],
    ),
  );
}
```

#### 2. Custom Cache Keys
```dart
// Unique cache keys to avoid conflicts
cacheKey: movie?.posterUrl?.isNotEmpty == true 
    ? 'movie_${Uri.parse(movie.posterUrl).pathSegments.last}' 
    : null,
```

#### 3. Cache Management Methods
```dart
// Clear toàn bộ image cache
OfflineVideoHelper.clearImageCache();

// Clear specific image
OfflineVideoHelper.clearSpecificImageCache(imageUrl);

// Show clear cache dialog
OfflineVideoHelper.showClearCacheDialog(context);
```

### Error Handling Features
- ✅ **Graceful Fallback**: Show "Ảnh lỗi" thay vì crash
- ✅ **Debug Logging**: Log errors để troubleshooting
- ✅ **Cache Management**: Clear cache option trong menu
- ✅ **Null Safety**: Safe handling cho empty/null URLs
- ✅ **Fade Animations**: Smooth transitions khi load images

### User Experience Improvements
- **No more crashes** khi images fail to load
- **Visual feedback** khi có lỗi với images
- **Clear cache option** trong Downloaded Movies menu
- **Consistent error states** across all download screens

### Troubleshooting Image Issues

#### Common Errors:
1. **PathNotFoundException** → Cache corrupted
2. **SocketException** → Network issues  
3. **FormatException** → Invalid image format

#### Solutions:
1. **Clear Cache**: Menu → "Xóa cache ảnh"
2. **Check Network**: Ensure stable internet connection
3. **Restart App**: Force refresh image cache
4. **Update URLs**: Ensure image URLs are valid

### Cache Strategy
- **Unique Keys**: Prevent cache conflicts between screens
- **Fallback Images**: Default placeholders for missing images
- **Error Recovery**: Auto-retry mechanisms (future enhancement)
- **Memory Management**: Clear cache to free up space
