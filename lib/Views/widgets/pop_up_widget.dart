import 'package:flutter/material.dart';

void showSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Dialog(
      backgroundColor: const Color(0xFFFFE5E5), 
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Container(
        width: 320,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
         
            Container(
              width: double.infinity,
              color: const Color(0xFF7DECB2),
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.check, size: 48, color: Color(0xFF7DECB2)),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Registration Succesfull!',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            ConfirmButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    ),
  );
}
