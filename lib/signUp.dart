import 'package:flutter/material.dart';
import 'package:get_contacts/login.dart';
import 'package:get_contacts/screens/events_list.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController MiddleName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController emailID = TextEditingController();

  String otpPin = "";
  String countryDial = "+1";
  int screenState = 0; // 0 for registration, 1 for OTP
  Color primaryColor = const Color(0xff0074E4);
  bool isRegistrationLoading = false;
  bool isOTPLoading = false;

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
                                  "Sign UP",
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
                            height: 107,
                          ),
                          Text("Already have account?"),
                          SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            },
                            child: Text(
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
            ],
          ),
        ),
      ),
    );
  }

  Widget stateRegister() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sign up',
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.left,
        ),
        const Text(
          'You have a chance to create a new account if you really want to.',
          style: TextStyle(
            fontSize: 18.0,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 16,
        ),
        const Text(
          "First Name",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        TextField(
          controller: firstName,
          decoration: InputDecoration(
            hintText: 'Enter your first name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: Color.fromARGB(
                    255, 19, 19, 19), // Set your desired border color here
                width: 10.0, // Set your desired border width here
              ),
            ),
            // focusedBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(15),
            //   borderSide: BorderSide(
            //     color: Colors.blue, // Set your desired border color here
            //     width: 2.0, // Set your desired border width here
            //   ),
            // ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          ),
        ),
        SizedBox(
          height: 12,
        ),

        const Text(
          "Middle Name",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        TextField(
          controller: MiddleName,
          decoration: InputDecoration(
            hintText: 'Enter your Middle name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: const Color.fromARGB(
                    255, 25, 25, 25), // Set your desired border color here
                width: 1.5, // Set your desired border width here
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 20), // Adjust the vertical padding
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          "Last Name",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        TextField(
          controller: lastName,
          decoration: InputDecoration(
            hintText: 'Enter your family Name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: const Color.fromARGB(
                    255, 25, 25, 25), // Set your desired border color here
                width: 1.5, // Set your desired border width here
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 20), // Adjust the vertical padding
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          "Email Id",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        TextField(
          controller: emailID,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'Email address',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: const Color.fromARGB(
                    255, 25, 25, 25), // Set your desired border color here
                width: 1.5, // Set your desired border width here
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 20), // Adjust the vertical padding
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "Phone Number",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        // Uncomment the following line to enable phone number input
        IntlPhoneField(
          controller: phoneController,
          showCountryFlag: false,
          showDropdownIcon: false,
          initialValue: countryDial,
          onCountryChanged: (Country) {
            setState(() {
              countryDial = "+" + Country.dialCode;
            });
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: const Color.fromARGB(
                    255, 25, 25, 25), // Set your desired border color here
                width: 1.5, // Set your desired border width here
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 20), // Adjust the vertical padding
          ),
        ),
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
              text: "haven't received code yet?",
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
      ],
    );
  }
}
