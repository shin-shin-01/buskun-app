import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/timetable.dart';

class FirestoreService {
  CollectionReference buses = FirebaseFirestore.instance.collection('buses');

  // ["九大学研都市駅", "産学連携交流センター", ... ]
  Future<List<String>> getOriginBusstopIds() async {
    return await buses.get().then((QuerySnapshot querySnapshot) =>
        querySnapshot.docs.map((doc) => doc.id).toList());
  }

  // ["九大学研都市駅", "産学連携交流センター", ... ]
  Future<List<String>> getDestinationBusstopIds(String docid) async {
    // TODO fix imple: doc(docid).collections() が存在しないため Firebase で data に保存
    final snapshot = await buses.doc(docid).get();
    return snapshot.data()["busstops"].cast<String>() as List<String>;
  }

  // [ Timetabel, Timetable, ... ]
  Future<List<Timetable>> getTargetTimetables(
      String departuteDocid, String destinationDocid) async {
    return await buses
        .doc(departuteDocid)
        .collection(destinationDocid)
        .get()
        .then((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((doc) => Timetable.fromFirestore(doc))
            .toList());
  }
}
