import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:path/path.dart';
import 'package:peaky_blinders/Database/LocalDatabase.dart';
import 'package:peaky_blinders/Models/WebSocketMessage.dart';
import 'package:peaky_blinders/Repositories/BaseRepository.dart';
import 'package:http/http.dart' as http;

class TvRepository extends BaseRepository {
  static final TvRepository _repo = new TvRepository._internal();
  LocalDatabase database;

  static TvRepository get() {
    return _repo;
  }

  TvRepository._internal() {
    database = LocalDatabase.get();
  }

  Future updateTv(header, body, socketId) async {
    var message = new WebSocketMessage(
        header: header, socketId: socketId, device: "Phone", body: body);
    String jsonMessage = jsonEncode(message.toMap());
    http.Response response = await http.post(super.weburl + "api/Projects/tv",
        body: jsonMessage,
        headers: {"Content-Type": "application/json"}).catchError((resp) {
      print(resp.toString());
    });
    print(response);
  }


}
