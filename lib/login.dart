import 'package:flutter/material.dart';
import 'package:get_contacts/screens/events_list.dart';
import 'package:get_contacts/signUp.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      // User is already logged in, navigate to the home page
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const EventScreenList(),
        ),
      );
    }
  }

  Future<void> setLoginStatus(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  Future<void> verifyPhone(String number) async {
    // Mock verification process (replace with your desired logic)
    await Future.delayed(Duration(seconds: 2));
    showSnackBarText("OTP sent!");
    setState(() {
      screenState = 1;
    });
  }

  Future<void> verifyOTP() async {
    // Mock OTP verification process (replace with your desired logic)
    await Future.delayed(Duration(seconds: 2));

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
            children: [
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
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
                          if (phoneController.text.isEmpty) {
                            showSnackBarText("Phone number is empty!");
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
                            // Set OTP loading to true before making the request
                            setState(() {
                              isOTPLoading = true;
                            });

                            verifyOTP().whenComplete(() {
                              // Set OTP loading to false when the request is complete
                              setState(() {
                                isOTPLoading = false;
                              });
                            });
                          } else {
                            showSnackBarText("Enter OTP correctly");
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(210, 243, 170,
                            33), // Set your desired button color here
                        shadowColor: Colors.black,
                        minimumSize: Size(400, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(
                            color: Colors
                                .black, // Set your desired border color here
                            width: 2.0, // Set your desired border width here
                          ),
                        ),
                      ),
                      child: screenState == 0
                          ? isRegistrationLoading
                              ? CircularProgressIndicator()
                              : const Text(
                                  "Sign in >",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 26, 26, 26),
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                          : isOTPLoading
                              ? CircularProgressIndicator()
                              : const Text(
                                  "Verify",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 34, 34, 34),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                    ),
                    if (screenState == 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 147,
                          ),
                          Text("You are new?"),
                          SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpPage(),
                                ),
                              );
                            },
                            child: Text(
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
        SizedBox(height: 16),
        Text(
          "Login",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 27,
          ),
        ),
        SizedBox(
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
              borderSide: BorderSide(
                color: const Color.fromARGB(
                    255, 25, 25, 25), // Set your desired border color here
                width: 1.5, // Set your desired border width here
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(15), // Increase the border radius
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: const Color.fromARGB(
                    255, 21, 21, 21), // Set your desired border color here
                width: 3.0, // Set your desired border width here
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          ),
          obscureText: true,
        )
      ],
    );
  }

  Widget stateOTP() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Verification",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 25,
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
                text: "A verification code has been sent to",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                ),
              ),
              TextSpan(
                text: "\n$countryDial${phoneController.text}",
                style: const TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
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
            activeColor: Colors.black26,
            selectedColor: Colors.blue,
            inactiveColor: Colors.black,
            shape: PinCodeFieldShape.box, // Set the box shape to underline
          ),
        ),
        SizedBox(height: 20),
        RichText(
          text: TextSpan(children: [
            TextSpan(
              text: "Didn't receive the code?",
              style: TextStyle(
                color: Colors.black38,
                fontSize: 12,
              ),
            ),
            WidgetSpan(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    screenState = 0;
                  });
                },
                child: Text(
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
      ],
    );
  }
}
