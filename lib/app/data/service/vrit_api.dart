import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:vrit_birthday/app/extensions/extensions.dart';

typedef DataOr<T> = (T? data, {Exception? err});

class VritApi {
  factory VritApi() => _instance ??= const VritApi._();
  const VritApi._();
  static VritApi? _instance;

  Future<DataOr<Map<String, dynamic>>> get(
    String path,
  ) async {
    Map<String, dynamic>? data;
    Exception? err;
    final httpRes = await http.get(
      Uri.parse('https://api.pixels.com/v1/$path'),
    );
    if (httpRes.statusCode == 200) {
      data = jsonDecode(httpRes.body) as Map<String, dynamic>;
    } else {
      err = Exception(httpRes.body);
    }
    return (data, err: err);
  }
}

extension ParseMapX on Map<String, dynamic>? {
  T? parse<T>(T Function(Map<String, dynamic> T) parser) {
    if (this == null) return null;

    return parser(this!);
  }
}

extension DataOrSnackbarX<T> on DataOr<T> {
  R? orSnackbar<R>(
    BuildContext context,
    R Function(T? data) fn,
  ) {
    final (d, :err) = this;
    if (err != null) {
      context.snackbar.error(err);
    }

    return fn(d);
  }
}
