import 'package:vrit_birthday/app/app.dart';
import 'package:vrit_birthday/bootstrap.dart';

void main() {
  bootstrap(
    (isLoggedIn) => App(
      isLoggedIn: isLoggedIn,
    ),
  );
}
