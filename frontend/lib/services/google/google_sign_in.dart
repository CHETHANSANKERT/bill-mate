// import 'package:google_sign_in/google_sign_in.dart';
//
// final googleSignIn = GoogleSignIn(
//   scopes: ['https://www.googleapis.com/auth/drive.file'],
// );
//
// Future<GoogleSignInAccount?> signInWithGoogle() async {
//   return await googleSignIn.signIn();
// }
//
// Future<GoogleSignInAccount?> signInUserToDrive() async {
//   try {
//     return await googleSignIn.signInSilently() ?? await googleSignIn.signIn();
//   } catch (e) {
//     print("Google Sign-In failed: $e");
//     return null;
//   }
// }
