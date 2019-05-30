class WebSocketMessage {
 String header, socketId, device, body;
 

 WebSocketMessage({
     this.header,
     this.socketId,
     this.device,
     this.body
  });

 WebSocketMessage.fromMap(Map<String, dynamic> map): this(
    header: map["header"],
    socketId: map["socketId"],
    device: map["device"],
    body: map["body"]
  );

  // Currently not used
  Map<String, dynamic> toMap() {
    return {
      "header": header,
      "socketId": socketId,
      "device": device,
      "body": body
    };
  }
}