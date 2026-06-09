// import 'dart:convert';
//
// import '../../model/user/user_entity.dart';
// import '../../routes/app_pages.dart';
// import 'local_storage.dart';
// import '../local/encryption.dart';
//
// /// Helper class for local stored User
// class UserProvider {
//   static UserEntity? _userEntity;
//   static String? _authToken;
//   static late bool _isLoggedIn;
//
//   /// Get currently logged in user
//   static UserEntity? get currentUser => _userEntity;
//
//   /// Get auth token of the logged in user
//   static String? get authToken => _authToken;
//
//   /// If the user is logged in or not
//   static bool get isLoggedIn => _isLoggedIn;
//
//   ///Set [currentUser] and [authToken]
//   static Future<void> onLogin(UserEntity user, String userAuthToken) async {
//     _isLoggedIn = true;
//     _userEntity = user;
//     _authToken = userAuthToken;
//     await LocalStore.userData
//         .set(AppEncryption.encrypt(plainText: jsonEncode(user.toJson())));
//     await LocalStore.authToken.set(userAuthToken);
//   }
//
//   /// Update [currentUser]
//   static Future<void> updateUser(UserEntity user) async {
//     _userEntity = user;
//     await LocalStore.userData
//         .set(AppEncryption.encrypt(plainText: jsonEncode(user.toJson())));
//   }
//
//   ///Load [currentUser] and [authToken]
//   static Future<void> loadUser() async {
//     String? encryptedUserData = await LocalStore.userData.get();
//     if (encryptedUserData != null) {
//       encryptedUserData = AppEncryption.decrypt(cipherText: encryptedUserData);
//       _isLoggedIn = true;
//       _userEntity = UserEntity.fromJson(jsonDecode(encryptedUserData));
//       _authToken = await LocalStore.authToken.get();
//     } else {
//       _isLoggedIn = false;
//     }
//   }
//
//   ///Remove [currentUser] and [authToken] from local storage
//   static Future<void> onLogout() async {
//     _isLoggedIn = false;
//     _userEntity = null;
//     _authToken = null;
//     await LocalStore.userData.remove();
//     await LocalStore.authToken.remove();
//   }
//
//   /// Get the initial route depending on the user login state
//   static String get initialRoute =>
//       isLoggedIn ? AppRoutes.home : AppRoutes.login;
// }
