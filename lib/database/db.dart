import 'package:flutter_learning/screens/sports_shop/SportsShopResponse.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class SportsDb {
  Database? _db;

  // Singleton instance
  static final SportsDb _singleton = SportsDb._internal();

  factory SportsDb() {
    return _singleton;
  }

  SportsDb._internal();

  Future<Database> get db async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final appDir = await getApplicationDocumentsDirectory();
    final dbPath = join(appDir.path, 'sport_wiz.db');
    final database = await databaseFactoryIo.openDatabase(dbPath);
    return database;
  }
}