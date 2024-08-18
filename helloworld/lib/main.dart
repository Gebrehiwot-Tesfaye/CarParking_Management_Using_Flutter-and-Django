import 'package:flutter/material.dart';
import 'package:helloworld/screens/register_screen.dart';
import 'package:helloworld/screens/login_screen.dart';
import 'package:helloworld/screens/car_registration_screen.dart';
import 'package:helloworld/screens/reservation_screen.dart';
import 'package:helloworld/screens/splace_screen.dart';
import 'package:helloworld/providers/user_auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserAuth()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Car slot Booking',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplaceScreen(),
      routes: {
        '/register': (context) => RegisterScreen(),
        '/login': (context) => LoginScreen(),
        '/car-registration': (context) => CarRegistrationScreen(),
        '/reservation': (context) => ReservationScreen(),
      },
    );
  }
}
