import 'package:flutter/material.dart';
import 'package:helloworld/screens/register_screen.dart';
import 'package:helloworld/screens/booking_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _username, _password;
  bool _isLoading = false;

  Future<void> _loginUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await http.post(
          Uri.parse('http://10.0.2.2:8000/login/'),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "username": _username ?? '',
            "password": _password ?? '',
          }),
        );

           if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Successfully logged in!'),
            backgroundColor: Colors.green,
          ));
          // Navigate to the ReservationScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CarSlotBookingPage()),
          );
        } else if (response.statusCode == 400) {
          final responseData = jsonDecode(response.body);
          final errorMessage =
              responseData['error'] ?? 'Login failed! please wait until approved by administrator.';
          _showPendingApprovalDialog(errorMessage); // Show the popup on failure
        } else {
          _showPendingApprovalDialog('Login failed!please wait until approved by administrator.');
        }
      } catch (error) {
        _showPendingApprovalDialog('An error occurred. please wait until approved by administrator..');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }


  void _showPendingApprovalDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Expanded(child: Text('Pending Approval')),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text(message),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Screen'),
        backgroundColor: const Color.fromARGB(255, 126, 184, 232),
        centerTitle: true,
        leading: Padding(
          padding:
              const EdgeInsets.all(8.0), // Optional: Adjust padding if needed
          child: Image.asset(
              'assets/images/logo.png'), // Displays the custom image
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment
                        .center, // Center the content vertically
                    children: [
                      // Display the custom image
                      Image.asset(
                        'assets/images/carlogin.png',
                        width: 200, // Set the width of the image
                        height: 200, // Set the height of the image
                        fit: BoxFit
                            .contain, // Ensure the image fits well within its bounds
                      ),
                      // Remove SizedBox if you don't want any space between image and text
                      // If necessary, you can set it to a very small value or remove it entirely
                      // SizedBox(height: 0), // Optional: Adjust spacing if needed
                      // Add the welcome text below the image
                      Text(
                        'Welcome back to ASHWA Car Parking',
                        style: TextStyle(
                          fontSize: 18, // Set the font size
                          fontWeight: FontWeight.bold, // Set the font weight
                          color: Colors.blueAccent, // Set the text color
                        ),
                        textAlign: TextAlign.center, // Center the text
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                _buildTextField(
                    _username, 'Username', (value) => _username = value),
                SizedBox(height: 20),
                _buildPasswordField(
                    _password, 'Password', (value) => _password = value),
                SizedBox(height: 30),
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Container(
                        width: 200, // Set a specific width for the button
                        child: ElevatedButton(
                          onPressed: _loginUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(vertical: 15.0),
                          ),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  18, // Increase the font size of the button text
                            ),
                          ),
                        ),
                      ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Haven't registered yet? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterScreen()),
                        );
                      },
                      child: Text(
                        "Register",
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
        ),
      ),
    );
  }

  Widget _buildTextField(
      String? value, String labelText, Function(String?) onSave) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: 300, // Set a specific width for the text field
        child: TextFormField(
          decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.grey[200],
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          ),
          validator: (value) {
            if (value?.isEmpty ?? false) {
              return 'Please enter your $labelText';
            }
            return null;
          },
          onSaved: onSave,
        ),
      ),
    );
  }

  Widget _buildPasswordField(
      String? value, String labelText, Function(String?) onSave) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: 300, // Set a specific width for the text field
        child: TextFormField(
          obscureText: true,
          decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.grey[200],
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          ),
          validator: (value) {
            if (value?.isEmpty ?? false) {
              return 'Please enter your $labelText';
            }
            return null;
          },
          onSaved: onSave,
        ),
      ),
    );
  }
}
