import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:login_signup_app/models/user.dart';
import 'package:login_signup_app/providers/auth.dart';
import 'package:login_signup_app/providers/user_provider.dart';
import 'package:login_signup_app/util/shared_preference.dart';
import 'package:login_signup_app/util/validators.dart';
import 'package:login_signup_app/util/widgets.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> implements AuthContract {
  final formKey = new GlobalKey<FormState>();

  String _name, _email, _password, _confirmPassword;

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    final nameField = TextFormField(
      autofocus: false,
      validator: (value) => value.isEmpty ? "Please enter your Name" : null,
      onSaved: (value) => _name = value,
      decoration: buildInputDecoration("Name", Icons.text_fields),
    );

    final emailField = TextFormField(
      autofocus: false,
      validator: validateEmail,
      onSaved: (value) => _email = value,
      decoration: buildInputDecoration("Email", Icons.email),
    );

    final passwordField = TextFormField(
      autofocus: false,
      obscureText: true,
      validator: (value) => value.isEmpty ? "Please enter password" : null,
      onSaved: (value) => _password = value,
      decoration: buildInputDecoration("Password", Icons.lock),
    );

    final confirmPassword = TextFormField(
      autofocus: false,
      validator: (value) => value.isEmpty ? "Your password is required" : null,
      // : (value != _password ? "Passwords Don't Match" : null),
      onSaved: (value) => _confirmPassword = value,
      obscureText: true,
      decoration: buildInputDecoration("Confirm password", Icons.lock),
    );

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Registering ... Please wait")
      ],
    );

    final forgotLabel = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        FlatButton(
          padding: EdgeInsets.all(0.0),
          child: Text("Forgot password?",
              style: TextStyle(fontWeight: FontWeight.w300)),
          onPressed: () {},
        ),
        FlatButton(
          padding: EdgeInsets.only(left: 0.0),
          child: Text("Sign in", style: TextStyle(fontWeight: FontWeight.w300)),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
      ],
    );

    var doRegister = () {
      final form = formKey.currentState;
      if (form.validate()) {
        form.save();
        auth.register(_name, _email, _password).then((response) {
          print("Registering-2");
          if (response['status']) {
            print("Registering-3");
            User user = response['user'];
            Provider.of<UserProvider>(context, listen: false).setUser(user);
            Navigator.pushReplacementNamed(context, '/dashboard');

            print("Registering-4");
            Flushbar(
              title: "Registered Successfully",
              message: response.toString(),
              duration: Duration(seconds: 5),
            ).show(context);
          } else {
            Flushbar(
              title: "Registration Failed",
              message: response.toString(),
              duration: Duration(seconds: 5),
            ).show(context);
          }
        });
      } else {
        Flushbar(
          title: "Invalid form",
          message: "Please Complete the form properly",
          duration: Duration(seconds: 5),
        ).show(context);
      }
    };

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(50.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 120.0),
                  label("Name"),
                  SizedBox(height: 10.0),
                  nameField,
                  SizedBox(height: 15.0),
                  label("Email"),
                  SizedBox(height: 10.0),
                  emailField,
                  SizedBox(height: 15.0),
                  label("Password"),
                  SizedBox(height: 10.0),
                  passwordField,
                  SizedBox(height: 15.0),
                  label("Confirm Password"),
                  SizedBox(height: 10.0),
                  confirmPassword,
                  SizedBox(height: 20.0),
                  auth.registeredInStatus == Status.Registering
                      ? loading
                      // : ElevatedButton(
                      //     style:
                      //         ElevatedButton.styleFrom(onPrimary: Colors.green),
                      //     onPressed: doRegister,
                      //     child: Text("Sign Up"),
                      //   ),
                      : longButtons("Register", doRegister),
                  SizedBox(height: 10.0),
                  forgotLabel
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void onError(String error) {
    // implement onError
    print("Register Error");
  }

  @override
  void onSuccess(User authUser) {
    // implement onSuccess

    UserPreferences().saveUser(authUser);
    print("Registered Successfully");
  }
}
