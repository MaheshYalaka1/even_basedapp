import 'package:EventBasedapp/screens/authenticationpage/forgotpassword.dart';
import 'package:EventBasedapp/screens/authenticationpage/signuppage.dart';
import 'package:flutter/material.dart';
import 'package:EventBasedapp/screens/homepages/events_list.dart';

import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  final TextEditingController _emailOrPhoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
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
                  TextFormField(
                    controller: _emailOrPhoneController,
                    decoration: InputDecoration(
                      labelText: 'Email or Phone Number',
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
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email or phone number';
                      }
                      if (!_validateEmail(value) &&
                          !_validatePhoneNumber(value)) {
                        return 'Please enter a valid email or phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Do u want authenticate with',
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'biometric or otp',
                      ),
                      Switch(
                        value: _isSwitched,
                        onChanged: (value) {
                          setState(() {
                            _isSwitched = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (_isSwitched) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OtpScreen(
                                      phoneNumber: _emailOrPhoneController.text,
                                    )),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Biometric()),
                          );
                        }
                      }
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
                    height: 6,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => forgot_password()));
                    },
                    child: const Text('Forgot Password ?'),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Go here",
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
      ),
    );
  }

  bool _validateEmail(String value) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(value);
  }

  bool _validatePhoneNumber(String value) {
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    return phoneRegex.hasMatch(value);
  }
}

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  OtpScreen({required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreen(phoneNumber: phoneNumber);
}

class _OtpScreen extends State<OtpScreen> {
  final String phoneNumber;
  _OtpScreen({required this.phoneNumber});
  String otpPin = "";
  String countryDial = "+91";

  Color primaryColor = const Color(0xff0074E4);

  bool isOTPLoading = false;
  late final LocalAuthentication auth;
  String? otpError;

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
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in with otp'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginPage()));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 70,
                    ),
                    const Text(
                      "Verification",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(
                      height: 17,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: "A verification code has been sent \nto ",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                          ),
                          TextSpan(
                            text: phoneNumber,
                            style: const TextStyle(
                              color: Color.fromARGB(225, 28, 27, 27),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Uncomment the following line to enable OTP input
                    PinCodeTextField(
                      appContext: context,
                      length: 6,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          otpPin = value;
                        });
                      },
                      pinTheme: PinTheme(
                        activeColor: primaryColor,
                        selectedColor: primaryColor,
                        inactiveColor: Colors.black,
                        shape: PinCodeFieldShape.box,
                      ),
                    ),
                    const SizedBox(height: 20),
                    RichText(
                      text: TextSpan(children: [
                        const TextSpan(
                          text: "Haven't received code yet?  ",
                          style: TextStyle(
                            color: Colors.black38,
                            fontSize: 12,
                          ),
                        ),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()));
                            },
                            child: const Text(
                              'Resend',
                              style: TextStyle(
                                color: Color.fromARGB(255, 243, 103, 33),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ),
                    const SizedBox(
                      height: 19,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (otpPin.length != 6) {
                          setState(() {
                            otpError = 'Please enter a valid OTP';
                          });
                        } else {
                          setState(() {
                            otpError = null;
                            isOTPLoading = true;
                          });
                          verifyOTP();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(210, 243, 170,
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
                      child: const Text(
                        "Verify",
                        style: TextStyle(
                          color: Color.fromARGB(255, 34, 34, 34),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (otpError !=
                        null) // Display error message if otpError is not null
                      Text(
                        otpError!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    if (isOTPLoading) // Display circular progress indicator if isOTPLoading is true
                      const CircularProgressIndicator()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Biometric extends StatefulWidget {
  const Biometric({super.key});

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (conterx) => const LoginPage()));
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _Fingerauthenticate,
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
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.fingerprint),
                  SizedBox(width: 8), // Adjust spacing as needed
                  Text('Authenticate with Fingerprint&face'),
                ],
              ),
            ),
          ],
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
