import 'package:flutter/material.dart';
import 'dart:async';

import 'package:stock_watcher/services/db-service.dart';
import 'package:stock_watcher/models/stock_list.dart';
import 'package:stock_watcher/models/stock.dart';
import 'package:stock_watcher/services/stock_service.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({this.title});
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  var _stockList = List<Stock>();
  String _stockSymbol = "";
  StockService _stockService = StockService();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(
            child: Text(
              'Delete All Records in Database',
            ),
            onPressed: () {},
          ),
          TextButton(
            child: Text(
              'Add Stock',
            ),
            onPressed: () {
              _inputStock();
            },
          ),
          //We must use an Expanded widget to get
          //the dynamic ListView to play nice
          //with the TextButton.
          Expanded(child: StockList(stocks: _stockList)),
        ],
      ),
    );
  }

  Future<Null> _inputStock() async {
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Input Stock Ticker Symbol'),
            contentPadding: EdgeInsets.all(5.0),
            content: TextField(
              decoration: InputDecoration(hintText: "Ticker Symbol"),
              onChanged: (String value) {
                _stockSymbol = value;
              },
            ),
            actions: <Widget>[
              TextButton(
                child: Text("Ok"),
                onPressed: () async {
                  if (_stockSymbol.isNotEmpty) {
                    //TODO: get the stock data with stockService.getQuote
                    //then dig out the symbol, companyName, and latestPrice,
                    //then rapped in a setState create a new object of
                    //type Stock and add it to _stockList
                    
                    var stockData = await _stockService.getQuote(_stockSymbol);
                    if (stockData == null) {
                      print("Call to getQuote failed to return stock data");
                    } else {
                      var symbol = stockData['symbol'];
                      print('Stock Symbol is $symbol');
                      setState(() {
                        //TODO: create a new object of type Stock
                        //populated with symbol, companyName, and latestPrice
                        //and add it to _stockList
                      });
                    }
                  }
                  _stockSymbol = "";
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }
}
