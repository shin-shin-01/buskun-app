import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import '../../service/firestore_service.dart';
import '../../services_locator.dart';
import '../../model/timetable.dart';
import '../../model/bus_pair.dart';
import 'package:http/http.dart' as http;

///
class HomeViewModel extends BaseViewModel {
  final _firestore = servicesLocator<FirestoreService>();

  late String origin;
  late String destination;
  late String timeString;
  late bool isHoliday;
  late Map<String, List<Timetable>> timetables = {"平日": [], "土・日": []};
  late List<BusPair> busPairs;

  void initialize() async {
    setBusy(true);

    await setTime();
    await setBusPairs();
    await setTimetables();

    setBusy(false);
    notifyListeners();
  }

  // 現在時刻 / 平日・土日 を設定
  setTime() async {
    // api: http://s-proj.com/utils/holiday.html
    final response =
        await http.get("http://s-proj.com/utils/checkHoliday.php?kind=h");
    isHoliday = response.body == "holiday";

    final now = DateTime.now();
    timeString = DateFormat('HH:mm').format(now);
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (t != null) {
      // 時刻を hh:mm でフォーマット
      timeString = t.hour.toString().padLeft(2, "0") +
          ":" +
          t.minute.toString().padLeft(2, "0");
      // 時刻表を更新
      await setTimetables();
      notifyListeners();
    }
  }

  Future<void> setBusPairs() async {
    busPairs = await _firestore.getBusPairs();
    // 初期値を登録
    origin = busPairs.first.first;
    destination = busPairs.first.second;
  }

  Future<void> setTimetables() async {
    List<Timetable> allTimetables =
        await _firestore.getTargetTimetables(origin, destination, timeString);
    timetables["平日"] =
        allTimetables.where((timetable) => !timetable.isHoliday).toList();
    timetables["土・日"] =
        allTimetables.where((timetable) => timetable.isHoliday).toList();
  }

  // バス停を選択
  Future<void> setBusPairFromFavorite(BusPair busPair) async {
    origin = busPair.first;
    destination = busPair.second;
    // 時刻表を登録
    await setTimetables();
    notifyListeners();
  }

  // 出発/到着を変更
  Future<void> reverseBusPair() async {
    String tmp = origin;
    origin = destination;
    destination = tmp;

    // 時刻表を登録
    await setTimetables();
    notifyListeners();
  }
}
