import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
 // final HomeService _homeService = HomeService();

  final List<Map<String, dynamic>> shoppingLists = [
    {
      'title': 'Compras do Mêsss',
      'items': 15,
      'total': 450.00,
      'date': DateTime.now(),
      'icon': Icons.shopping_cart,
      'color': Color(0xFF2ECC71),
    },
    {
      'title': 'Feira da Semana',
      'items': 8,
      'total': 120.50,
      'date': DateTime.now().subtract(Duration(days: 2)),
      'icon': Icons.local_grocery_store,
      'color': Color(0xFF3498DB),
    },
    {
      'title': 'Produtos de Limpeza',
      'items': 6,
      'total': 85.90,
      'date': DateTime.now().subtract(Duration(days: 5)),
      'icon': Icons.cleaning_services,
      'color': Color(0xFF9B59B6),
    },
  ];


   // FAZER LOGOUT
  Future<bool> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
}