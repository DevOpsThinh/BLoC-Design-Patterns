import 'package:counter_app/blocs/auth/login_bloc.dart';
import 'package:counter_app/services/authentication.dart';
import 'package:flutter/material.dart';

///------------------------------------------------------------------
/// Topic: Flutter - Dart
/// Author: Nguyen Truong Thinh
/// Created At: 28/ 4/ 2023
///------------------------------------------------------------------

/// Class's document:
/// The  Login Page
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  late LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();

    _loginBloc = LoginBloc(AuthenticationService());
  }

  Widget _buildLoginAndCreateAccountButtons() {
    return StreamBuilder(
      initialData: "Login",
      stream: _loginBloc.loginOrCreateButton,
      builder: ((BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == "Login") {
          return _buttonsLogin();
        } else if (snapshot.data == "Create Account") {
          return _buttonsCreateAccount();
        } else {
          return const Text("Something went wrong!");
        }
      }),
    );
  }

  Column _buttonsLogin() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        StreamBuilder(
            initialData: false,
            stream: _loginBloc.enableLoginCreateButton,
            builder: (BuildContext context, AsyncSnapshot snapshot) =>
                TextButton(
                    onPressed: () {
                      snapshot.data
                          ? () => _loginBloc.loginOrCreateChanged.add("Login")
                          : null;
                      // Navigator.pop(context, xxx);
                    },
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        elevation: 16.0,
                        backgroundColor: Colors.lightGreen.shade200,
                        disabledBackgroundColor: Colors.grey.shade100),
                    child: const Text("Login"))),
        TextButton(
            onPressed: () {
              _loginBloc.loginOrCreateButtonChanged.add("Create Account");
              // Navigator.pop(context, xxx);
            },
            style: TextButton.styleFrom(
                foregroundColor: Colors.black, elevation: 0.0),
            child: const Text("Create Account"))
      ],
    );
  }

  Column _buttonsCreateAccount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        StreamBuilder(
            initialData: false,
            stream: _loginBloc.enableLoginCreateButton,
            builder: (BuildContext context, AsyncSnapshot snapshot) =>
                TextButton(
                    onPressed: () {
                      snapshot.data
                          ? () => _loginBloc.loginOrCreateChanged
                              .add("Create Account")
                          : null;
                      // Navigator.pop(context, xxx);
                    },
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        elevation: 16.0,
                        backgroundColor: Colors.lightGreen.shade200,
                        disabledBackgroundColor: Colors.grey.shade100),
                    child: const Text("Create Account"))),
        TextButton(
            onPressed: () {
              _loginBloc.loginOrCreateButtonChanged.add("Login");
              // Navigator.pop(context, xxx);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              elevation: 0.0,
            ),
            child: const Text("Login"))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: Icon(
            Icons.account_circle,
            size: 88.0,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              StreamBuilder(
                stream: _loginBloc.email,
                builder: (BuildContext context, AsyncSnapshot snapshot) =>
                    TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: "Email Address",
                      icon: const Icon(Icons.mail_outline),
                      errorText: snapshot.error.toString()),
                  onChanged: _loginBloc.emailChanged.add,
                ),
              ),
              StreamBuilder(
                stream: _loginBloc.password,
                builder: (BuildContext context, AsyncSnapshot snapshot) =>
                    TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: "Password",
                      icon: const Icon(Icons.security),
                      errorText: snapshot.error.toString()),
                  onChanged: _loginBloc.passwordChanged.add,
                ),
              ),
              const SizedBox(height: 48.0),
              _buildLoginAndCreateAccountButtons(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }
}
