import 'package:flutter/material.dart';

class WaitingScreen extends StatelessWidget {
  final String message;
  final VoidCallback onClose;

  WaitingScreen({required this.message, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Expanded(child: Text('Pending Approval')),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: onClose,
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text(message),
        ],
      ),
    );
  }
}
