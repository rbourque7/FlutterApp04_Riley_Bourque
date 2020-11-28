//Put all Database methods here. Use
//the Dogs sqLite demo as your template.
//https://flutter.dev/docs/cookbook/persistence/sqlite

//sqflite package of the week.
//https://www.youtube.com/watch?v=HefHf5B1YM0&vl=en

import 'package:path/path.dart' as pathPackage;
import 'package:sqflite/sqflite.dart' as sqflitePackage;

import 'package:stock_watcher/models/stock.dart';

class DatabaseHelper {
  sqflitePackage.Database db;

  Future<void> getOrCreateDatabaseHandle() async {
    var databasesPath = await sqflitePackage.getDatabasesPath();
    print('$databasesPath');
    var path = pathPackage.join(databasesPath, 'stock_database.db');
    print('$path');
    db = await sqflitePackage.openDatabase(
      path,
      onCreate: (sqflitePackage.Database db1, int version) async {
        await db1.execute(
          "CREATE TABLE stock(symbol TEXT PRIMARY KEY, name TEXT, price INTEGER)",
        );
      },
      version: 1,
    );
    print('$db');
  }

  Future<void> insertDog(Stock stock) async {
    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      'dogs',
      stock.toMap(),
      conflictAlgorithm: sqflitePackage.ConflictAlgorithm.replace,
    );
  }

  Future<void> printAllDogsInDb() async {
    List<Stock> listOfStocks = await this.getAllStocksFromDb();
    if (listOfStocks.length == 0) {
      print('No Dogs in the list');
    } else {
      listOfStocks.forEach((stock) {
        print('Stock{symbol: ${stock.symbol}, name: ${stock.name}, price: ${stock.price}');
      });
    }
  }

  Future<List<Stock>> getAllStocksFromDb() async {
    // Query the table for all The Dogs.
    //The .query will return a list with each item in the list being a map.
    final List<Map<String, dynamic>> stockMap = await db.query('stocks');
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(stockMap.length, (i) {
      return Stock(
        symbol: stockMap[i]['symbol'],
        name: stockMap[i]['name'],
        price: stockMap[i]['price'],
      );
    });
  }

  Future<void> updateStock(Stock stock) async {
    // Update the given Stock.
    await db.update(
      'stocks',
      stock.toMap(),
      // Ensure that the Stock has a matching symbol.
      where: "symbol = ?",
      // Pass the Stocks's id as a whereArg to prevent SQL injection.
      whereArgs: [stock.id],
    );
  }

  Future<void> deleteStock(Stock stock) async {
    // Remove the Stock from the database.
    await db.delete(
      'stocks',
      // Use a `where` clause to delete a specific stock.
      where: "symbol = ?",
      // Pass the Stocks's id as a whereArg to prevent SQL injection.
      whereArgs: [stock.id],
    );
  }
}
