import 'package:flutter/material.dart';
import 'package:login_signup_app/pages/dashboard.dart';
import 'package:login_signup_app/pages/login.dart';
import 'package:login_signup_app/pages/register.dart';
import 'package:login_signup_app/pages/welcome.dart';
import 'package:login_signup_app/providers/auth.dart';
import 'package:login_signup_app/providers/user_provider.dart';
import 'package:login_signup_app/util/shared_preference.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<User> getUserData() => UserPreferences().getUser();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
          title: 'Login SignUp App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: FutureBuilder(
              future: getUserData(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return CircularProgressIndicator();
                  default:
                    if (snapshot.hasError)
                      return Text('Error: ${snapshot.error}');
                    else if (snapshot.data.token == null)
                      return Login();
                    else
                      UserPreferences().removeUser();
                    return Welcome(user: snapshot.data);
                }
              }),
          routes: {
            '/dashboard': (context) => DashBoard(),
            '/login': (context) => Login(),
            '/register': (context) => Register(),
          }),
    );
  }
}
