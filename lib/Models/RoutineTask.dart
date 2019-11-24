import 'package:peaky_blinders/Models/Task.dart';
import 'package:peaky_blinders/Models/User.dart';

class RoutineTask extends Task {
  static final db_routineTaskSettingId = "routineTaskSettingId";
  static final db_userId = "userId";
  static final db_imagePath = "imagePath";

  int routineTaskSettingId, userId;
  User user;
  
  RoutineTask({
    id,
    title,
    description,
    started,
    completed,
    this.routineTaskSettingId,
    points,
    priority,
    place,
    imagePath

  }): super(id: id, title: title, description: description, started: started, completed: completed, place: place, points: points);

  factory RoutineTask.fromMap(Map<String, dynamic> map) => new RoutineTask(
    title: map[Task.db_title],
    description: map[Task.db_description],
    id: map[Task.db_id],
    imagePath: map[db_imagePath],
    started: map[Task.db_started] != null ? DateTime.tryParse(map[Task.db_started]) : null,
    routineTaskSettingId: map[db_routineTaskSettingId],
    completed: map[Task.db_completed] != null ? DateTime.tryParse(map[Task.db_completed]) : null,
    points: map[Task.db_points],
    place: map[Task.db_place],
  );

  Map<String, dynamic> toMap() {
    return {
      Task.db_title: title,
      Task.db_description: description,
      Task.db_id: id,
      Task.db_started: started != null ? started.toIso8601String() : null,
      Task.db_completed: completed != null ? completed.toIso8601String() : null,
      Task.db_points: points,
      db_routineTaskSettingId: routineTaskSettingId,
      Task.db_place: place
    };
  }

}