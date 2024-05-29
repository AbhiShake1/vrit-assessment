import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:vrit_birthday/app/extensions/extensions.dart';

typedef DataOr<T> = (T? data, {Exception? err});

final _dio = Dio();

const _authHeaders = {
  'Authorization': 'Mxlbg60S6hI1eUlPvXQABPi4ycvOFihxBxGOfDWRYwiu8fXaFeLA9YC4',
};

class VritApi {
  factory VritApi() => _instance ??= const VritApi._();
  const VritApi._();
  static VritApi? _instance;

  Future<DataOr<Map<String, dynamic>>> get(
    String path, {
    Map<String, dynamic> query = const {},
  }) async {
    Map<String, dynamic>? data;
    Exception? err;
    final httpRes = await _dio.get<Map<String, dynamic>>(
      'https://api.pexels.com/v1/$path',
      queryParameters: {
        for (final MapEntry(:key, :value) in query.entries)
          if (value != null) key: value,
      },
      options: Options(
        headers: _authHeaders,
      ),
    );
    if (httpRes.statusCode == 200) {
      data = httpRes.data;
    } else {
      err = Exception(httpRes.data);
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
      context.snackbar.error(err.toString());
    }

    return fn(d);
  }
}
