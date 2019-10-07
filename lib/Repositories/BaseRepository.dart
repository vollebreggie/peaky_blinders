import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:peaky_blinders/Database/LocalDatabase.dart';
import 'package:peaky_blinders/Models/Token.dart';
import 'package:peaky_blinders/Repositories/Mapper.dart';
import 'package:peaky_blinders/Repositories/ParsedResponse.dart';

class BaseRepository {
  final int NO_INTERNET = 404;
  int loggedInUserId = 0;
  //static final String webUrl = "http://192.168.178.10:45455/";
  static final String webUrl = "http://kataskopos.nl/";
  //static final String webUrl = "http://192.168.0.104:45455/";
  get weburl => webUrl;
  LocalDatabase database;

  Future<Token> getToken() async {
    return await database.getToken();
  }

  Future<String> getAuthHeader() async {
    Token token = await getToken();
    if (token != null) {
      return "Authorization " + jsonEncode(token.toMap());
    }else {
      return "";
    }
  }

  ParsedResponse interceptResponse<T>(http.Response response, bool isList) {
    if (response == null) {
      return new ParsedResponse(NO_INTERNET, []);
    }

    //If there was an error return an empty list
    if (response.statusCode < 200 || response.statusCode >= 300) {
      return new ParsedResponse(response.statusCode, []);
    }

    if (isList) {
      List<dynamic> list = json.decode(response.body);
      List<T> newList = [];
      for (dynamic jsonObject in list) {
        newList.add(Mapper.fromMap<T>(jsonObject));
      }
      return new ParsedResponse(response.statusCode, newList);
    }

    return new ParsedResponse(
        response.statusCode, Mapper.fromMap<T>(json.decode(response.body)));
  }
}
