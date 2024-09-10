import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_4/Models/User/location.dart';
import 'package:task_4/Models/User/login.dart';
import 'package:task_4/Models/User/name.dart';
import 'package:task_4/Models/User/user.dart';

class DatabaseService {
  static final DatabaseService _databaseService =
      DatabaseService._privatisedConstructor();

  DatabaseService._privatisedConstructor();

  factory DatabaseService() => _databaseService;
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final getDirectory = await getApplicationDocumentsDirectory();
    String path = '${getDirectory.path}/users.db';

    return await openDatabase(path, onCreate: _onCreate, version: 1);
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE Users(
    email TEXT,
    gender TEXT,
    name_title TEXT,
    name_first_name TEXT,
    name_last_name TEXT,
    location_street_no TEXT,
    location_street_name TEXT,
    location_city TEXT,
    location_state TEXT,
    location_country TEXT,
    location_post_code TEXT,
    location_coordinates_lati TEXT,
    location_coordinates_longi TEXT,
    location_time_zone_offset TEXT,
    location_time_zone_description TEXT,
    login_uuid TEXT PRIMARY KEY,
    login_username TEXT,
    login_password TEXT,
    login_salt TEXT,
    login_md5 TEXT,
    login_sha1 TEXT,
    login_sha256 TEXT,
    dob_date TEXT,
    dob_age TEXT,
    registered_date TEXT,
    registered_age TEXT,
    phone TEXT,
    cell TEXT,
    id_name TEXT,
    id_value TEXT,
    picture_large TEXT,
    picture_medium TEXT,
    picture_thumbnail TEXT,
    nat TEXT
      )''');
  }

  Future<void> deleteTable() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/users.db';
    await deleteDatabase(path);
  }

  Future<void> insertUserIntoDatabase(
      UserProfile user, BuildContext context) async {
    final database = await _databaseService.database;

    final foundUser = await findUserByUuid(user.login!.uuid!);
    if (foundUser == null) {
      await database.rawInsert(''' INSERT INTO Users(
        email,
        gender,
        name_title,
        name_first_name,
        name_last_name,
        location_street_no,
        location_street_name,
        location_city,
        location_state,
        location_country,
        location_post_code,
        location_coordinates_lati,
        location_coordinates_longi,
        location_time_zone_offset,
        location_time_zone_description,
        login_uuid,
        login_username,
        login_password,
        login_salt,
        login_md5,
        login_sha1,
        login_sha256,
        dob_date,
        dob_age,
        registered_date,
        registered_age,
        phone,
        cell,
        id_name,
        id_value,
        picture_large,
        picture_medium,
        picture_thumbnail,
        nat
        ) VALUES(
        '${user.email}',
        '${user.gender}',
        '${user.name?.title}',
        '${user.name?.first}',
        '${user.name?.last}',
        '${user.location?.street?.number}',
       '${user.location?.street?.name}',
        '${user.location?.city}',
        '${user.location?.state}',
        '${user.location?.country}',
        '${user.location?.postcode}',
        '${user.location?.coordinates?.latitude}',
        '${user.location?.coordinates?.longitude}',
        '${user.location?.timezone?.offset}',
        '${user.location?.timezone?.description}',
        '${user.login?.uuid}',
        '${user.login?.username}',
        '${user.login?.password}',
        '${user.login?.salt}',
        '${user.login?.md5}',
        '${user.login?.sha1}',
        '${user.login?.sha256}',
        '${user.dob?.date}',
        '${user.dob?.age}',
        '${user.registered?.date}',
        '${user.registered?.age}',
        '${user.phone}',
        '${user.cell}',
        '${user.id?.name}',
        '${user.id?.value}',
        '${user.picture?.large}',
        '${user.picture?.medium}',
        '${user.picture?.thumbnail}',
        '${user.nat}'
        )''');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "User has been Created in database",
            ),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "User Already Exist",
            ),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<List<UserProfile>> users() async {
    final database = await _databaseService.database;
    List<UserProfile> userProfileList = [];
    List<Map<String, dynamic>> mapOfUsers =
        await database.rawQuery('SELECT * FROM Users');
    for (int i = 0; i < mapOfUsers.length; i++) {
      final user = UserProfile(
        email: mapOfUsers[i]['email'],
        gender: mapOfUsers[i]['gender'],
        name: Name(
          title: mapOfUsers[i]['name_title'],
          first: mapOfUsers[i]['name_first_name'],
          last: mapOfUsers[i]['name_last_name'],
        ),
        location: Location(
          street: Street(
            number: mapOfUsers[i]['location_street_no'],
            name: mapOfUsers[i]['location_street_name'],
          ),
          city: mapOfUsers[i]['location_city'],
          postcode: mapOfUsers[i]['location_post_code'],
          coordinates: Coordinates(
            latitude: mapOfUsers[i]['location_coordinates_lati'],
            longitude: mapOfUsers[i]['location_coordinates_longi'],
          ),
          timezone: TimeZone(
            offset: mapOfUsers[i]['location_time_zone_offset'],
            description: mapOfUsers[i]['location_time_zone_description'],
          ),
        ),
        login: Login(
          uuid: mapOfUsers[i]['login_uuid'],
          username: mapOfUsers[i]['login_username'],
          password: mapOfUsers[i]['login_password'],
          salt: mapOfUsers[i]['login_salt'],
          md5: mapOfUsers[i]['login_md5'],
          sha1: mapOfUsers[i]['login_sha1'],
          sha256: mapOfUsers[i]['login_sha256'],
        ),
        dob:
            DOB(date: mapOfUsers[i]['dob_date'], age: mapOfUsers[i]['dob_age']),
        registered: Registered(
          date: mapOfUsers[i]['registered_date'],
          age: mapOfUsers[i]['registered_age'],
        ),
        phone: mapOfUsers[i]['phone'],
        cell: mapOfUsers[i]['cell'],
        id: Id(
          name: mapOfUsers[i]['id_name'],
          value: mapOfUsers[i]['id_value'],
        ),
        picture: Picture(
          large: mapOfUsers[i]['picture_large'],
          medium: mapOfUsers[i]['picture_medium'],
          thumbnail: mapOfUsers[i]['picture_thumbnail'],
        ),
        nat: mapOfUsers[i]['nat'],
      );

      userProfileList.add(user);
    }
    return userProfileList;
  }

  Future<UserProfile?> findUserByUuid(String uuid) async {
    final database = await _databaseService.database;
    List<Map<String, dynamic>> usersMap = await database.rawQuery(
      'SELECT * from Users WHERE login_uuid = ?',
      [uuid],
    );
    if (usersMap.isNotEmpty) {
      Map<String, dynamic> userMap = usersMap.first;
      final user = UserProfile(
        email: userMap['email'],
        gender: userMap['gender'],
        name: Name(
          title: userMap['name_title'],
          first: userMap['name_first_name'],
          last: userMap['name_last_name'],
        ),
        location: Location(
          street: Street(
            number: userMap['location_street_no'],
            name: userMap['location_street_name'],
          ),
          city: userMap['location_city'],
          postcode: userMap['location_post_code'],
          coordinates: Coordinates(
            latitude: userMap['location_coordinates_lati'],
            longitude: userMap['location_coordinates_longi'],
          ),
          timezone: TimeZone(
            offset: userMap['location_time_zone_offset'],
            description: userMap['location_time_zone_description'],
          ),
        ),
        login: Login(
          uuid: userMap['login_uuid'],
          username: userMap['login_username'],
          password: userMap['login_password'],
          salt: userMap['login_salt'],
          md5: userMap['login_md5'],
          sha1: userMap['login_sha1'],
          sha256: userMap['login_sha256'],
        ),
        dob: DOB(date: userMap['dob_date'], age: userMap['dob_age']),
        registered: Registered(
          date: userMap['registered_date'],
          age: userMap['registered_age'],
        ),
        phone: userMap['phone'],
        cell: userMap['cell'],
        id: Id(
          name: userMap['id_name'],
          value: userMap['id_value'],
        ),
        picture: Picture(
          large: userMap['picture_large'],
          medium: userMap['picture_medium'],
          thumbnail: userMap['picture_thumbnail'],
        ),
        nat: userMap['nat'],
      );

      return user;
    } else {
      return null;
    }
  }

  Future<int> deleteUserFromSqliteDatabase(String uuid) async {
    final database = await _databaseService.database;
    int count = await database
        .rawDelete('DELETE FROM Users WHERE login_uuid = ?', [uuid]);
    return count;
  }

  Future<int> updateDataInSqliteDatabase(
      String firstName,
      String lastName,
      String email,
      String phoneNumber,
      String password,
      String latitude,
      String longitude,
      String uuid) async {
    final database = await _databaseService.database;

    int done = await database.rawUpdate('''UPDATE Users SET name_first_name= ?,
    name_last_name= ?,
    email= ?,
    phone= ?,
    login_password= ?,
    location_coordinates_lati= ?,
    location_coordinates_longi= ?
    WHERE login_uuid =?
    ''', [
      firstName,
      lastName,
      email,
      phoneNumber,
      password,
      latitude,
      longitude,
      uuid
    ]);
    return done;
  }

  Future<int> updateImageInSqliteDatabase(String image, String uuid) async {
    final database = await _databaseService.database;
    int done = await database.rawUpdate(
        'UPDATE Users SET picture_thumbnail= ?  WHERE login_uuid= ?',
        [image, uuid]);
    return done;
  }

  Future<String> convertImageIntoBase64String(File image) async {
    List<int> imagesBytes = await image.readAsBytes();
    String base64String = base64Encode(imagesBytes);
    return base64String;
  }
}
