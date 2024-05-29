import 'package:firebase_auth/firebase_auth.dart';
import 'package:vrit_birthday/app/data/service/vrit_api.dart';

abstract class VritService {
  VritApi get api => VritApi();

  User? get currentUser => FirebaseAuth.instance.currentUser;

  // TODO(OutOfScope): add better identifier
  String get currentUserId {
    if (currentUser == null) {
      // ignore: only_throw_errors
      throw 'Please login';
    }
    return currentUser!.email!;
  }
}

extension TryOrNull<T> on T Function() {
  T? tryOrNull() {
    try {
      return this();
    } catch (_) {
      return null;
    }
  }
}
