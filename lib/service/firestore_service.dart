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
    return await buses
        .doc(departuteDocid)
        .collection(destinationDocid)
        .where('departureAt', isGreaterThanOrEqualTo: timeString)
        .limit(15)
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
