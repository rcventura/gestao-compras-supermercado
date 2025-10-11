import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.createdAt,
  });

  factory UserModel.fromFirebaseUser({
    required dynamic firebaseUser,
    required String name,
  }) {
    return UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: name,
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      createdAt: map['createdAt'] ?? '',
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot docRef) {
    Map<String, dynamic> data = docRef.data() as Map<String, dynamic>;
    return UserModel.fromMap(data);
  }
}
