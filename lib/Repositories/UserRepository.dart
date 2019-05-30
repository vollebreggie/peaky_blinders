import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:path/path.dart';
import 'package:peaky_blinders/Database/LocalDatabase.dart';
import 'package:peaky_blinders/Models/ChartData.dart';
import 'package:peaky_blinders/Models/LoginCredentials.dart';
import 'package:peaky_blinders/Models/Token.dart';
import 'package:peaky_blinders/Models/User.dart';
import 'package:peaky_blinders/Repositories/BaseRepository.dart';
import 'package:http/http.dart' as http;
import 'package:peaky_blinders/Repositories/ParsedResponse.dart';

class UserRepository extends BaseRepository {
  static final UserRepository _repo = new UserRepository._internal();
  LocalDatabase database;

  static UserRepository get() {
    return _repo;
  }

  UserRepository._internal() {
    database = LocalDatabase.get();
  }

  //TODO:: needs return when failed
  Future login(username, password) async {
    http.Response response = await http.post(super.weburl + "api/auth/login",
        body: jsonEncode(
            new LoginCredentials(username: username, password: password)
                .toMap()),
        headers: {"Content-Type": "application/json"});
    ParsedResponse parsedResponse = interceptResponse<Token>(response, false);

    if (parsedResponse.isOk()) {
      Token token = parsedResponse.body;
      User user = await getUserFromServer(token.id);
      database.updateLoggedInUser(user);
      database.updateToken(token);
    }
  }

  void syncUsers() async {
    http.Response response = await http.get(super.weburl + "api/accounts/users",
        headers: {"Content-Type": "application/json"}).catchError((resp) {});
    ParsedResponse parsedResponse = interceptResponse<User>(response, true);

    if (parsedResponse.isOk()) {
      for (User user in parsedResponse.body) {
        database.updateUser(user);
      }
    }
  }

  Future<int> getCompletedTasks(userId) async {
    http.Response response = await http.get(
        super.weburl + "api/accounts/getTasksThisweek/$userId",
        headers: {"Content-Type": "application/json"});
    return int.tryParse(response.body) == null
        ? 0
        : int.tryParse(response.body);
  }

  Future<List<ChartData>> getChartData(userId) async {
    http.Response response = await http.get(
        super.weburl + "api/accounts/getDataForGraph/$userId",
        headers: {"Content-Type": "application/json"});
    ParsedResponse parsedResponse =
        interceptResponse<ChartData>(response, true);
    if (parsedResponse.isOk()) {
      return parsedResponse.body;
    }
    return null;
  }

  Future<int> getCompletedPoints(userId) async {
    http.Response response = await http.get(
        super.weburl + "api/accounts/getPointsThisweek/$userId",
        headers: {"Content-Type": "application/json"});
    return int.tryParse(response.body) == null
        ? 0
        : int.tryParse(response.body);
  }

  Future<User> getLoggedInUser() async {
    return await database.getLoggedInUser();
  }

  Future<User> getUserLocal() async {
    return await database.getUser();
  }

  Future<User> getUserFromServer(id) async {
    ParsedResponse parsedResponse = interceptResponse<User>(
        await http.post(super.weburl + "api/accounts/user",
            body: jsonEncode(id),
            headers: {"Content-Type": "application/json"}),
        false);

    if (parsedResponse.isOk()) {
      return parsedResponse.body;
    }

    return null;
  }

  uploadUserImage(File imageFile, int userId) async {
    // open a bytestream
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse(super.weburl + "api/accounts/image/$userId");

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));

    // add file to multipart
    request.files.add(multipartFile);

    // send
    var response = await request.send();
    print(response.statusCode);

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {});
  }

  Future<List<User>> getUsers() async {
    http.Response response = await http.get(super.weburl + "api/accounts/users",
        headers: {"Content-Type": "application/json"}).catchError((resp) {});

    List<dynamic> list = json.decode(response.body);
    List<User> users = new List<User>();
    for (dynamic jsonUser in list) {
      User user = new User(
          id: jsonUser["id"],
          firstName: jsonUser["firstname"],
          image: jsonUser["image"]);
      users.add(user);
      database.updateUser(user);
    }
    return users;
  }
}
