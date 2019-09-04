class Log {
  int id;
  String shortMessage, description, stacktrace;
  bool solved;

  Log(
      {this.id,
      this.shortMessage,
      this.description,
      this.stacktrace,
      this.solved});

  factory Log.fromMap(Map<String, dynamic> map) => new Log(
        id: map["id"],
        shortMessage: map["shortMessage"],
        description: map["description"],
        stacktrace: map["stacktrace"],
        solved: map["solved"],
      );

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "shortMessage": shortMessage,
      "description": description,
      "stacktrace": stacktrace,
      "solved": solved,
    };
  }
}
