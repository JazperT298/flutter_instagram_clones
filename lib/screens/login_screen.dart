import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/screens/signup_screen.dart';
import 'package:flutter_instagram_clone/services/auth_service.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {

  static final String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _saving = false;
  final _formKey = GlobalKey<FormState>();
  String _email, _password;

  _submit() {
    setState(() {
      _saving = true;
    });
    if (_formKey.currentState.validate()){
      
       new Future.delayed(new Duration(seconds: 5), () {
        setState(() {
          _saving = false;
          _formKey.currentState.save();
          print(_email);
          print(_password);
          AuthService.login(_email, _password);       
        });
      });

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD( 
        inAsyncCall: _saving,
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Instagram',
                  style: TextStyle(
                    fontSize: 50.0,
                    fontFamily: 'Billabong'),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 10.0,
                       ),
                       child:  TextFormField(
                        decoration: InputDecoration(labelText: 'Email'),
                        validator: (input) => !input.contains('@') ? 'Please enter a valid email' : null,
                        onSaved: (input) => _email = input,
                      ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 10.0,
                       ),
                       child:  TextFormField(
                        decoration: InputDecoration(labelText: 'Password'),
                        validator: (input) => input.length < 6 ? 'Password be at least 6 characters' : null,
                        onSaved: (input) => _password = input,
                        obscureText: true,
                      ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        width: 250.0,
                        child: FlatButton(
                          onPressed: _submit,
                          color: Colors.blue,
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Login', 
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              ),
                          ),
                        ),
                      ),
                       Container(
                        width: 250.0,
                        child: FlatButton(
                          onPressed: () => Navigator.pushNamed(context, SignupScreen.id),
                          color: Colors.blue,
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Go to Signup', 
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      
    );
  }
}