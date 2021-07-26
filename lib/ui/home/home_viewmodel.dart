import 'package:stacked/stacked.dart';
import '../../service/firestore_service.dart';
import '../../services_locator.dart';

///
class HomeViewModel extends BaseViewModel {
  final _firestore = servicesLocator<FirestoreService>();

  String dropDownValueOrigin;
  void setDropDownValueOrigin(String value) async {
    dropDownValueOrigin = value;
    // reset
    dropDownItemsDestinations =
        await _firestore.getDestinationBusstopIds(dropDownValueOrigin);
    dropDownValueDestination = dropDownItemsDestinations.first;
    notifyListeners();
  }

  String dropDownValueDestination;
  void setDropDownValueDestination(String value) {
    dropDownValueDestination = value;
    notifyListeners();
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

    setBusy(false);
    notifyListeners();
  }
}
