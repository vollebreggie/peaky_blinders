import 'package:peaky_blinders/Models/User.dart';

class Device {
 int id;
 User user;
 String socketId;

 
 

 Device({
     this.id,
     this.user,
     this.socketId
  });

 Device.fromMap(Map<String, dynamic> map): this(
    id: map["id"],
    socketId: map["socketId"],
    user: User.fromMap(map["user"])
  );

  // Currently not used
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "user": user.toMap(),
      "socketId": socketId
    };
  }
}