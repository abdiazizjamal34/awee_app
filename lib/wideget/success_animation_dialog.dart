import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessAnimationDialog extends StatelessWidget {
  const SuccessAnimationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/sucess.json', // ✅ Lottie animation file
              width: 150,
              height: 150,
              repeat: false,
            ),
            const SizedBox(height: 20),
            const Text(
              'Order Created Successfully!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context), // Close dialog
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}
