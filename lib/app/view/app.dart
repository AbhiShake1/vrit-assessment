import 'package:flutter/material.dart';
import 'package:vrit_birthday/l10n/l10n.dart';
import 'package:vrit_birthday/login/login_page.dart';
import 'package:vrit_birthday/photos/photos_page.dart';

class App extends StatelessWidget {
  const App({required this.isLoggedIn, super.key});

  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: const Color(0xFF13B9FF),
        ),
      ),
      onGenerateRoute: (settings) {
        final page = switch (settings.name) {
          '/photos' => const PhotosPage(),
          _ => const LoginPage(),
        };

        return MaterialPageRoute(builder: (_) => page);
      },
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: !isLoggedIn ? '/login' : '/photos',
    );
  }
}
