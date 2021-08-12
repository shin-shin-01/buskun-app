import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import '../../service/firestore_service.dart';
import '../../services_locator.dart';
import '../../model/timetable.dart';
import '../../model/bus_pair.dart';

///
class HomeViewModel extends BaseViewModel {
  final _firestore = servicesLocator<FirestoreService>();

  late List<BusPair> busPairs;
  Future<void> setBusPairs() async {
    busPairs = await _firestore.getBusPairs();
    // 初期値を登録
    origin = busPairs.first.first;
    destination = busPairs.first.second;
  }

  late String origin;
  late String destination;
  late String timeString;

  late List<Timetable> timetables;

  void initialize() async {
    setBusy(true);

    setTimeString();
    await setBusPairs();
    await setTimetables();

    setBusy(false);
    notifyListeners();
  }

  // 現在時刻を設定
  setTimeString() {
    final now = DateTime.now();
    timeString = DateFormat('HH:mm').format(now);
  }

  Future<void> setTimetables() async {
    timetables =
        await _firestore.getTargetTimetables(origin, destination, timeString);
  }

  // バス停をお気に入りから選択
  Future<void> setBusPairFromFavorite(BusPair busPair) async {
    origin = busPair.first;
    destination = busPair.second;
    // 時刻表を登録
    await setTimetables();
    notifyListeners();
  }
}
