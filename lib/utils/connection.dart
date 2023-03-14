import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

class Connections {
  Future<Database> createOrOpenDatabase(String dbname) async {
    var databasesPath = await getDatabasesPath();
    var path = '$databasesPath/$dbname.db';
    // open the database
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE accounts (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT UNIQUE, note TEXT, color TEXT, timestamp DEFAULT current_timestamp);'
          'CREATE TABLE transactions (id INTEGER PRIMARY KEY AUTOINCREMENT, account_id INTEGER, amount NUMERIC, type TEXT, note TEXT, timestamp DEFAULT current_timestamp, FOREIGN KEY(account_id) REFERENCES accounts(id));'
          );
    });

    return database;
  }

  //Acount reletade functions

  Future<int?> addNewAccount(String accountName, String color, String note) async {
    Database database = await createOrOpenDatabase("notebook");
    try {
      await database.insert("accounts", {"name": accountName, "color": color, "note":note});
      return 200;
    } on DatabaseException catch (err) {
      if (kDebugMode) {
        print(err);
      }
      return err.getResultCode();
    }
  }

  Future<List<Map>> getAccounts() async {
    Database database = await createOrOpenDatabase("notebook");
    return await database.query("accounts");
  }

  Future<int?> deleteAccount(String name) async {
    try{
    Database database = await createOrOpenDatabase("notebook");
    await database.rawQuery("DELETE FROM accounts WHERE name = '$name'");
    return 200;
    }on DatabaseException catch (err){
      if (kDebugMode) {
        print(err);
      }
      return err.getResultCode();
    }
  }

  //Transactions related functions

   Future<int?> addNewTransaction(num amount, String type, int accountId, String note) async {
    Database database = await createOrOpenDatabase("notebook");
    try {
      await database.insert("transactions", {"amount": amount, "type": type, "account_id": accountId, "note":note});
      return 200;
    } on DatabaseException catch (err) {
      if (kDebugMode) {
        print(err);
      }
      return err.getResultCode();
    }
  }

   Future<List<Map>> getTransactions() async {
    Database database = await createOrOpenDatabase("notebook");
    return await database.query("transactions");
  }
}
