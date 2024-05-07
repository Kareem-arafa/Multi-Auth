import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_auth/repository/auth_repository.dart';
import 'package:multi_auth/feature/signin_view.dart';
import 'package:multi_auth/utils/services.dart';
import 'package:multi_auth/widget/toast_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () async {
                        final authorized = await authenticateWithBiometrics();
                        if (authorized) {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          final String? uid = FirebaseAuth.instance.currentUser?.uid;
                          if (uid != null) {
                            setState(() {
                              isLoading = true;
                            });
                            AuthRepository().getUserToken(uid).then((token) {
                              setState(() {
                                isLoading = false;
                              });
                              prefs.setString("token", token);
                              prefs.setBool("enable_biometric", true);
                              showToast("Biometric Enabled Successfully");
                            });
                          }
                        }
                      },
                      child: const Text("Enable Biometric"),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Center(
                  child: SizedBox(
                    width: 200,
                    child: OutlinedButton(
                      onPressed: () {
                        AuthRepository().logout().then((value) async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.clear();
                          Navigator.pushAndRemoveUntil(
                              context, MaterialPageRoute(builder: (context) => const SignInView()), (route) => false);
                        });
                      },
                      child: const Text("Logout"),
                    ),
                  ),
                ),
              ],
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
      ),
    );
  }
}
