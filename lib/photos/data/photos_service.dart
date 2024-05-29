import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class PhotosService {
  factory PhotosService() => _instance ??= PhotosService();
  static PhotosService? _instance;

  Future<Either<SearchPhotosResponseModel, Exception>> getPhotos([
    String? search,
  ]) async {
    final res = await http.get(
      Uri.parse('https://api.pexels.com/v1/search?query=$search'),
    );

    if (res.statusCode != 200) {
      return Right(Exception(res.body));
    }

    final body = jsonDecode(res.body) as Map<String, dynamic>;

    final photos = SearchPhotosResponseModel.fromJson(body);

    return Left(photos);
  }

  Future<Either<SearchPhotosResponseModel, Exception>> getLikedPhotos([
    String? search,
  ]) async {
    final userId = FirebaseAuth.instance.currentUser!.email;
    final collection = FirebaseFirestore.instance.collection('users');

    final res = await collection.doc(userId).get();

    return Left(
      SearchPhotosResponseModel.fromJson({
        'photos': res.data()?['likedPhotos'],
      }),
    );
  }

  Future<Either<void, Exception>> likePhoto(PhotoModel photo) async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.email;
      final collection = FirebaseFirestore.instance.collection('users');

      final prev = await collection.get();

      await collection.doc(userId).set(
        {
          'likedPhotos': [...prev.docs, photo.toJson()],
        },
        SetOptions(
          merge: true,
        ),
      ); // Using merge option to update only the specified fields

      return const Left(null);
    } catch (e) {
      return Right(Exception(e.toString()));
    }
  }
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

class PhotoModel {
  PhotoModel({
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

  Map<String, dynamic> toJson() => {
        'url': url,
        'id': id,
        'width': width,
        'height': height,
      };
}
