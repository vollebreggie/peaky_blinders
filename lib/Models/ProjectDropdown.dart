class ProjectDropdown {
  int id;
  String title, imagePathServer;

  ProjectDropdown({this.id, this.title, this.imagePathServer});

bool operator ==(o) => o is ProjectDropdown && o.id == id;
int get hashCode => id.hashCode;

  ProjectDropdown.fromMap(Map<String, dynamic> map) : this(
      id: map["id"], 
      title: map["title"],
      imagePathServer: map["imagePath"],
      );
}
