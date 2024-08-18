import 'package:flutter/material.dart';
import 'package:helloworld/screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'about_screen.dart';

class ReservationScreen extends StatefulWidget {
  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedStartTime, _selectedEndTime;
  List<Map<String, dynamic>> carList = [];
  String? _selectedSlot;
  Map<String, dynamic>? _selectedCar;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt('user_id');
    });
    if (_userId != null) {
      fetchCars();
    }
  }

  Future<void> fetchCars() async {
    if (_userId == null) return;

    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:8000/users/$_userId/cars/'));
      if (response.statusCode == 200) {
        final List<dynamic> carsJson = json.decode(response.body);

        setState(() {
          carList = carsJson.map((carData) {
            return {
              'id': carData['id'],
              'model': carData['model'],
              'vin': carData['vin'],
              'info': '${carData['model']} - ${carData['vin']}',
            };
          }).toList();
        });
      } else {
        print('Failed to load cars');
      }
    } catch (e) {
      print('Error fetching cars: $e');
    }
  }

  Future<void> makeReservation() async {
    if (_userId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('User not logged in')));
      return;
    }

    if (_selectedCar == null ||
        _selectedSlot == null ||
        _selectedStartTime == null ||
        _selectedEndTime == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please complete all fields')));
      return;
    }

    final reservationData = {
      'start_time': _selectedStartTime!.toUtc().toIso8601String(),
      'end_time': _selectedEndTime!.toUtc().toIso8601String(),
      'car_slot': _selectedSlot!,
      'car_id': _selectedCar!['id'],
    };

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/reservations/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(reservationData),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reservation successful'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BookingPage(
              slotName: _selectedSlot ?? 'Unknown Slot',
              carModel: _selectedCar?['model'] ?? 'Unknown Model',
              carVin: _selectedCar?['vin'] ?? 'Unknown VIN',
              startTime: _selectedStartTime!,
              endTime: _selectedEndTime!,
            ),
          ),
        );
      } else {
        print('Failed to make reservation');
        print(response.body);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to make reservation. A reservation with this car slot already exists.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error making reservation: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error making reservation')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation Screen'),
        backgroundColor: Colors.blue.shade600,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              if (_userId != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AboutScreen(userId: _userId!)),
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<Map<String, dynamic>>(
                  decoration: InputDecoration(
                    labelText: 'Select Car',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                  ),
                  hint: Text('Select a car or please add it at your profile'),
                  value: _selectedCar,
                  items: carList.map((Map<String, dynamic> car) {
                    return DropdownMenuItem<Map<String, dynamic>>(
                      value: car,
                      child: Text(car['info']),
                    );
                  }).toList(),
                  onChanged: (Map<String, dynamic>? newValue) {
                    setState(() {
                      _selectedCar = newValue;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select a car' : null,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Enter Slot',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 12.0),
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedSlot = newValue;
                      });
                    },
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter a slot'
                        : null,
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Start Time',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? picked = await showDateTimePicker(context);
                    if (picked != null)
                      setState(() {
                        _selectedStartTime = picked;
                      });
                  },
                  controller: TextEditingController(
                    text: _selectedStartTime != null
                        ? _selectedStartTime!.toLocal().toString()
                        : '',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'End Time',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 12.0),
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? picked = await showDateTimePicker(context);
                      if (picked != null)
                        setState(() {
                          _selectedEndTime = picked;
                        });
                    },
                    controller: TextEditingController(
                      text: _selectedEndTime != null
                          ? _selectedEndTime!.toLocal().toString()
                          : '',
                    ),
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: makeReservation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        textStyle: TextStyle(color: Colors.white),
                      ),
                      child: Text(
                        'Reserve Slot',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<DateTime?> showDateTimePicker(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    TimeOfDay initialTime = TimeOfDay.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate == null) return null;
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (pickedTime == null) return null;
    return DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}

class BookingPage extends StatelessWidget {
  final String slotName;
  final String carModel;
  final String carVin;
  final DateTime startTime;
  final DateTime endTime;

  BookingPage({
    required this.slotName,
    required this.carModel,
    required this.carVin,
    required this.startTime,
    required this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Confirmation'),
        backgroundColor: Colors.blue.shade600,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Slot Name: $slotName'),
            SizedBox(height: 8.0),
            Text('Car Model: $carModel'),
            SizedBox(height: 8.0),
            Text('Car VIN: $carVin'),
            SizedBox(height: 8.0),
            Text('Start Time: ${startTime.toLocal()}'),
            SizedBox(height: 8.0),
            Text('End Time: ${endTime.toLocal()}'),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}
