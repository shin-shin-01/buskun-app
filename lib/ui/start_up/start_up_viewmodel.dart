import 'package:stacked/stacked.dart';

import '../../services_locator.dart';
import '../../service/authentication.dart';
import '../../service/navigation.dart';
import '../../ui/home/home_view.dart';
import '../../ui/login/login.dart';

///
class StartUpViewModel extends BaseViewModel {
  final _navigation = servicesLocator<NavigationService>();
  final _auth = servicesLocator<AuthService>();

  Future handleStartUpLogic() async {
    if (_auth.uid != null) {
      _navigation.pushNamed(routeName: HomeView.routeName);
    } else {
      _navigation.pushNamed(routeName: LoginView.routeName);
    }
  }
}
