import 'package:cloud_functions/cloud_functions.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

const _apiKey = "AIzaSyCuwodkyZKCKdhQiUGPTmXoL4ACpM5to1E";

class AuthRepository {
  AuthRepository();

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<UserCredential> sendOTP(PhoneAuthCredential credential) {
    return auth.signInWithCredential(credential);
  }

  Future<void> logout() {
    return auth.signOut();
  }

  Future<String> getUserToken(String uid) async {
    final callable = FirebaseFunctions.instance.httpsCallable('generateCustomToken');
    final results = await callable(<String, dynamic>{
      'uid': uid,
    });
    return results.data["customToken"];
  }

  Future<bool> loginWithCustomToken(String token) async {
    final Dio dio = Dio();
    return dio.post(
      "https://identitytoolkit.googleapis.com/v1/accounts:signInWithCustomToken?key=$_apiKey",
      data: {
        "token": token,
        "returnSecureToken": true,
      },
    ).then((value) {
      print(value.data);
      return true;
    }).catchError((error) {});
  }
}
