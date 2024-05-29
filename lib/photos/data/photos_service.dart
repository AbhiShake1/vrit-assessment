import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:vrit_birthday/app/data/service/api_stores.dart';
import 'package:vrit_birthday/app/data/service/vrit_api.dart';
import 'package:vrit_birthday/app/data/service/vrit_service.dart';

class PhotosService extends VritService {
  factory PhotosService() => _instance ??= PhotosService._();

  PhotosService._();
  static PhotosService? _instance;

  // ignore: prefer_function_declarations_over_variables
  late final getPhotos = ([
    String? search,
  ]) async {
    final (photos, :err) = await api.get('search?query=$search');
    return (photos.parse(SearchPhotosResponseModel.fromJson), err: err);
  };

  // ignore: prefer_function_declarations_over_variables
  late final getLikedPhotos = () async {
    final res = await FirebaseCollection.users.doc(currentUserId).get();

    return SearchPhotosResponseModel.fromJson({
      'photos': res.data()?['likedPhotos'],
    });
  };

  Future<bool> checkIfLiked(PhotoModel photo) async {
    final liked = await getLikedPhotos.tryOrNull();

    return liked?.photos.contains(photo) ?? false;
  }

  // ignore: prefer_function_declarations_over_variables
  late final likePhoto = (PhotoModel photo) {
    () async {
      final doc = FirebaseCollection.users.doc(currentUserId);

      final prev = await FirebaseCollection.users.doc(currentUserId).get();

      final prevPhotos =
          (prev['likedPhotos'] as List<dynamic>).cast<Map<String, dynamic>>();

      await doc.set(
        {
          'likedPhotos': [...prevPhotos, photo.toJson()],
        },
        SetOptions(
          merge: true,
        ),
      );
    }.tryOrNull();
  };
}

class SearchPhotosResponseModel {
  SearchPhotosResponseModel({this.photos = const []});

  factory SearchPhotosResponseModel.fromJson(Map<String, dynamic> json) {
    final rawPhotos = json['photos'] as List<dynamic>?;

    return SearchPhotosResponseModel(
      photos: rawPhotos
              ?.map((p) => PhotoModel.fromJson(p as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
  final List<PhotoModel> photos;
}

@immutable
class PhotoModel {
  const PhotoModel({
    required this.url,
    required this.id,
    required this.width,
    required this.height,
  });
  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      url: json['url']?.toString(),
      id: int.tryParse(json['id']?.toString() ?? '0'),
      width: int.tryParse(json['width']?.toString() ?? '0'),
      height: int.tryParse(json['height']?.toString() ?? '0'),
    );
  }
  final String? url;

  final int? id;

  final int? width;
  final int? height;

  @override
  bool operator ==(Object other) =>
      other is PhotoModel &&
      other.url == url &&
      other.height == height &&
      other.id == id &&
      other.width == width;

  @override
  int get hashCode => Object.hashAll([url, id, width, height]);

  Map<String, dynamic> toJson() => {
        'url': url,
        'id': id,
        'width': width,
        'height': height,
      };
}
