import 'package:peaky_blinders/Models/Skill.dart';

class Task {

  static final db_id = "id";
  static final db_title = "title";
  static final db_description = "description";
  static final db_points = "points";
  static final db_place = "place";
  static final db_started = "started";
  static final db_completed = "completed";

  int id, points, place, todayPlace;
  String title, description;
  DateTime completed, started;
  List<Skill> skills;
  
  Task({
    this.id,
    this.title,
    this.description,
    this.points,
    this.place,
    this.completed,
    this.started,
    this.skills
  });
}