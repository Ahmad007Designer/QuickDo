import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:todo_app/extensions/space_exs.dart';
import 'package:todo_app/utils/app_colors.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.75,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          // Background Gradient Layer
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryColor, Colors.purpleAccent.shade200],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Glassmorphism Blur Effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              color: Colors.white.withAlpha(77), // Soft tint for frosted effect
            ),
          ),

          // Drawer Content (Menu Items)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 120, horizontal: 20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    "https://avatars.githubusercontent.com/u/86216573?s=400&u=810fcf2a1237879d8cf1238b99c989054493d641&v=4",
                  ),
                ),
                8.h,
                Text(
                  "Ahmad Husain",
                  style: Theme.of(context).textTheme.displayMedium,
                ),

                Text(
                  "ahmadmohdrock007@gmail.com",
                  style: Theme.of(context).textTheme.displaySmall,
                ),

                // Drawer Title
                // const Text(
                //   "Menu",
                //   style: TextStyle(
                //     fontSize: 26,
                //     fontWeight: FontWeight.bold,
                //     color: Colors.white,
                //   ),
                // ),
                const SizedBox(height: 50),

                // Clickable Menu Items
                _drawerItem(
                  icon: Icons.home,
                  title: "Home",
                  onTap: () {
                    ///Home Section
                  },
                ),

                _drawerItem(
                  icon: Icons.person,
                  title: "Profile",
                  onTap: () {
                    ///Profile section
                  },
                ),

                _drawerItem(
                  icon: Icons.settings,
                  title: "Settings",
                  onTap: () {
                    ///setting Secton
                  },
                ),

                // Logout Button
                _drawerItem(
                  icon: Icons.exit_to_app,
                  title: "Logout",
                  onTap: () {
                    /// logOut Section
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Drawer Item Widget (Reusable)
  Widget _drawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color iconColor = Colors.white,
    Color textColor = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
