import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EventBasedapp/screens/events_list.dart';
import 'package:EventBasedapp/signUp.dart';

import 'package:intl_phone_field/intl_phone_field.dart';

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

  @override
  void initState() {
    checkLoginStatus();

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

    setState(() {
      screenState = 1;
    });
  }

  Future<void> verifyOTP() async {
    await Future.delayed(const Duration(seconds: 2));

    await setLoginStatus(true);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const EventScreenList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
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
                  height: 20,
                ),
                IntlPhoneField(
                  controller: phoneController,
                  showCountryFlag: false,
                  initialValue: countryDial,
                  onCountryChanged: (Country) {
                    setState(() {
                      countryDial = "+${Country.dialCode}";
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Phone number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 25, 25,
                            25), // Set your desired border color here
                        width: 1.5, // Set your desired border width here
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => Biometric()),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 241, 195, 46),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    side: const BorderSide(
                      color: Colors.black,
                      width: 1.5,
                    ),
                    minimumSize: const Size(double.infinity, 60.0),
                  ),
                  child: const Text(
                    "Sign In",
                    style: TextStyle(
                      color: Color.fromARGB(255, 26, 26, 26),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 107,
                    ),
                    const Text("Already have account?"),
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
                        "Go hear",
                        style: TextStyle(
                          color: Color.fromARGB(255, 243, 103, 33),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
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
}

class Biometric extends StatefulWidget {
  @override
  State<Biometric> createState() => _BiometricState();
}

class _BiometricState extends State<Biometric> {
  late final LocalAuthentication auth;
  bool isOTPLoading = false;

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biometric Authentication'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _Fingerauthenticate,
          style: ElevatedButton.styleFrom(
            primary: const Color.fromARGB(255, 241, 195, 46),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            side: const BorderSide(
              color: Colors.black,
              width: 1.5,
            ),
            minimumSize: const Size(double.infinity, 60.0),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.fingerprint),
              SizedBox(width: 8), // Adjust spacing as needed
              Text('Authenticate with Fingerprint&face'),
            ],
          ),
        ),
      ),
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

  Future<void> setLoginStatus(bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }
}
