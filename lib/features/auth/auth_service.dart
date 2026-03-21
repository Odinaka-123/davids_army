import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../core/services/backend_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _google = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// SIGN UP EMAIL
  Future<User?> signUpEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = cred.user;

    if (user != null) {
      await _createUserProfile(
        user: user,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      );

      // 🔥 SEND EMAIL VIA BACKEND
      await BackendService.sendVerificationEmail(email);
    }

    return user;
  }

  /// EMAIL SIGN-IN (WITH VERIFICATION CHECK)
  Future<User?> signInEmail(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = cred.user;

    if (user != null) {
      // 🔐 CHECK BACKEND VERIFICATION
      final verified = await BackendService.isEmailVerified(email);

      if (!verified) {
        await _auth.signOut();
        throw Exception("Email not verified");
      }
    }

    return user;
  }

  /// GOOGLE SIGN-IN
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
      await _createUserProfileIfNotExists(user);
    }

    return user;
  }

  /// CREATE PROFILE
  Future<void> _createUserProfile({
    required User user,
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    final doc = _firestore.collection("users").doc(user.uid);

    await doc.set({
      "firstName": firstName,
      "lastName": lastName,
      "email": user.email ?? "",
      "phone": phone,
      "photo": user.photoURL ?? "",
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  /// GOOGLE PROFILE (ONLY IF NEW)
  Future<void> _createUserProfileIfNotExists(User user) async {
    final doc = _firestore.collection("users").doc(user.uid);
    final snap = await doc.get();

    if (!snap.exists) {
      await doc.set({
        "firstName": user.displayName?.split(" ").first ?? "",
        "lastName": user.displayName?.split(" ").last ?? "",
        "email": user.email ?? "",
        "photo": user.photoURL ?? "",
        "phone": "",
        "createdAt": FieldValue.serverTimestamp(),
      });
    }
  }

  /// LOGOUT
  Future<void> signOut() async {
    await _auth.signOut();
    await _google.signOut();
  }

  bool get isLoggedIn => _auth.currentUser != null;
  User? get currentUser => _auth.currentUser;
}
