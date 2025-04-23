import 'package:flutter/material.dart';

Widget profile(name, email) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,

    children: [
      Container(
        padding: const EdgeInsets.fromLTRB(30, 0, 60, 0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 112, 127, 156),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          children: [
            const SizedBox(height: 6),
            Row(
              children: [
                // const SizedBox(width: 6),
                CircleAvatar(
                  radius: 40,
                  backgroundImage: Image.asset('assets/avater.png').image,
                ),

                Column(
                  children: [
                    const SizedBox(width: 16),
                    Text(
                      '$name',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 76),
                    Text(
                      '$email',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 8),

            // CircleAvatar(
            //   radius: 40,
            //   backgroundImage: NetworkImage(
            //     'https://example.com/user_profile_image.jpg',
            //   ),
            // ),
            // const Text(
            //   'User name',
            //   style: TextStyle(
            //     fontSize: 24,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.white,
            //   ),
            // ),
          ],
        ),
      ),
    ],
  );
}
