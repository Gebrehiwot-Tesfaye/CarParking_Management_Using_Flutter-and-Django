import 'package:flutter/material.dart';
import 'package:helloworld/Data.dart';
import 'package:helloworld/screens/register_screen.dart';
import 'package:lottie/lottie.dart';
import 'nav_drawer.dart'; // Import your navigation drawer

class SplaceScreen extends StatelessWidget {
  const SplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // Set the AppBar color to blue
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('ASHEWA Car Parking'),
            const SizedBox(width: 30),
            Image.asset(
              'assets/images/logo.png', // Replace with your actual logo path
              width: 50, // Adjust width as needed
              height: 50, // Adjust height as needed
            ),
          ],
        ),
        leading: null,
      ),
      drawer: NavDrawer(), // Attach the drawer to the Scaffold
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
              flex: 9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/animation/running_car.json',
                        width: 300,
                        height: 300,
                      ),
                    ],
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "CAR PARKING",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          "This is a Car parking app for Smart car parking station, Here you can find Available slots and book your parking slot from anywhere with your phone.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 78, 77, 77),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    collegeLogo,
                    width: 120,
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to the registration screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.arrow_forward,
                      size: 20,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
