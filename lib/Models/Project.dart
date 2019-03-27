import 'package:meta/meta.dart';

class Project {
  static final db_id = "id";
  static final db_title = "title";
  static final db_description = "description";

  int id;
  String title, description, started, completed;
  Project({
    @required this.id,
    @required this.title,
    @required this.description,

  });

  Project.fromMap(Map<String, dynamic> map): this(
    title: map[db_title],
    description: map[db_description],
    id: map[db_id],
  );

  // Currently not used
  Map<String, dynamic> toMap() {
    return {
      db_title: title,
      db_description: description,
      db_id: id,
    };
  }
}