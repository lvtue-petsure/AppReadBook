import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.brown[50],
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                      },
                      child: const Text("sách nói"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),                  
                  ],
                ),
            ),
        ),
      ),
    );
  }
}