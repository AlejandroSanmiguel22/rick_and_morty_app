import 'package:flutter/material.dart';

class CustomDetailCard extends StatelessWidget {
  final List<Map<String, dynamic>> details;

  const CustomDetailCard({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: details
              .map((detail) => Column(
                    children: [
                      ListTile(
                        leading: Icon(detail["icon"], color: Colors.blueAccent),
                        title: Text(detail["label"],
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(detail["value"],
                            style: const TextStyle(fontSize: 16, color: Colors.black87)),
                      ),
                      const Divider(height: 1, thickness: 1),
                    ],
                  ))
              .toList(),
        ),
      ),
    );
  }
}