class MileStoneDropdown {
  int id, projectId;
  String title;

  MileStoneDropdown({this.id, this.title, this.projectId});

bool operator ==(o) => o is MileStoneDropdown && o.id == id;
int get hashCode => id.hashCode;

  MileStoneDropdown.fromMap(Map<String, dynamic> map) : this(
      id: map["id"], 
      title: map["title"],
      projectId: map["projectId"]
      );
}
