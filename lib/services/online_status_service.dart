import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OnlineStatusService {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;

  static Future<void> setOnline() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final userRef = _firestore.collection('users').doc(user.uid);
    await userRef.update({
      'isOnline': true,
      'lastSeen': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> setOffline() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final userRef = _firestore.collection('users').doc(user.uid);
    await userRef.update({
      'isOnline': false,
      'lastSeen': FieldValue.serverTimestamp(),
    });
  }
}
