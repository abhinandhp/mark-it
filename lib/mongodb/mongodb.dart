import 'dart:developer';

import 'package:mark_it/mongodb/constants.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;


class MongoDb {

  static final MongoDb _instance = MongoDb._internal();

  factory MongoDb() {
    return _instance;
  }

  MongoDb._internal();

  mongo.Db? db;
  mongo.DbCollection? collection;
  late Future<List<Map<String,dynamic>>> documents;
  Future<void> connect() async {
     try {
       db = await mongo.Db.create(mongoUrl);
    await db!.open();
    print('connected');
    inspect(db);
    await db!.collection('newc').insertOne({'newkey':"value"});
     } catch (e) {
       print(e.toString());
     }

     documents = allsubs();
       
    
  }

  Future<void> insert(Map<String,dynamic> data) async{
    try {
      await db!.collection('insert').insertOne(data);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addsub(Map<String,dynamic> data) async{
    try {
      await db!.collection('subjects').insertOne(data);
    } catch (e) {
      print(e.toString());
    }
  }
  
  Future<List<Map<String,dynamic>>> allsubs() async{
    await connect();
    if (db != null && db!.state == mongo.State.open) {
      final documents = await db!.collection('subjects').find().toList();
      return documents.toList();
    } else {
      throw Exception("Database is not connected");
    }

  }

}

/*static connect() async {
    List users = [];
    var db = await mongo.Db.create(mongoUrl);
    await db.open();
    inspect(db);
    await db.collection('users').find().forEach((element) => users.add(element),);
    print(users);
    await db.collection('newc').insertOne({'newkey':"value"});
    print("hi");
  } */