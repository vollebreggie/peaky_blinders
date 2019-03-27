import 'package:meta/meta.dart';

class ProjectTask {
  static final db_id = "id";
  static final db_title = "title";
  static final db_description = "description";
  static final db_started = "started";
  static final db_completed = "completed";

  int id;
  String title, description, started, completed;
  ProjectTask({
    @required this.id,
    @required this.title,
    @required this.description,
    this.started,
    this.completed,
  });

  ProjectTask.fromMap(Map<String, dynamic> map): this(
    title: map[db_title],
    description: map[db_description],
    id: map[db_id],
    started: map[db_started],
    
    completed: map[db_completed],
  );

  // Currently not used
  Map<String, dynamic> toMap() {
    return {
      db_title: title,
      db_description: description,
      db_id: id,
      db_started: started,
      db_completed: completed,
    };
  }
}