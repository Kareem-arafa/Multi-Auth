import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_auth/feature/home_screen.dart';
import 'package:multi_auth/feature/pin_code_screen.dart';
import 'package:multi_auth/repository/auth_repository.dart';
import 'package:multi_auth/utils/services.dart';
import 'package:multi_auth/utils/strings_extensions.dart';
import 'package:multi_auth/widget/custom_text_field_widget.dart';
import 'package:multi_auth/widget/toast_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  TextEditingController phoneController = TextEditingController();

  bool isLoading = false;

  bool? isBiometricEnabled;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    SharedPreferences.getInstance().then((pref) {
      isBiometricEnabled = pref.getBool("enable_biometric") ?? false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "SIGN IN",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                TextFieldWidget(
                  controller: phoneController,
                  hint: "Phone",
                  preIcon: const Icon(
                    Icons.phone,
                    color: Colors.black,
                  ),
                  inputType: TextInputType.phone,
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                  onPressed: () {
                    if (phoneController.text.isPhone) {
                      setState(() {
                        isLoading = true;
                      });
                      verifyPhoneNumber("+2${phoneController.text}");
                    } else {
                      showToast("Please enter correct egypt phone number");
                    }
                  },
                  child: const Center(
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (isBiometricEnabled ?? false)
                  InkWell(
                    onTap: () async {
                      final SharedPreferences pref = await SharedPreferences.getInstance();
                      final authorized = await authenticateWithBiometrics();
                      if (authorized) {
                        final String? token = pref.getString("token");
                        print(token);
                        if (token != null) {
                          setState(() {
                            isLoading = true;
                          });
                          AuthRepository().loginWithCustomToken(token).then((value) {
                            setState(() {
                              isLoading = false;
                            });
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const HomeScreen()),
                              (route) => false,
                            );
                          }).catchError((error) {
                            setState(() {
                              isLoading = false;
                            });
                          });
                        }
                      }
                    },
                    child: const Text(
                      "Login using biometric",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          isLoading
              ? Container(
                  height: MediaQuery.of(context).size.height,
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
        showToast(e.message ?? "An error occurred");
      },
      codeSent: (String verificationId, int? resendToken) async {
        setState(() {
          isLoading = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PinCodeFields(
              verificationId: verificationId,
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      timeout: const Duration(seconds: 60),
    );
  }
}
