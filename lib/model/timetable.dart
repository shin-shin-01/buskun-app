import 'package:cloud_firestore/cloud_firestore.dart';

class Timetable {
  final bool isHoliday;
  final String line;

  final String departureAt;

  final String arriveAt;

  Timetable(
      {required this.isHoliday,
      required this.line,
      required this.departureAt,
      required this.arriveAt});

  factory Timetable.fromFirestore(QueryDocumentSnapshot firestoreDoc) {
    final data = firestoreDoc.data() as Map;
    return Timetable(
      isHoliday: data["holiday"] as bool,
      line: data['line'] as String,
      departureAt: data['departureAt'] as String,
      arriveAt: data['arriveAt'] as String,
    );
  }

  String toShareSentence(String departure, String arrive) {
    return """$line

    $departure
    $departureAt 発

    $arrive
    $arriveAt 着"""
        .splitMapJoin(
      RegExp(r'^', multiLine: true),
      onMatch: (_) => '\n',
      onNonMatch: (n) => n.trim(),
    );
  }
}
