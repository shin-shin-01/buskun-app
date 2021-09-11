import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

import '../../services_locator.dart';
import '../../service/authentication.dart';
import '../../service/firestore_service.dart';
import '../../service/navigation.dart';
import '../../model/timetable.dart';
import '../../model/bus_pair.dart';
import '../../ui/login/login.dart';

///
class HomeViewModel extends BaseViewModel {
  final _firestore = servicesLocator<FirestoreService>();
  final _auth = servicesLocator<AuthService>();
  final _navigation = servicesLocator<NavigationService>();

  // 時刻表の色付け
  Map<String, Color> lineColor = {
    "九州大学線〔周船寺経由〕": Color(0xFF50998F),
    "九州大学線〔学園通経由〕": Color(0xFFC67B82),
    "九州大学線〔横浜西経由〕": Color(0xFF5B5E7A),
  };

  // バスを乗車降車を逆にするか？
  late bool isReverse = false;

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

  // =============================
  // 現在時刻 / 平日・土日
  // =============================
  setTime() async {
    // api: http://s-proj.com/utils/holiday.html
    Uri uri = Uri.parse("http://s-proj.com/utils/checkHoliday.php?kind=h");
    final response = await http.get(uri);
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

  // =============================
  // バス停/時刻表を変数に保存
  // =============================
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

  // =============================
  // バス停を選択
  // =============================
  Future<void> setBusPairFromFavorite(BusPair busPair) async {
    origin = isReverse ? busPair.second : busPair.first;
    destination = isReverse ? busPair.first : busPair.second;
    // 時刻表を登録
    await setTimetables();
    notifyListeners();
  }

  // 出発/到着を変更
  Future<void> reverseBusPair() async {
    isReverse = !isReverse;
  }

  // =============================
  // 時刻を現在時刻に変更 / 時刻表を更新
  // =============================
  Future<void> onRefresh() async {
    await setTime();
    await setTimetables();
    notifyListeners();
  }

  // =============================
  // サインアウト
  // =============================
  Future<void> signOut() async {
    await _auth.signOut();
    _navigation.pushNamed(routeName: LoginView.routeName);
  }
}
