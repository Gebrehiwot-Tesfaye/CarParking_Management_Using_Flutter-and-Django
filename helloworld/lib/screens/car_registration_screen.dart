import 'package:flutter/material.dart';
import 'package:helloworld/models/car_model.dart';

class CarRegistrationScreen extends StatefulWidget {
  @override
  _CarRegistrationScreenState createState() => _CarRegistrationScreenState();
}

class _CarRegistrationScreenState extends State<CarRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _carModel, _vehicleIdentificationNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Registration Screen'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
                       TextFormField(
              decoration: InputDecoration(labelText: 'Car Model'),
              validator: (value) {
                if (value?.isEmpty ?? false) {
                  return 'Please enter your car model';
                }
                return null;
              },
              onSaved: (value) => _carModel = value,
            ),
            TextFormField(
              decoration:
                  InputDecoration(labelText: 'Vehicle Identification Number'),
              validator: (value) {
                if (value?.isEmpty ?? false) {
                  return 'Please enter your vehicle identification number';
                }
                return null;
              },
              onSaved: (value) => _vehicleIdentificationNumber = value,
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _formKey.currentState?.save();
                  // Do something with the form data
                  CarModel carModel = CarModel(
                    carModel: _carModel!,
                    vehicleIdentificationNumber: _vehicleIdentificationNumber!,
                  );
                  print(carModel.carModel);
                  print(carModel.vehicleIdentificationNumber);
                }
              },
              child: Text('Register Car'),
            ),
          ],
        ),
      ),
    );
  }
}
