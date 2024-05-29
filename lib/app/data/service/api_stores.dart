import 'package:cloud_firestore/cloud_firestore.dart';

enum FirebaseCollection {
  users('users');

  const FirebaseCollection(this.collectionPath);

  final String collectionPath;

  DocumentReference<Map<String, dynamic>> doc(String path) =>
      FirebaseFirestore.instance.collection(collectionPath).doc(path);
}
