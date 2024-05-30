import 'package:flutter/material.dart';

class RequestListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request List'),
      ),
      body: Center(
        child: Text(
          'Request List Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
