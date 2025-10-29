import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minhalistadecompras/features/Home/model/shopping_list_model.dart';

class HomeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'shopping_lists';

  // CRIAR NOVA LISTA
  Future<String> createShoppingList(ShoppingListModel shoppingList) async {
    try {
      DocumentReference docRef = await _firestore
          .collection(_collectionName)
          .add(shoppingList.toMap());
      return docRef.id;
    } catch (e) {
      print('Erro ao criar lista de compras: $e');
      return '';
    }
  }
}
