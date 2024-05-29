import 'package:flutter_test/flutter_test.dart';
import 'package:vrit_birthday/app/app.dart';
import 'package:vrit_birthday/login/login_page.dart';
import 'package:vrit_birthday/photos/photos_page.dart';

void main() {
  group('App', () {
    testWidgets('renders LoginPage when logged out', (tester) async {
      await tester.pumpWidget(const App(isLoggedIn: false));
      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets('renders PhotosPage when logged in', (tester) async {
      await tester.pumpWidget(const App(isLoggedIn: true));
      expect(find.byType(PhotosPage), findsOneWidget);
    });
  });
}
