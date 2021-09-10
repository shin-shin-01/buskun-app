import 'package:cloud_firestore/cloud_firestore.dart';

class BusPair {
  final String id;
  final String first;
  final String second;

  BusPair({
    required this.id,
    required this.first,
    required this.second,
  });

  factory BusPair.fromFirestore(QueryDocumentSnapshot firestoreDoc) {
    final data = firestoreDoc.data() as Map;
    return BusPair(
      id: firestoreDoc.id,
      first: data['first'] as String,
      second: data['second'] as String,
    );
  }
}
