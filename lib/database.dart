import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DataBaseApp(),
    );
  }
}

class DataBaseApp extends StatefulWidget {
  @override
  State<DataBaseApp> createState() => _DataBaseAppState();
}

class _DataBaseAppState extends State<DataBaseApp> {
  // ignore: unused_field
  @override
  Widget build(BuildContext context) {
    MyDatabase.instance
        .create(const LocalAnime(
            name: "name",
            image: "image",
            url: "url",
            type: "type",
            epNYear: "rating"))
        .then((value) => MyDatabase.instance
            .readAllAnime()
            .then((value) => debugPrint(value.first.url)));

    return Container();
  }
}

class MyDatabase {
  static final MyDatabase instance = MyDatabase._init();
  static Database? _database;
  MyDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('anime.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = dbPath + filePath;
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE ${LocalAnimeFied.table}(
      ${LocalAnimeFied.id} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${LocalAnimeFied.name} TEXT NOT NULL ,
      ${LocalAnimeFied.image} TEXT NOT NULL,
      ${LocalAnimeFied.url} TEXT NOT NULL UNIQUE,
      ${LocalAnimeFied.type} TEXT NOT NULL,
      ${LocalAnimeFied.releasedYear} TEXT NOT NULL
      ) 
''');
  }

  Future<LocalAnime> create(LocalAnime anime) async {
    final db = await instance.database;
    debugPrint("data base created");
    final id = await db.insert(LocalAnimeFied.table, anime.toJson());
    debugPrint("data created");
    return anime.copy(id: id);
  }

  Future<LocalAnime> readAnime(dynamic id) async {
    final db = await instance.database;
    final maps = await db.query(
      LocalAnimeFied.table,
      columns: LocalAnimeFied.values,
      where: '${LocalAnimeFied.url} = ?',
      orderBy: "${LocalAnimeFied.id} DESC",

      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return LocalAnime.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<LocalAnime>> readAllAnime() async {
    final db = await instance.database;
    final result = await db.query(LocalAnimeFied.table);
    return result.map((json) => LocalAnime.fromJson(json)).toList();
  }

  Future<int> update(LocalAnime anime) async {
    final db = await instance.database;
    return db.update(
      LocalAnimeFied.table,
      anime.toJson(),
      where: '${LocalAnimeFied.id} = ?',
      whereArgs: [anime.id],
    );
  }

  Future<int> delete(dynamic id) async {
    final db = await instance.database;
    return await db.delete(
      LocalAnimeFied.table,
      where: '${LocalAnimeFied.url} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}

class LocalAnime {
  final int? id;
  final String name;
  final String image;
  final String url;
  final String type;
  final String epNYear;

  const LocalAnime({
    this.id,
    required this.name,
    required this.image,
    required this.url,
    required this.type,
    required this.epNYear,
  });

  static LocalAnime fromJson(Map<String, Object?> json) => LocalAnime(
        id: json[LocalAnimeFied.id] as int?,
        name: json[LocalAnimeFied.name] as String,
        image: json[LocalAnimeFied.image] as String,
        url: json[LocalAnimeFied.url] as String,
        type: json[LocalAnimeFied.type] as String,
        epNYear: json[LocalAnimeFied.releasedYear] as String,
      );

  Map<String, Object?> toJson() => {
        LocalAnimeFied.id: id,
        LocalAnimeFied.name: name,
        LocalAnimeFied.image: image,
        LocalAnimeFied.url: url,
        LocalAnimeFied.type: type,
        LocalAnimeFied.releasedYear: epNYear,
      };

  LocalAnime copy({
    int? id,
    String? name,
    String? image,
    String? url,
    String? type,
    String? releasedYear,
  }) =>
      LocalAnime(
        id: id ?? this.id,
        name: name ?? this.name,
        image: image ?? this.image,
        url: url ?? this.url,
        type: type ?? this.type,
        epNYear: releasedYear ?? this.epNYear,
      );
}

class LocalAnimeFied {
  static const String id = 'id';
  static const String name = 'name';
  static const String image = 'imageUrl';
  static const String url = 'url';
  static const String type = 'type';

  static const String releasedYear = 'releasedYear';

  static const String table = 'LocalAnime';
  static const String table1 = 'watching';
  static const String episode = 'LocalAnime';

  static final List<String> values = [id, name, image, url, type, releasedYear];
}
