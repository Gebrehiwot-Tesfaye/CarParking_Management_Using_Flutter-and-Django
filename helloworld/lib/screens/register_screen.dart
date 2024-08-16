import 'package:flutter/material.dart';
import 'package:helloworld/screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Import for jsonEncode

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _firstName, _lastName, _username, _phoneNumber, _email, _password;
  bool _isLoading = false;

  Future<void> _registerUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await http.post(
          Uri.parse('http://10.0.2.2:8000/user-register/'),
          headers: {
            "Content-Type": "application/json", // Set Content-Type to JSON
          },
          body: jsonEncode({
            "username": _username ?? '',
            "email": _email ?? '',
            "phone_number": _phoneNumber ?? '',
            "first_name": _firstName ?? '',
            "last_name": _lastName ?? '',
            "password": _password ?? '',
          }),
        );

        setState(() {
          _isLoading = false;
        });

        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Successfully registered!'),
            backgroundColor: Colors.green,
          ));
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        } else if (response.statusCode == 400) {
          final responseData = jsonDecode(response.body);
          final errorMessage =
              responseData['error'] ?? 'Registration failed! Please try again.';
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Registration failed! Please try again.'),
            backgroundColor: Colors.red,
          ));
        }
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('An error occurred. Please try again.'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

// Displayed on the screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/images/logo.png', // Replace with your actual logo path
              width: 50, // Adjust width as needed
              height: 50, // Adjust height as needed
            ),
            Text('ASHWA Car Parking'),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 126, 184, 232),
        centerTitle: true,
        leading: Container(), // Hide the default leading icon
        actions: [
          IconButton(
            icon: Icon(Icons.menu), // Menu icon
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Open the navigation drawer
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/wallpeper.jpeg', // Background image path
              fit:
                  BoxFit.cover, // Ensure the image covers the entire background
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20), // Margin below the AppBar
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildTextField(_firstName, 'First Name',
                            (value) => _firstName = value),
                        _buildTextField(_lastName, 'Last Name',
                            (value) => _lastName = value),
                        _buildTextField(_username, 'Username',
                            (value) => _username = value),
                        _buildTextField(
                            _email, 'Email', (value) => _email = value),
                        _buildTextField(_phoneNumber, 'Phone Number',
                            (value) => _phoneNumber = value),
                        _buildPasswordField(_password, 'Password',
                            (value) => _password = value),
                        SizedBox(height: 30),
                        _isLoading
                            ? Center(
                                child:
                                    CircularProgressIndicator()) // Show loading spinner when submitting
                            : Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width:
                                      200, // Set a specific width for the button
                                  child: ElevatedButton(
                                    onPressed: _registerUser,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15.0),
                                    ),
                                    child: Text(
                                      'Register',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already have an account? "),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                );
                              },
                              child: Text(
                                "Login",
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
        ],
      ),
    );
  }

  Widget _buildTextField(
      String? value, String labelText, Function(String?) onSave) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 8.0), // Adjust vertical padding for smaller height
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
            contentPadding: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 12.0), // Adjust padding inside the text field
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
      padding: const EdgeInsets.symmetric(
          vertical: 8.0), // Adjust vertical padding for smaller height
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
            contentPadding: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 12.0), // Adjust padding inside the text field
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
