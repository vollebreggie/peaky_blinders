class LoginCredentials extends Object {

  final String username;
  final String password;

  LoginCredentials({this.username, this.password});

  Map<String, dynamic> toMap() {
    return {
      "Username": this.username,
      "Password": this.password,
    };
  }
}