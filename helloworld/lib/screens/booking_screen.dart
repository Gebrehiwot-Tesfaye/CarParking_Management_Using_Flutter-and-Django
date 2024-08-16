import 'package:flutter/material.dart';
import 'package:another_dashed_container/another_dashed_container.dart';
import 'package:helloworld/screens/reservation_screen.dart'; // Import your ReservationScreen
import 'package:helloworld/screens/about_screen.dart'; // Import the AboutScreen

class CarSlotBookingPage extends StatelessWidget {
  final List<String> basement1SlotNames = ["B1A0", "B1B0", "B1C0", "B1D0"];
  final List<String> basement2SlotNames = ["B2A1", "B2B1", "B2C1", "B2D1"];

  CarSlotBookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Car Slot Booking"),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, size: 30),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AboutScreen(userId:2), // Navigates to AboutScreen
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Basement 1 Section
            Text(
              "Basement 1",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            Expanded(
              flex: 1,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 1.5,
                ),
                itemCount: basement1SlotNames.length,
                itemBuilder: (context, index) {
                  return ParkingSlot(
                    slotName: basement1SlotNames[index],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Basement 2 Section
            Text(
              "Basement 2",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            Expanded(
              flex: 1,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 1.5,
                ),
                itemCount: basement2SlotNames.length,
                itemBuilder: (context, index) {
                  return ParkingSlot(
                    slotName: basement2SlotNames[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ParkingSlot extends StatelessWidget {
  final String slotName;

  const ParkingSlot({
    super.key,
    required this.slotName,
  });

  @override
  Widget build(BuildContext context) {
    return DashedContainer(
      dashColor: Colors.blue.shade300,
      dashedLength: 10.0,
      blankLength: 9.0,
      strokeWidth: 1.0,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(slotName), // Display slot name directly
              ],
            ),
            Expanded(
              child: Image.asset(
                "assets/images/car.png",
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ReservationScreen(), // Navigates to ReservationScreen
                    ),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 7, horizontal: 30),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "BOOK NOW",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
