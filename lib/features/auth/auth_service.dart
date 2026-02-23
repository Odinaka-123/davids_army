import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _google = GoogleSignIn();

  /// SIGN IN WITH GOOGLE
  Future<User?> signInWithGoogle() async {
    final googleUser = await _google.signIn();
    if (googleUser == null) return null; // cancelled

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCred = await _auth.signInWithCredential(credential);
    return userCred.user;
  }

  /// SIGN IN WITH EMAIL & PASSWORD
  Future<User?> signInEmail(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user;
  }

  /// SIGN UP WITH EMAIL & PASSWORD
  Future<User?> signUpEmail(String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user;
  }

  /// LOGOUT
  Future<void> signOut() async {
    await _auth.signOut();
    await _google.signOut();
  }

  /// CHECK IF USER IS LOGGED IN (persistent)
  bool get isLoggedIn => _auth.currentUser != null;

  /// GET CURRENT USER
  User? get currentUser => _auth.currentUser;
}
