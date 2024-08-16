import 'package:flutter/material.dart';
import 'package:helloworld/screens/login_screen.dart'; // Adjust imports as needed
import 'package:helloworld/screens/booking_screen.dart';
import 'package:helloworld/screens/register_screen.dart';
import 'package:helloworld/screens/splace_screen.dart'; // Adjust imports as needed

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Row(
              children: [
                Image.asset(
                  'assets/images/logo.png', // Replace with your actual logo path
                  width: 50,
                  height: 50,
                ),
                SizedBox(width: 10),
                Text(
                  'ASHEWA Car Parking',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SplaceScreen()),
              );
            },
          ),
            ListTile(
            leading: Icon(Icons.person),
            title: Text('Register'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => RegisterScreen()),
              );
            },
          ),
           ListTile(
            leading: Icon(Icons.person),
            title: Text('Login'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.book),
            title: Text('Booking'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => CarSlotBookingPage()),
              );
            },
          ),
         
          // Add more ListTile items as needed
        ],
      ),
    );
  }
}
