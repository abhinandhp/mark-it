import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireDb {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails(
      String uid) async {
    return await _firebase.collection('users').doc(uid).get();
  }

  Future<void> addsub(Map<String, dynamic> data) async {
    try {
      await _firebase
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('subjects')
          .add(data);
    } catch (e) {
      print(e.toString());
      
    }
  }

  Future<void> updatesub(String docId, Map<String, dynamic> data) async {
    try {
      await _firebase
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('subjects')
          .doc(docId)
          .update(data);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletesub(String docId) async {
    try {
      await _firebase
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('subjects')
          .doc(docId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getsubs(String userId) {
    return _firebase
        .collection('users')
        .doc(userId)
        .collection('subjects')
        .snapshots();
    /*.map(
      (event) {
        return event.docs.map(
          (e) {
            return e.data();
          },
        ).toList();
      },
    );*/
  }

  Future<void> updateDoc(
      String collectionName, docID, Map<String, dynamic> data) async {
    try {
      await _firebase
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection(collectionName)
          .doc(docID)
          .update(data);
    } catch (e) {
      print(e.toString());
    }
  }
}
