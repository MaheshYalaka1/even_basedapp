import 'package:flutter/material.dart';
import 'package:get_contacts/TabBar.dart';
import 'package:get_contacts/signUp.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sms_autofill/sms_autofill.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> with CodeAutoFill {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController phoneController = TextEditingController();
  String verificationId = "";
  String otpPin = "";
  String countryDial = "+91";
  int screenState = 0; // 0 for registration, 1 for OTP
  Color primaryColor = const Color(0xff0074E4);
  bool isRegistrationLoading = false;
  bool isOTPLoading = false;

  @override
  void initState() {
    super.initState();
    // Start listening for SMS codes
    listenForCode();
    // Auto-fill OTP if available
    SmsAutoFill().listenForCode;
  }

  @override
  void codeUpdated() {
    setState(() {
      otpPin = code ?? '';
    });
  }

  Future<void> verifyPhone(String number) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: number,
      timeout: const Duration(seconds: 30),
      verificationCompleted: (PhoneAuthCredential credential) async {
        showSnackBarText("Authentication complete");
      },
      verificationFailed: (e) {
        showSnackBarText('Error: ${e.code}');
      },
      codeSent: (String verificationId, int? resendToken) {
        showSnackBarText("OTP sent!");
        this.verificationId = verificationId;
        setState(() {
          screenState = 1;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        showSnackBarText("TimeOut!");
      },
    );
  }

  Future<void> verifyOTP() async {
    try {
      await _auth.signInWithCredential(
        PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: otpPin,
        ),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => TabScreen(),
        ),
      );
    } catch (e) {
      showSnackBarText("Error: Incorrect OTP. Please try again.");
    }
  }

  void showSnackBarText(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
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
                    const SizedBox(height: 20),
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
                        primary: primaryColor,
                      ),
                      child: screenState == 0
                          ? isRegistrationLoading
                              ? CircularProgressIndicator()
                              : const Text(
                                  "Continue",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                          : isOTPLoading
                              ? CircularProgressIndicator()
                              : const Text(
                                  "Continue",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                    ),
                    if (screenState == 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account?"),
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
                              "Sign up",
                              style: TextStyle(
                                color: Colors.blue,
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
            fontSize: 16,
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
            labelText: 'phone number',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'password',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          obscureText: true,
        )
      ],
    );
  }

  Widget stateOTP() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      SmsAutoFill().code.listen((autoFilledOTP) {
        if (autoFilledOTP != null && autoFilledOTP.isNotEmpty) {
          // Automatically fill the OTP
          setState(() {
            otpPin = autoFilledOTP;
          });

          // Proceed with OTP verification
          verifyOTP();
        }
      });
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Verification",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
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
            activeColor: primaryColor,
            selectedColor: primaryColor,
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
                    color: primaryColor,
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
