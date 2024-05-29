import 'package:async_wallpaper/async_wallpaper.dart';

Future<void> setWallpaper(String? url) async {
  if (url == null) return;

  await AsyncWallpaper.setWallpaper(
    url: url,
    // wallpaperLocation: AsyncWallpaper.HOME_SCREEN,
  );
}
