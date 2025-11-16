import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:m_hike_cross_app/model/hike.dart';
import 'package:m_hike_cross_app/model/observation.dart';

class DatabaseHelper {
  static const _databaseName = "m_hike.db";
  static const _databaseVersion = 1;

  static const tableHikes = 'hikes';
  static const tableObservations = 'observations';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tableHikes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            location TEXT NOT NULL,
            date TEXT NOT NULL,
            parkingAvailable INTEGER NOT NULL,
            length REAL NOT NULL,
            difficulty TEXT NOT NULL,
            description TEXT,
            equipmentNeeded TEXT,
            estimatedDuration TEXT
          )
          ''');
    await db.execute('''
          CREATE TABLE $tableObservations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            hikeId INTEGER NOT NULL,
            text TEXT NOT NULL,
            time TEXT NOT NULL,
            comment TEXT,
            FOREIGN KEY (hikeId) REFERENCES $tableHikes (id) ON DELETE CASCADE
          )
          ''');
  }

  // Hike methods
  Future<int> insertHike(Hike hike) async {
    Database db = await instance.database;
    return await db.insert(tableHikes, hike.toMap());
  }

  Future<List<Hike>> getAllHikes() async {
    Database db = await instance.database;
    var hikes = await db.query(tableHikes);
    List<Hike> hikeList = hikes.isNotEmpty
        ? hikes.map((c) => Hike.fromMap(c)).toList()
        : [];
    return hikeList;
  }

  Future<int> updateHike(Hike hike) async {
    Database db = await instance.database;
    return await db.update(tableHikes, hike.toMap(),
        where: 'id = ?', whereArgs: [hike.id]);
  }

  Future<int> deleteHike(int id) async {
    Database db = await instance.database;
    return await db.delete(tableHikes, where: 'id = ?', whereArgs: [id]);
  }
  
  Future<int> deleteAllHikes() async {
    Database db = await instance.database;
    return await db.delete(tableHikes);
  }


  // Observation methods
  Future<int> insertObservation(Observation observation) async {
    Database db = await instance.database;
    return await db.insert(tableObservations, observation.toMap());
  }

  Future<List<Observation>> getObservationsForHike(int hikeId) async {
    Database db = await instance.database;
    var observations = await db.query(tableObservations,
        where: 'hikeId = ?', whereArgs: [hikeId]);
    List<Observation> observationList = observations.isNotEmpty
        ? observations.map((c) => Observation.fromMap(c)).toList()
        : [];
    return observationList;
  }

  Future<int> deleteObservation(int id) async {
    Database db = await instance.database;
    return await db.delete(tableObservations, where: 'id = ?', whereArgs: [id]);
  }
}
