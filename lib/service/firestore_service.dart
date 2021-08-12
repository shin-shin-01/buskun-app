import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/timetable.dart';
import '../model/bus_pair.dart';

class FirestoreService {
  CollectionReference buses = FirebaseFirestore.instance.collection('buses');
  CollectionReference bus_pairs =
      FirebaseFirestore.instance.collection('bus_pairs');

  // [ Timetabel, Timetable, ... ]
  Future<List<Timetable>> getTargetTimetables(
      String departuteDocid, String destinationDocid, String timeString) async {
    // 2時間後までのデータを取得
    String hour = timeString.substring(0, 2);
    String nextHour = (int.parse(hour) + 2).toString().padLeft(2, "0");
    String nextTimeString = nextHour + timeString.substring(2);

    return await buses
        .doc(departuteDocid)
        .collection(destinationDocid)
        .where('departureAt', isGreaterThanOrEqualTo: timeString)
        .where('departureAt', isLessThan: nextTimeString)
        .get()
        .then((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((doc) => Timetable.fromFirestore(doc))
            .toList());
  }

  // バス停組み合わせ一覧を取得
  Future<List<BusPair>> getBusPairs() async {
    return await bus_pairs.get().then((QuerySnapshot querySnapshot) =>
        querySnapshot.docs.map((doc) => BusPair.fromFirestore(doc)).toList());
  }
}
