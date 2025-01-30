class Profile {
  String? name;

  Profile({this.name}) {
    name = name;
  }

  toJson() {
    return {"name": name};
  }

  fromJson(jsonData) {
    return Profile(name: jsonData['name']);
  }
}
