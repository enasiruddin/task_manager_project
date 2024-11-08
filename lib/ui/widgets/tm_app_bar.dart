import 'dart:convert';

import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../screens/profile_screen.dart';
import '../screens/sign_in_screen.dart';
import '../utils/app_colors.dart';


class TMAppBar extends StatelessWidget implements PreferredSizeWidget {
   TMAppBar({
    super.key,
    this.isProfileScreenOpen = false,
  });

  final bool isProfileScreenOpen;

  String? base64ImageString = AuthController.userData!.photo;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        if (isProfileScreenOpen) {
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfileScreen(),
          ),
        );
      },
      child: AppBar(
        backgroundColor: AppColors.themeColor,
        title: Row(
          children: [
             CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white,
              child: base64ImageString==""?Text(""):Image.memory(base64Decode(base64ImageString!)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AuthController.userData?.fullName ?? '',
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    AuthController.userData?.email ?? '',
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  )
                ],
              ),
            ),
            IconButton(
              onPressed: () async {
                await AuthController.clearUserData();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                  (predicate) => false,
                );
              },
              icon: const Icon(Icons.logout),
            )
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
