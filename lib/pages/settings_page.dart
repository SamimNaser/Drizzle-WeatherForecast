import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadKey();
  }

  Future<void> _loadKey() async {
    final prefs = await SharedPreferences.getInstance();
    _controller.text = prefs.getString('apiKey') ?? '';
  }

  Future<void> _saveKey() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('apiKey', _controller.text.trim());
    if (!mounted) return;
    Navigator.pop(context); // back to WeatherPage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/image.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CupertinoTextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    placeholder: "Enter API Key",
                    placeholderStyle: const TextStyle(color: Colors.white54),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveKey,
                    child: const Text("Save"),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}