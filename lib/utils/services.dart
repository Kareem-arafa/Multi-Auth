import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

Future<bool> authenticateWithBiometrics() async {
  bool authenticated = false;
  final LocalAuthentication auth = LocalAuthentication();
  try {
    authenticated = await auth.authenticate(
      localizedReason: 'Scan your fingerprint (or face or whatever) to authenticate',
      options: const AuthenticationOptions(
        stickyAuth: true,
        biometricOnly: true,
      ),
    );
    return authenticated;
  } on PlatformException catch (e) {
    return authenticated;
  }
}
