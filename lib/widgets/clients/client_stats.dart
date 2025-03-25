import 'package:flutter/material.dart';

class ClientStats extends StatelessWidget {
  final int totalAppointments;
  final double totalMoneySpent;
  final double avgMoneySpent;
  final double avgTimeBetweenAppointments;

  const ClientStats({
    super.key,
    required this.totalAppointments,
    required this.totalMoneySpent,
    required this.avgMoneySpent,
    required this.avgTimeBetweenAppointments,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Client Statistics",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      statTile("Total Appointments", "$totalAppointments"),
                      statTile(
                        "Avg. Spent",
                        "€${avgMoneySpent.toStringAsFixed(2)}",
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      statTile(
                        "Total Spent",
                        "€${totalMoneySpent.toStringAsFixed(2)}",
                      ),
                      statTile(
                        "Avg. Days Between",
                        "${avgTimeBetweenAppointments.toStringAsFixed(1)} days",
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget statTile(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
        ),
      ],
    );
  }
}
