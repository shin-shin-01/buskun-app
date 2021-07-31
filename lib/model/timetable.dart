import 'package:cloud_firestore/cloud_firestore.dart';

class Timetable {
  final String destination;

  final String via;

  final String departureAt;

  final String arriveAt;

  Timetable(
      {required this.destination,
      required this.via,
      required this.departureAt,
      required this.arriveAt});
}
