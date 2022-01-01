import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../services_locator.dart';
import '../ui/login/login.dart';
import 'navigation.dart';

// TODO: error handling
class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // 認証フローのトリガー
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  /// auth change user stream
  Stream<User?> get user => _firebaseAuth.userChanges();

  /// user's uid
  Map<String, String?> get userProfile => {
        "uid": _firebaseAuth.currentUser?.uid,
        "displayName": _firebaseAuth.currentUser?.displayName,
        "photoURL": _firebaseAuth.currentUser?.photoURL,
      };

  /// sign in to Firebase Authentication Service with Google
  Future<User?> signInWithGoogle() async {
    print("===== signInWithGoogle =====");
    GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    // TODO: error handling when google signin failed
    GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);
    return userCredential.user;
  }

  /// ユーザーをサインアウト / ログイン画面遷移
  Future signOut() async {
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();
    servicesLocator<NavigationService>()
        .pushNamedAndRemoveUntil(routeName: LoginView.routeName);
  }
}
