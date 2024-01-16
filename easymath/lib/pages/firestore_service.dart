import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // get collection of users
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  // CREATE: add a new user
  Future<void> addUser(String email,String password,int score) {
    return users.add({
      'email': email,
      'password': password,
      'score': score,
      'timestamp': Timestamp.now(),
    });
  }

  // READ: get users from database
  Stream<QuerySnapshot> getUsersStream() {
    final usersStream = users.orderBy('score', descending: true).snapshots();
    return usersStream;
  }

  // UPDATE: update users given a doc id
  Future<void> updateUser(String docID, int newScore) {
    return users.doc(docID).update({
      'score': newScore++,
    });
  }

  // DELETE: delete user given a doc id
Future<void> deleteUser(String docID) {
    return users.doc(docID).delete();
}
}