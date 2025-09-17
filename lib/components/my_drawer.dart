
import 'package:flutter/material.dart';
import 'package:weather/services/settings_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          const DrawerHeader(
            child: Icon(
            Icons.directions_run,
            size: 65,
            color: Colors.black,
            ),
          ),

          // home title
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 20),
            child: ListTile(
              title: const Text(
                "HOME",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              leading: const Icon(Icons.home, color: Colors.black ,size: 30),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),

          // settings
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: ListTile(
              title: const Text(
                "SETTINGS",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              leading: const Icon(Icons.settings, color: Colors.black ,size: 30),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
          ),

          // about
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: ListTile(
              title: const Text(
                "ABOUT",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              leading: const Icon(Icons.info_outline, color: Colors.black ,size: 30),
              onTap: () {
                
              },
            ),
          ),

          const SizedBox(height: 365),

          const Text(
            "Designed By",
            style: TextStyle(
              fontWeight: FontWeight.w300
            ),
          ),
          const Text(
            "Sk Samim Naser",
            style: TextStyle(
              fontWeight: FontWeight.w300
            ),
          )
        ],
      ),
    );
  }
}
