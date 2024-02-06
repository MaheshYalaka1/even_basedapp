import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EventBasedapp/screens/events_list.dart';
import 'package:EventBasedapp/signUp.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
//import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

// Riverpod provider to manage login status
final loginStatusProvider = FutureProvider<bool>((ref) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') ?? false;
});

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  TextEditingController phoneController = TextEditingController();
  String otpPin = "";
  String countryDial = "+91";
  int screenState = 0; // 0 for registration, 1 for OTP

  bool isRegistrationLoading = false;
  bool isOTPLoading = false;
  late final LocalAuthentication auth;

  @override
  void initState() {
    checkLoginStatus();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then((bool isSupported) {
      setState(() {});
    });
    super.initState();
  }

  Future<void> checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const EventScreenList(),
        ),
      );
    }
  }

  Future<void> setLoginStatus(bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  Future<void> verifyPhone(String number) async {
    // Mock verification process (replace with your desired logic)
    await Future.delayed(const Duration(seconds: 2));
    showSnackBarText("OTP sent!");
    setState(() {
      screenState = 1;
    });
  }

  Future<void> verifyOTP() async {
    // Mock OTP verification process (replace with your desired logic)
    await Future.delayed(const Duration(seconds: 2));

    // Set the login status to true
    await setLoginStatus(true);

    // Navigate to the next screen on successful verification
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const EventScreenList(),
      ),
    );
  }

  void showSnackBarText(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    screenState == 0 ? stateRegister() : stateOTP(),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        if (screenState == 0) {
                          if (phoneController.text.isEmpty == null) {
                            return;
                          } else {
                            // Set registration loading to true before making the request
                            setState(() {
                              isRegistrationLoading = true;
                            });

                            verifyPhone("${countryDial}${phoneController.text}")
                                .whenComplete(() {
                              // Set registration loading to false when the request is complete
                              setState(() {
                                isRegistrationLoading = false;
                              });
                            });
                          }
                        } else {
                          if (otpPin.length >= 6) {
                            setState(() {
                              isOTPLoading = true;
                            });

                            _Fingerauthenticate().whenComplete(() {
                              // Set OTP loading to false when the request is complete
                            });
                          } else {}
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromARGB(210, 243, 170,
                            33), // Set your desired button color here
                        shadowColor: Colors.black,
                        minimumSize: const Size(400, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(
                            color: Colors
                                .black, // Set your desired border color here
                            width: 2.0, // Set your desired border width here
                          ),
                        ),
                      ),
                      child: screenState == 0
                          ? isRegistrationLoading
                              ? const CircularProgressIndicator()
                              : const Text(
                                  "Sign in >",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 26, 26, 26),
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                          : isOTPLoading
                              ? const CircularProgressIndicator()
                              : GestureDetector(
                                  onTap: () {
                                    // Add your authentication logic here
                                    _Fingerauthenticate();
                                  },
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text('Authenticate: biometrics only'),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Icon(Icons.fingerprint),
                                    ],
                                  ),
                                ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget stateRegister() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 16),
        const Text(
          "Login",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 27,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        IntlPhoneField(
          controller: phoneController,
          showCountryFlag: false,
          initialValue: countryDial,
          onCountryChanged: (Country) {
            setState(() {
              countryDial = "+" + Country.dialCode;
            });
          },
          decoration: InputDecoration(
            labelText: 'Phone number',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: Color.fromARGB(
                    255, 25, 25, 25), // Set your desired border color here
                width: 1.5, // Set your desired border width here
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 147,
            ),
            const Text("You are new?"),
            const SizedBox(width: 5),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignUpPage(),
                  ),
                );
              },
              child: const Text(
                "Create new",
                style: TextStyle(
                  color: Color.fromARGB(240, 250, 107, 71),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget stateOTP() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 17,
        ),
      ],
    );
  }

  Future<void> _Fingerauthenticate() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'For event-based app',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (authenticated) {
        // If authentication is successful, navigate to the new page
        await Future.delayed(const Duration(seconds: 0));
        isOTPLoading = false;

        // Set the login status to true
        await setLoginStatus(true);
        {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const EventScreenList(),
            ),
          );
        }
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }
}