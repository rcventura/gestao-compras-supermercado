import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingListModel {
  final DateTime createdAt;
  final String listName;
  final String locationCreated;
  final String? marketName;
  final String? uuid;

  ShoppingListModel({
    required this.createdAt,
    required this.listName,
    required this.locationCreated,
    this.marketName,
    this.uuid,
  });

  factory ShoppingListModel.fromMap(Map<String, dynamic> map, String uuid) {
    return ShoppingListModel(
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      listName: map['listName'] as String,
      locationCreated: map['locationCreated'] as String,
      marketName: map['marketName'] as String?,
      uuid: uuid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'createdAt': Timestamp.fromDate(createdAt),
      'listName': listName,
      'locationCreated': locationCreated,
      'marketName': marketName,
      'uuid': uuid,
    };
  }
}
