import 'package:peaky_blinders/Models/Skill.dart';
import 'package:peaky_blinders/Models/User.dart';

class RoutineTaskSetting {
  static final db_id = "id";
  static final db_title = "title";
  static final db_description = "description";
  // static final db_started = "started";
  // static final db_completed = "completed";
  static final db_userId = "userId";
  static final db_points = "points";
  static final db_place = "place";
  static final db_monday = "monday";
  static final db_tuesday = "tuesday";
  static final db_wednesday = "wednesday";
  static final db_thursday = "thursday";
  static final db_friday = "friday";
  static final db_saturday = "saturday";
  static final db_sunday = "sunday";

  int id, userId, points, place;
  int monday, tuesday, wednesday, thursday, friday, saturday, sunday;
  //DateTime completed, started;
  String title, description;
  User user;
  List<Skill> skills;

  RoutineTaskSetting(
      {this.id,
      this.title,
      this.description,
      // this.started,
      // this.completed,
      this.points,
      this.user,
      this.userId,
      this.place,
      this.monday,
      this.tuesday,
      this.wednesday,
      this.thursday,
      this.friday,
      this.saturday,
      this.sunday,
      this.skills});

  static List<dynamic> skillsToMap(List<Skill> skills) {
    List<dynamic> jsonSkillsMap = [];
    for (var skill in skills) {
      jsonSkillsMap.add(skill.toMap());
    }
    return jsonSkillsMap;
  }

  factory RoutineTaskSetting.fromMap(Map<String, dynamic> map) =>
      new RoutineTaskSetting(
        title: map[db_title],
        description: map[db_description],
        id: map[db_id],
        //started: map[db_started] != null ? DateTime.tryParse(map[db_started]) : null,
        userId: map[db_userId],
        //completed: map[db_completed] != null ? DateTime.tryParse(map[db_completed]) : null,
        points: map[db_points],
        place: map[db_place],
        monday: map[db_monday],
        tuesday: map[db_tuesday],
        wednesday: map[db_wednesday],
        thursday: map[db_thursday],
        friday: map[db_friday],
        saturday: map[db_saturday],
        sunday: map[db_sunday],
      );

  Map<String, dynamic> toMap() {
    return {
      db_title: title,
      db_description: description,
      db_id: id,
      // db_started: started != null ? started.toIso8601String() : null,
      // db_completed: completed != null ? completed.toIso8601String() : null,
      db_points: points,
      db_place: place,
      db_userId: userId,
      "user": user != null ? user.toMap() : null,
      db_monday: monday,
      db_tuesday: tuesday,
      db_wednesday: wednesday,
      db_thursday: thursday,
      db_friday: friday,
      db_saturday: saturday,
      db_sunday: sunday,
      "skills": skills != null ? skillsToMap(skills) : null
    };
  }
}
