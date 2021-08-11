import 'package:stacked/stacked.dart';
import '../../service/firestore_service.dart';
import '../../services_locator.dart';
import '../../model/timetable.dart';
import '../../model/bus_pair.dart';

///
class HomeViewModel extends BaseViewModel {
  final _firestore = servicesLocator<FirestoreService>();

  late String dropDownValueOrigin;
  void setDropDownValueOrigin(String value) async {
    dropDownValueOrigin = value;
    // reset
    dropDownItemsDestinations =
        await _firestore.getDestinationBusstopIds(dropDownValueOrigin);
    dropDownValueDestination = dropDownItemsDestinations.first;
    await setTimetables();
    notifyListeners();
  }

  late String dropDownValueDestination;
  void setDropDownValueDestination(String value) async {
    dropDownValueDestination = value;
    await setTimetables();
    notifyListeners();
  }

  late List<Timetable> timetables;

  Future<void> setTimetables() async {
    timetables = await _firestore.getTargetTimetables(
        dropDownValueOrigin, dropDownValueDestination);
  }

  List<String> dropDownItemsOrigins = [];
  List<String> dropDownItemsDestinations = [];

  void initialize() async {
    setBusy(true);

    dropDownItemsOrigins = await _firestore.getOriginBusstopIds();
    dropDownValueOrigin = dropDownItemsOrigins.first;
    dropDownItemsDestinations =
        await _firestore.getDestinationBusstopIds(dropDownValueOrigin);
    dropDownValueDestination = dropDownItemsDestinations.first;
    await setTimetables();
    await setBusPairs();

    setBusy(false);
    notifyListeners();
  }

  // お気に入りバス停
  late List<BusPair> busPairs;
  Future<void> setBusPairs() async {
    busPairs = await _firestore.getFavoriteBusPairs("cPfrTqRdgleVhGoMcFA0");
  }
}
