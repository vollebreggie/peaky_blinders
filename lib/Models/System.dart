class System {
  int id;
  String name, version;
  DateTime releaseDate;

  System({this.id, this.name, this.version, this.releaseDate});

  factory System.fromMap(Map<String, dynamic> map) => new System(
      id: map["id"],
      name: map["name"],
      version: map["version"],
      releaseDate: map["releaseDate"]);

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "version": version,
      "release_date": releaseDate != null ? releaseDate.toIso8601String() : null,
    };
  }
}
