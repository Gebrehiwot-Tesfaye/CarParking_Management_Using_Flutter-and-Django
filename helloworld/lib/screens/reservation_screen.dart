import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'about_screen.dart';

class ReservationScreen extends StatefulWidget {
  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedStartTime, _selectedEndTime;
  List<Map<String, dynamic>> carList = []; // List to hold car info and IDs
  String? _selectedSlot;
  Map<String, dynamic>? _selectedCar;

  @override
  void initState() {
    super.initState();
    fetchCars();
  }

  Future<void> fetchCars() async {
    try {
      final response = await http.get(Uri.parse(
          'http://10.0.2.2:8000/users/2/cars/')); // Replace with the correct user_id
      if (response.statusCode == 200) {
        final List<dynamic> carsJson = json.decode(response.body);

        setState(() {
          carList = carsJson.map((carData) {
            return {
              'id': carData['id'], // Assuming 'id' is the car's ID
              'info':
                  '${carData['model']} - ${carData['vin']}', // Concatenating model and vin
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
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Reservation successful')));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingPage(slotName: _selectedSlot),
          ),
        );
      } else {
        print('Failed to make reservation');
        print(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to make reservation car_slot":["reservation with this car slot already exists.')));
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AboutScreen(userId: 2)),
                );
              }),
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
                // Car Selection Dropdown
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: DropdownButtonFormField<Map<String, dynamic>>(
                    decoration: InputDecoration(
                      labelText: 'Select Car',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 12.0),
                    ),
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
                ),
                // Custom Slot Input
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
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
                // Start Time Picker
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Start Time',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 12.0),
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
                ),
                // End Time Picker
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
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
                // Reserve Button
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
                        style: TextStyle(
                          color: Colors.white,
                        ),
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
    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: initialTime,
      );
      if (pickedTime != null) {
        return DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      }
    }
    return null;
  }
}

class BookingPage extends StatelessWidget {
  final String? slotName;

  BookingPage({this.slotName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Page'),
        backgroundColor: Colors.blue.shade600,
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Slot $slotName reserved successfully!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
