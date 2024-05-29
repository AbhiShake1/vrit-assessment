import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:vrit_birthday/app/widgets/widgets.dart';
import 'package:vrit_birthday/login/auth_utils.dart';

class LoginPage extends HookWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final nav = Navigator.of(context);

    useEffect(
      () {
        FirebaseAuth.instance.authStateChanges().listen((u) {
          if (u != null) {
            Future.microtask(
              () => nav.pushNamed('/photos'),
            );
          }
        });
        return null;
      },
      [],
    );

    useEffect(
      () {
        if (user != null) {
          Future.microtask(
            () => nav.pushNamed('/photos'),
          );
        }
        return null;
      },
      [user],
    );

    return VritScaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to Vrit Photos',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(
            height: 6,
          ),
          const _LoginButton(
            onTap: signInWithGoogle,
            text: 'Sign in with google',
            icon: Icons.aod,
          ),
          if (!kIsWeb && Platform.isIOS)
            const _LoginButton(
              onTap: signInWithApple,
              text: 'Sign in with apple',
              icon: Icons.apple,
            ),
        ],
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({
    required this.onTap,
    required this.text,
    required this.icon,
  });

  final VoidCallback onTap;
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 16,
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(
              width: 6,
            ),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
