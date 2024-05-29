import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:vrit_birthday/app/utils/set_wallpaper.dart';
import 'package:vrit_birthday/photos/data/photos_service.dart';

class PhotoDetailPage extends HookWidget {
  const PhotoDetailPage(this._photo, {super.key});

  final PhotoModel _photo;

  @override
  Widget build(BuildContext context) {
    final PhotoModel(:url) = _photo;
    return Scaffold(
      body: Column(
        children: [
          if (url != null) Image.network(url),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const LikeButton(),
              InkWell(
                onTap: () => setWallpaper(url),
                child: const Text('Set as wallpeper'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LikeButton extends HookWidget {
  const LikeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final liked = useState(false);

    return InkWell(
      onTap: () => liked.value = !liked.value,
      child: Icon(
        Icons.favorite,
        color: liked.value ? Colors.red : null,
      ),
    );
  }
}
