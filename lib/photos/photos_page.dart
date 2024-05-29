import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:vrit_birthday/app/data/service/vrit_api.dart';
import 'package:vrit_birthday/app/utils/fcm.dart';
import 'package:vrit_birthday/app/widgets/widgets.dart';
import 'package:vrit_birthday/photos/data/photos_service.dart';
import 'package:vrit_birthday/photos/photo_detail_page.dart';

enum Tabs {
  profile('Profile', Icons.person),
  home('Home', Icons.home),
  favorites('Favourites', Icons.favorite);

  const Tabs(this.label, this.icon);

  final String label;
  final IconData icon;
}

class PhotosPage extends HookWidget {
  const PhotosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final activeIndex = useState(1);

    return VritScaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: activeIndex.value,
        onTap: (i) => activeIndex.value = i,
        items: [
          for (final Tabs(:icon, :label) in Tabs.values)
            BottomNavigationBarItem(
              icon: Icon(icon),
              label: label,
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: switch (activeIndex.value) {
          0 => const _Profile(),
          1 => const _Photos(),
          _ => const _Favourites(),
        },
      ),
    );
  }
}

class _Profile extends HookWidget {
  const _Profile();

  @override
  Widget build(BuildContext context) {
    return CupertinoDatePicker(
      initialDateTime: DateTime.now(),
      onDateTimeChanged: (DateTime newDateTime) {
        final isThisMonth = newDateTime.month == DateTime.now().month;
        if (!isThisMonth) return;

        showFlutterNotification(
          RemoteMessage(
            notification: RemoteNotification(
              title: 'Happy birth month',
              body:
                  'Happy birth month ${FirebaseAuth.instance.currentUser?.displayName ?? ""}',
            ),
          ),
        );
      },
    );
  }
}

class _Favourites extends HookWidget {
  const _Favourites();

  @override
  Widget build(BuildContext context) {
    final photos = useState<List<PhotoModel>?>(null);

    useEffect(
      () {
        PhotosService().getLikedPhotos().then((p) {
          photos.value = p.photos;
        });
        return null;
      },
      [],
    );
    return _Photos(photos.value);
  }
}

class _Photos extends HookWidget {
  const _Photos([this._photos]);

  final List<PhotoModel>? _photos;

  @override
  Widget build(BuildContext context) {
    final photosState = useState<List<PhotoModel>>(_photos ?? []);
    final search = useState('');
    final debouncedSearch = useDebounced(
      search.value,
      const Duration(seconds: 2),
    );

    useEffect(
      () {
        if (_photos != null) return;

        void action(DataOr<SearchPhotosResponseModel> v) {
          v.orSnackbar(
            context,
            (d) => photosState.value = d?.photos ?? [],
          );
        }

        PhotosService().getPhotos(debouncedSearch).then(action);
        return null;
      },
      [debouncedSearch],
    );

    return Column(
      children: [
        if (_photos == null)
          TextFormField(
            onChanged: (v) => search.value = v,
            decoration: const InputDecoration(hintText: 'Search...'),
          ),
        const SizedBox(
          height: 8,
        ),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: [
            for (final photo in photosState.value)
              InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<dynamic>(
                    builder: (_) {
                      return PhotoDetailPage(photo);
                    },
                  ),
                ),
                child: DecoratedBox(
                  decoration: const BoxDecoration(),
                  child: photo.url == null
                      ? const SizedBox.shrink()
                      : Image.network(photo.url!),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
