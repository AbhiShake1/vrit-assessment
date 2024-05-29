import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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

    return Scaffold(
      body: Column(
        children: [
          Material(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(6),
            child: const InkWell(
              onTap: signInWithGoogle,
              child: Row(
                children: [
                  Text('Sign in with google'),
                  SizedBox(
                    width: 6,
                  ),
                  Icon(Icons.verified_user),
                ],
              ),
            ),
          ),
          if (!kIsWeb && Platform.isIOS)
            Material(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(6),
              child: const InkWell(
                onTap: signInWithApple,
                child: Row(
                  children: [
                    Text('Sign in with apple'),
                    SizedBox(
                      width: 6,
                    ),
                    Icon(Icons.verified_user),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
