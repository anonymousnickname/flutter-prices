import 'package:flutter/material.dart';
import 'package:test_project/PriceData.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PriceList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PriceListState();
  }
}

class PriceListState extends State<PriceList> {
  List<PriceData> data = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Price Tracker'),
          backgroundColor: Color.fromRGBO(22, 2, 222, 0.1)),
      body: Container(
          child: ListView(
        children: _buildList(),
      )),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.compare_arrows), onPressed: () => _reversePrice()),
    );
  }

  _loadPrice() async {
    final response = await http.get('https://api.coincap.io/v2/assets?limit=9');
    if (response.statusCode == 200) {
      var allData = (json.decode(response.body) as Map)['data'];
      var priceDataList = List<PriceData>();
      allData.forEach((val) {
        var record = PriceData(
            name: val['name'],
            symbol: val['symbol'],
            price: double.parse(val['priceUsd']),
            rank: int.parse(val['rank']));
        priceDataList.add(record);
        priceDataList.sort((a, b) => b.price.compareTo(a.price));
      });
      setState(() {
        data = priceDataList;
      });
    }
  }

  @protected
  @mustCallSuper
  void initState() {
    super.initState();
    _loadPrice();
  }

  _reversePrice() {
    setState(() {
      data = new List.from(data.reversed);
    });
  }

  List<Widget> _buildList() {
    return data
        .map((PriceData f) => ListTile(
              subtitle: Text(f.symbol),
              title: Text(f.name),
              leading: CircleAvatar(child: Text(f.rank.toString())),
              trailing: Text('\$${f.price.toStringAsFixed(2)}'),
            ))
        .toList();
  }
}
