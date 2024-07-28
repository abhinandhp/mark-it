import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FriendSerivces extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  Stream<QuerySnapshot<Map<String, dynamic>>> getallusersexpcurr() {
    return _firestore
        .collection('users')
        .where('uid', isNotEqualTo: currentUser!.uid)
        .snapshots();
  }

  Stream<List<Map<String, dynamic>>> frndreqstream() {
    return _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('frndreq')
        .snapshots()
        .asyncMap((snapshot) async {
      final frndreIds = snapshot.docs.map((doc) => doc.id).toList();

      final userDocs = await Future.wait(
        frndreIds.map(
          (id) => _firestore.collection('users').doc(id).get(),
        ),
      );

      return userDocs.map((e) => e.data() as Map<String,dynamic>).toList();
    });
  }

  Stream<List<Map<String, dynamic>>> friendsstream() {
    return _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('friends')
        .snapshots()
        .asyncMap((snapshot) async {
      final frndreIds = snapshot.docs.map((doc) => doc.id).toList();

      final userDocs = await Future.wait(
        frndreIds.map(
          (id) => _firestore.collection('users').doc(id).get(),
        ),
      );

      return userDocs.map((e) => e.data() as Map<String,dynamic>).toList();
    });
  }

  Future<void> sendFriendRequest(
      QueryDocumentSnapshot<Map<String, dynamic>> data) async {
    try {
      await _firestore
          .collection('users')
          .doc(data['uid'])
          .collection('frndreq')
          .doc(currentUser!.uid)
          .set({});
    } catch (e) {
      print(e.toString());

    }
  }

  Future<void> acceptFriendRequest(String userId) async {
    try {
      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('frndreq')
          .doc(userId)
          .delete();

      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('friends')
          .doc(userId)
          .set({});
      
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('friends')
          .doc(currentUser!.uid)
          .set({});
    } catch (e) {
      print(e.toString());
    }
  }
}
