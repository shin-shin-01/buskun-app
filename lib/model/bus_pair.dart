import 'package:cloud_firestore/cloud_firestore.dart';

class BusPair {
  final String id;
  final String origin;
  final String destination;

  BusPair({
    required this.id,
    required this.origin,
    required this.destination,
  });

  factory BusPair.fromFirestore(QueryDocumentSnapshot firestoreDoc) {
    final data = firestoreDoc.data();
    return BusPair(
      id: firestoreDoc.id,
      origin: data['origin'] as String,
      destination: data['destination'] as String,
    );
  }
}
