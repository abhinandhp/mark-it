import 'package:cloud_firestore/cloud_firestore.dart';


class FireDb {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  Future<void> addsub(Map<String, dynamic> data) async {
    try {
      await _firebase.collection('subjects').add(data);
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getsubs() {
    return _firebase.collection('subjects').snapshots();
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
    await _firebase.collection(collectionName).doc(docID).update(data);
          
        } catch (e) {
          print(e.toString());
        }
  }
}
