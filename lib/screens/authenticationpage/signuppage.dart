import 'package:EventBasedapp/screens/authenticationpage/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart'; // Import for international phone number input
import 'package:pin_code_fields/pin_code_fields.dart'; // Import for OTP input

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

  String otpPin = ""; // Variable to store OTP
  String countryDial = "+1"; // Initial country dial code
  int screenState = 0; // 0 for registration, 1 for OTP
  Color primaryColor = const Color(0xff0074E4); // Primary color for styling
  bool isRegistrationLoading =
      false; // Flag to indicate registration loading state
  bool isOTPLoading = false; // Flag to indicate OTP verification loading state
  String? firstNameError; // Error message for first name input validation
  String? middleNameError; // Error message for middle name input validation
  String? lastNameError; // Error message for last name input validation
  String? emailIdError; // Error message for email input validation
  String? phoneNumbererror; // Error message for phone number input validation

  // Function to verify phone number
  Future<void> verifyPhone(String number) async {
    // Mock verification process (replace with your desired logic)
    await Future.delayed(Duration(seconds: 2));
    // Show Snackbar message indicating OTP sent
    showSnackBarText("OTP sent!");
    // Update screen state to OTP input
    setState(() {
      screenState = 1;
    });
  }

  // Function to validate text fields
  bool validateTextField(TextEditingController controller, String? errorText,
      {int minLength = 1}) {
    if (controller.text.trim().isEmpty || controller.text.length < minLength) {
      setState(() {
        errorText = "This field cannot be empty or too short";
      });
      return false;
    }
    setState(() {
      errorText = null;
    });
    return true;
  }

  // Function to validate email format
  bool validateEmailFormat(String email) {
    String emailPattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
    RegExp regex = RegExp(emailPattern);
    if (!regex.hasMatch(email)) {
      setState(() {
        emailIdError = "Enter a valid email address";
      });
      return false;
    }
    setState(() {
      emailIdError = null;
    });
    return true;
  }

  // Function to verify OTP
  Future<void> verifyOTP() async {
    // Mock OTP verification process (replace with your desired logic)
    await Future.delayed(Duration(seconds: 2));
    // Navigate to login page after OTP verification
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  // Function to show Snackbar message
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
                    // Render registration or OTP input based on screen state
                    screenState == 0 ? stateRegister() : stateOTP(),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Perform different actions based on screen state
                        if (screenState == 0) {
                          // Validate input fields for registration
                          setState(() {
                            // Validate input fields
                            firstNameError = firstName.text.isEmpty
                                ? 'Please enter first name'
                                : null;
                            lastNameError = lastName.text.isEmpty
                                ? 'Please enter last name'
                                : null;
                            middleNameError = MiddleName.text.isEmpty
                                ? 'Please enter middle name'
                                : null;
                            phoneNumbererror = phoneController.text.isEmpty
                                ? 'Please enter a valid number'
                                : null;
                            emailIdError = emailID.text.isEmpty
                                ? 'Please enter email address'
                                : null;
                            // Additional check for valid email format
                            if (emailIdError == null &&
                                !validateEmailFormat(emailID.text)) {
                              emailIdError =
                                  'Please enter a valid email address';
                            }
                          });
                          // Proceed with registration if all fields are filled
                          if (firstName.text.isEmpty ||
                              lastName.text.isEmpty ||
                              MiddleName.text.isEmpty ||
                              phoneController.text.isEmpty ||
                              emailID.text.isEmpty ||
                              emailIdError != null) {
                            // Handle the case where any of the fields is empty or email is invalid
                            // You may show a message or perform some action
                          } else {
                            // Set registration loading to true before making the request
                            setState(() {
                              isRegistrationLoading = true;
                            });
                            // Initiate phone number verification process
                            verifyPhone("${countryDial}${phoneController.text}")
                                .whenComplete(() {
                              // Set registration loading to false when the request is complete
                              setState(() {
                                isRegistrationLoading = false;
                              });
                            });
                          }
                        } else {
                          // OTP verification state
                          if (otpPin.length >= 6) {
                            // Set OTP loading to true before making the request
                            setState(() {
                              isOTPLoading = true;
                            });
                            // Verify OTP
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
                      // Show login link if in registration state
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

  // Widget for registration input fields
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
        // Input field for first name
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
            errorText: firstNameError,
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
        // Input field for middle name
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
            errorText: middleNameError,
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
        // Input field for last name
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
            errorText: lastNameError,
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
        // Input field for email
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
            errorText: emailIdError,
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
        // Input field for phone number
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
            errorText: phoneNumbererror,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 20), // Adjust the vertical padding
          ),
        ),
      ],
    );
  }

  // Widget for OTP input
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
        // Display phone number for OTP verification
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
        // OTP input field
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
        // Option to resend OTP
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
                  // Go back to registration state to allow resend
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
