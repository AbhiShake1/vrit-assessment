import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:vrit_birthday/app/extensions/extensions.dart';
import 'package:vrit_birthday/app/utils/set_wallpaper.dart';
import 'package:vrit_birthday/photos/data/photos_service.dart';
import 'package:vrit_birthday/photos/photos_page.dart';

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
              LikeButton(_photo),
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
  const LikeButton(this._photo, {super.key});

  final PhotoModel _photo;

  @override
  Widget build(BuildContext context) {
    final liked = useState(false);

    final showErr = context.snackbar.error;

    return InkWell(
      onTap: () async {
        final res = await PhotosService().likePhoto(_photo);
        res.fold(
          (d) {
            liked.value = !liked.value;
          },
          showErr,
        );
      },
      child: Icon(
        Icons.favorite,
        color: liked.value ? Colors.red : null,
      ),
    );
  }
}
