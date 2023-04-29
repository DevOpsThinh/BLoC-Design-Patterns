///------------------------------------------------------------------
/// Topic: Flutter - Dart
/// Author: Nguyen Truong Thinh
/// Created At: 29/ 4/ 2023
///------------------------------------------------------------------

/// Class's document:
///  Authentication service abstract class
abstract class AuthenticationApi {
  getFirebaseAuth();
  Future<String> currentUserUid();
  Future<void> signOut();
  Future<String> signInWithEmailAndPassword({ String email, String password });
  Future<String> createUserWithEmailAndPassword({ String email, String password });
  Future<void> sendEmailVerification();
  Future<bool> isEmailVerified();
}