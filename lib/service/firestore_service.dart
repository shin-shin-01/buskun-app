import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/timetable.dart';
import '../model/bus_pair.dart';

class FirestoreService {
  CollectionReference buses = FirebaseFirestore.instance.collection('buses');
  CollectionReference users = FirebaseFirestore.instance.collection('users');

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

  // ユーザーのお気に入りのバス停組み合わせ一覧を取得
  Future<List<BusPair>> getFavoriteBusPairs(String userId) async {
    return await users.doc(userId).collection("favorites").get().then(
        (QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((doc) => BusPair.fromFirestore(doc))
            .toList());
  }

  // お気に入りバス停を追加
  Future<void> postFavoriteBusPair(
      String userId, String origin, String destination) async {
    await users.doc(userId).collection("favorites").doc().set(
        {"origin": origin, "destination": destination},
        SetOptions(merge: true));
  }

  // お気に入りバス停を削除
  Future<void> deleteFavoriteBusPair(String userId, BusPair busPair) async {
    await users.doc(userId).collection("favorites").doc(busPair.id).delete();
  }
}
