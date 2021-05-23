import 'package:login_signup_app/models/user.dart';

class RestData {
  // static final BASE_URL = "";
  // static final LOGIN_URL = BASE_URL + "/login";

  Future<User> login(String email, String password) {
    return null;
  }

  Future<User> register(String name, String email, String password) {
    print(name);
    return Future.value(new User(name: name, email: email, password: password));
  }
}
