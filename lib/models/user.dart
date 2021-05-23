class User {
  int userId;
  String name;
  String email;
  String password;
  String token;

  User({this.userId, this.name, this.email, this.password, this.token});

  factory User.fromDatabaseJson(Map<String, dynamic> responseData) {
    return User(
        userId: responseData['id'],
        name: responseData['name'],
        email: responseData['email'],
        password: responseData['password'],
        token: responseData['access_token']);
  }

  Map<String, dynamic> toDatabaseJson() {
    return {
      "id": this.userId,
      "name": this.name,
      "email": this.email,
      "password": this.password,
      "token": this.token
    };
  }

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
        userId: responseData['id'],
        name: responseData['name'],
        email: responseData['email'],
        password: responseData['password'],
        token: responseData['access_token']);
  }
}
