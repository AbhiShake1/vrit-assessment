import 'package:flutter_test/flutter_test.dart';
import 'package:vrit_birthday/login/login_page.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('login page test', () {
    testWidgets(
      'shows google button',
      (tester) async {
        await tester.pumpApp(const LoginPage());
        final txt = find.text('Sign in with google');
        expect(txt, findsOneWidget);
      },
    );
  });
}
