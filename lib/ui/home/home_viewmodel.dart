import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import 'package:trainkun/ui/theme/app_theme.dart';

import '../../services_locator.dart';
import '../../service/authentication.dart';
import '../../service/firestore_service.dart';
import '../../model/timetable.dart';
import '../../model/bus_pair.dart';

///
class HomeViewModel extends BaseViewModel {
  final _firestore = servicesLocator<FirestoreService>();
  final _auth = servicesLocator<AuthService>();

  // 時刻表の色付け
  Map<String, Color> lineColor = {
    "九州大学線〔周船寺経由〕": appTheme.appColors.firstLine,
    "九州大学線〔学園通経由〕": appTheme.appColors.secondLine,
    "九州大学線〔横浜西経由〕": appTheme.appColors.thirdLine,
  };

  // バスを乗車降車を逆にするか？
  late bool isReverse = false;

  String origin = "九大学研都市駅";
  String destination = "九大ビッグオレンジ";
  late String timeString;
  late bool isHoliday;
  late Map<String, List<Timetable>> timetables = {"平日": [], "土・日": []};
  // ユーザーごとのバス停
  late List<BusPair> favoriteBusPairs;
  List<String> favoriteBusPairIds = [];
  // すべてのバス停
  List<BusPair> busPairs = [];

  void initialize() async {
    setBusy(true);

    await setTime();
    await setFavoriteBusPairs();
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
  Future<void> setFavoriteBusPairs() async {
    favoriteBusPairs =
        await _firestore.getUserBusPairs(_auth.userProfile["uid"]!);
    favoriteBusPairs.forEach((busPair) => favoriteBusPairIds.add(busPair.id));

    // 初期値を登録
    if (favoriteBusPairs.length != 0) {
      origin = favoriteBusPairs.first.first;
      destination = favoriteBusPairs.first.second;
    }
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
  // お気に入りのバス停を登録
  // =============================
  // すべてのバス停データを取得
  Future<void> setBusPairs() async {
    if (busPairs.length == 0) {
      busPairs = await _firestore.getBusPairs();
    }
  }

  bool isFavoriteBusPair(BusPair busPair) {
    return favoriteBusPairIds.contains(busPair.id);
  }

  Future<void> setBusPairFavorite(BusPair busPair) async {
    await _firestore.setUserBusPair(_auth.userProfile["uid"]!, busPair);
    favoriteBusPairs.add(busPair);
    favoriteBusPairIds.add(busPair.id);
    notifyListeners();
  }

  Future<void> removeBusPairFavorite(BusPair busPair) async {
    await _firestore.removeUserBusPair(_auth.userProfile["uid"]!, busPair);
    favoriteBusPairs.remove(busPair);
    favoriteBusPairIds.remove(busPair.id);
    notifyListeners();
  }

  // =============================
  // 時刻を現在時刻に変更 / 時刻表を更新
  // =============================
  Future<void> onRefresh() async {
    await setTime();
    await setTimetables();
    notifyListeners();
  }
}
