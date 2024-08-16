import 'package:another_dashed_container/another_dashed_container.dart';
import 'package:flutter/material.dart';

import 'package:helloworld/screens/reservation_screen.dart';

class CarSlotBookingPage extends StatelessWidget {
  final List<String> slotNames = ["Slot A", "Slot B", "Slot C", "Slot D"];

  CarSlotBookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Car Slot Booking"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 1.5,
          ),
          itemCount: slotNames.length,
          itemBuilder: (context, index) {
            return ParkingSlot(
              slotName: slotNames[index],
              time: "${9 + index}:00 AM", // Dynamically generate time
            );
          },
        ),
      ),
    );
  }
}

class ParkingSlot extends StatelessWidget {
  final String slotName;
  final String time;

  const ParkingSlot({
    super.key,
    required this.slotName,
    required this.time,
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
                time.isEmpty ? const SizedBox(width: 1) : Text(time),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue.shade100,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    slotName,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
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
                      builder: (context) => ReservationScreen(
                          // slotName: slotName,
                          ),
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
                    "BOOK",
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
