import 'package:flutter/material.dart';
import 'package:helloworld/screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'user_auth.dart'; // Import your UserAuth class

class AboutScreen extends StatefulWidget {
  final int userId; // Add this line

  AboutScreen({required this.userId}); // Update constructor to accept userId

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  bool _isLoading = true;
  bool _hasError = false;
  Map<String, dynamic>? _userProfile;
  List<Map<String, dynamic>> _userCars = [];
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
    fetchUserCars();
  }

  Future<void> fetchUserProfile() async {
    try {
      final userId = widget.userId; // Use widget.userId
      final response = await http
          .get(Uri.parse('http://10.0.2.2:8000/user-register/$userId/'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> userJson = json.decode(response.body);
        setState(() {
          _userProfile = userJson;
          _usernameController.text = userJson['username'];
          _emailController.text = userJson['email'];
          _phoneNumberController.text = userJson['phone_number'];
          _firstNameController.text = userJson['first_name'];
          _lastNameController.text = userJson['last_name'];

          // Set profile image
          final profileImageUrl = userJson['profile_image'];
          if (profileImageUrl != null) {
            _profileImage = null; // Reset profile image for now
          }
          _isLoading = false;
        });
      } else {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
        print('Failed to load user profile');
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
      print('Error fetching user profile: $e');
    }
  }

  Future<void> fetchUserCars() async {
    try {
      final userId = widget.userId; // Use widget.userId
      final response =
          await http.get(Uri.parse('http://10.0.2.2:8000/users/$userId/cars/'));
      if (response.statusCode == 200) {
        final List<dynamic> carsJson = json.decode(response.body);
        setState(() {
          _userCars = List<Map<String, dynamic>>.from(carsJson);
        });
      } else {
        print('Failed to load user cars');
      }
    } catch (e) {
      print('Error fetching user cars: $e');
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveChanges() async {
    try {
      final userId = widget.userId; // Use widget.userId
      final uri = Uri.parse('http://10.0.2.2:8000/user-register/$userId/');
      final request = http.MultipartRequest('PUT', uri);

      if (_profileImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'profile_image', _profileImage!.path));
      }
      request.fields['username'] = _usernameController.text;
      request.fields['email'] = _emailController.text;
      request.fields['phone_number'] = _phoneNumberController.text;
      request.fields['first_name'] = _firstNameController.text;
      request.fields['last_name'] = _lastNameController.text;

      final response = await request.send();
      final responseString = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Changes saved successfully'),
              backgroundColor: Colors.green),
        );
      } else {
        print('Failed to save changes: ${response.statusCode}');
        print('Response: $responseString');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to save changes'),
              backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      print('Error saving user profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving changes')),
      );
    }
  }

  void _showAddCarDialog() {
    TextEditingController modelController = TextEditingController();
    TextEditingController vinController = TextEditingController();
    TextEditingController userIdController =
        TextEditingController(text: widget.userId.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Your Car'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: modelController,
                decoration: InputDecoration(
                  labelText: 'Model',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: vinController,
                decoration: InputDecoration(
                  labelText: 'VIN',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              // Adding User ID field to the dialog
              TextFormField(
                controller: userIdController,
                decoration: InputDecoration(
                  labelText: 'User ID',
                  border: OutlineInputBorder(),
                ),
                readOnly: true, // Makes the field read-only
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _postCar(modelController.text, vinController.text);
                await fetchUserCars(); // Refresh the car list after posting
                Navigator.pop(context);
              },
              child: Text('Add Car'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _postCar(String model, String vin) async {
    try {
      final userId = widget.userId; // Use widget.userId
      final uri = Uri.parse('http://10.0.2.2:8000/users/$userId/cars/');
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json', // Set content type to JSON
        },
        body: json.encode({
          'user_id': userId,
          'model': model,
          'vin': vin,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Car added successfully')),
        );
      } else {
        print('Failed to add car: ${response.statusCode}');
        print('Response: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add car')),
        );
      }
    } catch (e) {
      print('Error adding car: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding car')),
      );
    }
  }
  
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('access_token');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Successfully logged out'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(), // Navigate to LoginScreen
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('User Profile'),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_hasError) {
      return Scaffold(
        appBar: AppBar(
          title: Text('User Profile'),
        ),
        body: Center(child: Text('Error loading user profile')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
         actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await logout(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : _userProfile?['profile_image'] != null
                        ? NetworkImage(_userProfile!['profile_image'])
                        : AssetImage('assets/default_profile.png')
                            as ImageProvider,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text('Save Changes'),
            ),
            SizedBox(height: 20),
            Text('Your Cars:'),
            Container(
              height: 200, // Adjust height as needed
              child: ListView.builder(
                itemCount: _userCars.length,
                itemBuilder: (context, index) {
                  final car = _userCars[index];
                  return ListTile(
                    title: Text(car['model']),
                    subtitle: Text('VIN: ${car['vin']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: _showAddCarDialog,
              child: Icon(Icons.add),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 90, // Adjust to position the text next to the button
            child: Container(
              padding: EdgeInsets.all(8.0),
              color: Colors.white,
              child: Text(
                'Add your car',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
