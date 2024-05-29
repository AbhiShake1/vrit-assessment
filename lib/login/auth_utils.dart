import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

Future<UserCredential?> signInWithGoogle() async {
  final user = await GoogleSignIn().signIn();

  if (user == null) return null;

  print(user);

  final GoogleSignInAuthentication(:accessToken, :idToken) =
      await user.authentication;

  final credential = GoogleAuthProvider.credential(
    accessToken: accessToken,
    idToken: idToken,
  );

  return FirebaseAuth.instance.signInWithCredential(credential);
}

Future<UserCredential?> signInWithApple() async {
  final AuthorizationCredentialAppleID(:userIdentifier, :identityToken) =
      await SignInWithApple.getAppleIDCredential(
    scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ],
  );
  if (identityToken == null) return null;
  final credential = GoogleAuthProvider.credential(
    idToken: base64Url.encode(utf8.encode(identityToken)),
  );

  return FirebaseAuth.instance.signInWithCredential(credential);
}
