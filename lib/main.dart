import 'package:flutter/material.dart';
import 'package:test_project/PriceList.dart';

void main() => runApp(PriceTracker());

class PriceTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Price Tracker',
        theme: ThemeData(primarySwatch: Colors.red),
        home: PriceList());
  }
}
