import 'package:get_it/get_it.dart';
import './service/firestore_service.dart';
import './service/navigation.dart';

/// servicesLocator
GetIt servicesLocator = GetIt.instance;

Future<void> setupServiceLocator() async {
  servicesLocator.registerSingleton(FirestoreService());
  servicesLocator.registerSingleton(NavigationService());
}
