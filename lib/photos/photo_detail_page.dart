import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:vrit_birthday/app/extensions/extensions.dart';
import 'package:vrit_birthday/app/utils/set_wallpaper.dart';
import 'package:vrit_birthday/app/widgets/widgets.dart';
import 'package:vrit_birthday/photos/data/photos_service.dart';

class PhotoDetailPage extends HookWidget {
  const PhotoDetailPage(this._photo, {super.key});

  final PhotoModel _photo;

  @override
  Widget build(BuildContext context) {
    final PhotoModel(:url) = _photo;
    final success = context.snackbar.success;
    return VritScaffold(
      body: Column(
        children: [
          if (url != null) Image.network(url),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LikeButton(_photo),
              InkWell(
                onTap: () async {
                  await setWallpaper(url);
                  success('Wallpaper set');
                },
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

    useEffect(() {
      PhotosService().checkIfLiked(_photo).then((l) {
        // wont rebuild if it was already true
        if (l) liked.value = true;
      });
      return null;
    });

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
