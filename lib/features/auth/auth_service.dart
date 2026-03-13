import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:math';

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
      await sendVerificationCode(user.uid, email);
    }
    return user;
  }

  /// EMAIL SIGN-IN
  Future<User?> signInEmail(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = cred.user;
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
      "isVerified": false,
      "verificationCode": null,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  /// CREATE PROFILE IF GOOGLE USER DOESN'T EXIST
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
        "isVerified": true, // auto-verified for Google
        "verificationCode": null,
        "createdAt": FieldValue.serverTimestamp(),
      });
    }
  }

  /// SEND VERIFICATION CODE
  Future<void> sendVerificationCode(String uid, String email) async {
    final code = Random().nextInt(900000) + 100000; // 6-digit
    await _firestore.collection("users").doc(uid).update({
      "verificationCode": code,
    });

    // TODO: send code to email using cloud function / backend
    print("Verification code for $email: $code");
  }

  /// VERIFY CODE
  Future<bool> verifyCode(String uid, String codeInput) async {
    final doc = await _firestore.collection("users").doc(uid).get();
    final data = doc.data();
    if (data == null) return false;

    final code = data["verificationCode"].toString();
    if (code == codeInput) {
      await _firestore.collection("users").doc(uid).update({
        "isVerified": true,
        "verificationCode": null,
      });
      return true;
    }
    return false;
  }

  /// CHECK IF VERIFIED
  Future<bool> isVerified(String uid) async {
    final doc = await _firestore.collection("users").doc(uid).get();
    return doc.data()?["isVerified"] ?? false;
  }

  /// LOGOUT
  Future<void> signOut() async {
    await _auth.signOut();
    await _google.signOut();
  }

  bool get isLoggedIn => _auth.currentUser != null;
  User? get currentUser => _auth.currentUser;
}
