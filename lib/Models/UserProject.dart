import 'package:peaky_blinders/Models/User.dart';

class UserProject {
  int id;
  int projectId;
  int userId;
  User user;
  
  UserProject({
    this.id,
    this.projectId,
    this.userId,
    this.user
  });

  UserProject.fromMap(Map<String, dynamic> map)
      : this(
          id: map["id"],
          projectId: map["projectId"],
          userId: map["userId"],
          user: map["user"] != null ? User.fromMap(map["user"]) : null);

  

  // Currently not used
  Map<String, dynamic> toMap() {
    return {"projectId": projectId, "userId": userId, "id": id};
  }
}
