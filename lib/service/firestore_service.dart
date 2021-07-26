import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  CollectionReference buses = FirebaseFirestore.instance.collection('buses');

  Future<List<String>> getOriginBusstopIds() async {
    return await buses.get().then((QuerySnapshot querySnapshot) =>
        querySnapshot.docs.map((doc) => doc.id).toList());
  }

  Future<List<String>> getDestinationBusstopIds(String docid) async {
    // TODO fix imple: doc(docid).collections() が存在しないため Firebase で data に保存
    final snapshot = await buses.doc(docid).get();
    return snapshot.data()["busstops"].cast<String>() as List<String>;
  }
}
