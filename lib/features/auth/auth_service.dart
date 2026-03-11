import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _google = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// SIGN IN WITH GOOGLE
  Future<User?> signInWithGoogle() async {
    final googleUser = await _google.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCred = await _auth.signInWithCredential(credential);
    final user = userCred.user;

    if (user != null) {
      await _syncUserToFirestore(user);
    }

    return user;
  }

  /// SIGN IN WITH EMAIL
  Future<User?> signInEmail(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = cred.user;

    if (user != null) {
      await _syncUserToFirestore(user);
    }

    return user;
  }

  /// SIGN UP WITH EMAIL
  Future<User?> signUpEmail(String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = cred.user;

    if (user != null) {
      await _syncUserToFirestore(user);
    }

    return user;
  }

  /// CREATE OR UPDATE USER PROFILE IN FIRESTORE
  Future<void> _syncUserToFirestore(User user) async {
    final userDoc = _firestore.collection("users").doc(user.uid);

    final snapshot = await userDoc.get();

    if (!snapshot.exists) {
      final nameParts = (user.displayName ?? "").split(" ");

      final firstName = nameParts.isNotEmpty ? nameParts.first : "";
      final lastName = nameParts.length > 1 ? nameParts.last : "";

      await userDoc.set({
        "firstName": firstName,
        "lastName": lastName,
        "email": user.email ?? "",
        "photo": user.photoURL ?? "",
        "phone": "",
        "country": "",
        "city": "",
        "state": "",
        "createdAt": FieldValue.serverTimestamp(),
      });
    }
  }

  /// LOGOUT
  Future<void> signOut() async {
    await _auth.signOut();
    await _google.signOut();
  }

  /// CHECK IF USER IS LOGGED IN
  bool get isLoggedIn => _auth.currentUser != null;

  User? get currentUser => _auth.currentUser;
}
