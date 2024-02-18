import 'package:flutter/material.dart';

class forgot_password extends StatefulWidget {
  const forgot_password({super.key});

  @override
  State<forgot_password> createState() => _forgot_passwordState();
}

class _forgot_passwordState extends State<forgot_password> {
  TextEditingController _EmailPhonenumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('forgotpassword'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 157,
            ),
            const Text(
              'Forgot Password',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            const Text(
                '     enter your Email,or Mobile Number\n associated with your account to change\n                    your password.'),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _EmailPhonenumber,
              decoration: InputDecoration(
                labelText: 'Email or Phone Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(
                        255, 25, 25, 25), // Set your desired border color here
                    width: 1.5, // Set your desired border width here
                  ),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your email or phone number';
                }
                if (!_validateEmail(value) && !_validatePhoneNumber(value)) {
                  return 'Please enter a valid email or phone number';
                }
                return null;
              },
            ),
            SizedBox(
              height: 27,
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(
                    210, 243, 170, 33), // Set your desired button color here
                shadowColor: Colors.black,
                minimumSize: const Size(400, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: const BorderSide(
                    color: Colors.black, // Set your desired border color here
                    width: 2.0, // Set your desired border width here
                  ),
                ),
              ),
              child: const Text(
                "Next",
                style: TextStyle(
                  color: Color.fromARGB(255, 34, 34, 34),
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
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
