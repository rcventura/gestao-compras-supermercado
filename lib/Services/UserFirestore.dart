import 'package:cloud_firestore/cloud_firestore.dart';
import '../Features/Auth/model/user_model.dart';

class Userfirestore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get usersCollection => _firestore.collection('users');

  // CRIAR DOCUMENTO DO USUÁRIO
  Future<void> createUserDocument(UserModel user) async {
    try {
      await usersCollection.doc(user.uid).set(user.toMap());
    } catch (e) {
      throw 'Erro ao criar documentode usuário $e';
    }
  }

  //LER DOCUMENTO DO USUÁRIO
Future<UserModel?> getUserDocument(String uid) async {
  try {
    DocumentSnapshot docRef = await usersCollection.doc(uid).get();
    if(docRef.exists) {
      return UserModel.fromFirestore(docRef);
    }
    return null;
  } catch (e) {
    throw 'Erro ao buscar usuário: $e';
  }
}

}
