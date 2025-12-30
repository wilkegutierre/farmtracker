import 'package:flutter/material.dart';

class CustomCardClient extends StatelessWidget {
  final String clientName;
  final String city;
  final String coreName;

  const CustomCardClient({super.key, required this.clientName, required this.city, required this.coreName});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: GestureDetector(
        onTap: () {},
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(clientName, style: TextStyle(color: Colors.black, fontSize: 16)),
                          Text(coreName, style: TextStyle(color: Colors.black, fontSize: 16)),
                        ],
                      ),
                      Row(
                        children: [Text(city, style: TextStyle(color: Colors.grey[700], fontSize: 16))],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
