import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:multi_auth/feature/home_screen.dart';
import 'package:multi_auth/repository/auth_repository.dart';
import 'package:multi_auth/widget/toast_utils.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinCodeFields extends StatefulWidget {
  final String verificationId;

  const PinCodeFields({super.key, required this.verificationId});

  @override
  State<PinCodeFields> createState() => _PinCodeFieldsState();
}

class _PinCodeFieldsState extends State<PinCodeFields> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PinCodeTextField(
                  autoFocus: true,
                  appContext: context,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  pastedTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    selectedColor: const Color(0xff979797).withOpacity(0.3),
                    selectedFillColor: Colors.transparent,
                    shape: PinCodeFieldShape.underline,
                    errorBorderColor: Theme.of(context).colorScheme.error,
                    borderRadius: BorderRadius.circular(30),
                    borderWidth: 2,
                    activeFillColor: Colors.transparent,
                    inactiveFillColor: Colors.transparent,
                    inactiveColor: const Color(0xff979797).withOpacity(0.3),
                    activeColor: Theme.of(context).primaryColor,
                    disabledColor: Colors.transparent,
                  ),
                  cursorColor: Theme.of(context).primaryColor,
                  animationDuration: const Duration(milliseconds: 100),
                  textStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                  keyboardType: TextInputType.number,
                  beforeTextPaste: (text) {
                    return true;
                  },
                  onChanged: (value) {
                    if (kDebugMode) {
                      print(value);
                    }
                  },
                  onCompleted: (text) async {
                    PhoneAuthCredential credential = PhoneAuthProvider.credential(
                      verificationId: widget.verificationId,
                      smsCode: text,
                    );
                    setState(() {
                      isLoading = true;
                    });
                    AuthRepository().sendOTP(credential).then((userCredential) {
                      setState(() {
                        isLoading = false;
                      });
                      print(userCredential.user?.uid.toString());
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                        (_) => false,
                      );
                    }).catchError((error) {
                      setState(() {
                        isLoading = false;
                      });
                      showToast(error.toString());
                    });
                  },
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
}
