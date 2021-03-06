import 'package:stacked/stacked.dart';
import 'package:trainkun/service/authentication.dart';
import 'package:trainkun/service/navigation.dart';
import 'package:trainkun/ui/home/home_view.dart';
import '../../services_locator.dart';

///
class LoginViewModel extends BaseViewModel {
  final _navigation = servicesLocator<NavigationService>();
  final _auth = servicesLocator<AuthService>();

  /// submitSignInForm
  void signInWithGoogle() async {
    setBusy(true);
    await _auth.signInWithGoogle();

    _navigation.pushNamed(routeName: HomeView.routeName);
    setBusy(false);
  }
}
