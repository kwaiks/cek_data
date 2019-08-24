import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';


String username ='';
String name='';
class LoginPage extends StatefulWidget{
  @override
  LoginPageState createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage>{

  TextEditingController user = new TextEditingController();
  TextEditingController pass = new TextEditingController();

  bool checkValue =false;

  SharedPreferences sharedPreferences;

  bool alreadyLogin = false;

  String msg = '';

  Future<List> _login() async{
    final response = await http.post("http://192.168.100.9:8080/run/log.php", body: {
    "username": user.text,
    "password": pass.text
    });

    var datauser = json.decode(response.body);

    if(datauser.length==0){
      setState((){
        msg="Username atau Password Salah !";
      });
    }else{
      if(datauser[0]['level']=='member'){
        final prefs = await SharedPreferences.getInstance();
        setState(() {
          alreadyLogin = true;
          prefs.setBool('login', alreadyLogin);
        });
        Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(
            builder: (BuildContext context) => new HomePage(username:username, name:name)
          ), (Route<dynamic> route) => false);
      }

      setState((){
        username =datauser[0]['username'];
        name =datauser[0]['name'];
      });
    }
    return datauser;
  }

  Future<bool> getLoginStatus() async{
    final prefs = await SharedPreferences.getInstance();
    bool loginStatus = prefs.getBool('login') ?? false;
    print('login status $loginStatus');
    return loginStatus;
  }

  @override
  void initState() {
    super.initState();
    getCredential();
  }

  @override
  Widget build(BuildContext context){
    return FutureBuilder<bool>(
      future:getLoginStatus(),
      builder:(context, snapshot){
        return (snapshot.data) ?
        new HomePage(username:username, name:name):
        loginForm();
      }
    );
  }

  loginForm(){
    return new Scaffold(
      body: Container(
        padding: EdgeInsets.all(40.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Text("Username",style: TextStyle(fontSize: 18.0),),
              TextField(   
                controller: user,                
                decoration: InputDecoration(
                  hintText: 'Username'
                ),           
                ),
              Text("Password",style: TextStyle(fontSize: 18.0),),
              TextField(  
                controller: pass,  
                obscureText: true,                
                 decoration: InputDecoration(
                  hintText: 'Password'
                ),                
                ),
              new CheckboxListTile(
                value: checkValue,
                onChanged: _onChanged,
                title: new Text("Remember me"),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              
              RaisedButton(
                child: Text("Login"),
                onPressed: (){
                  _login();
                },
              ),

              Text(msg,style: TextStyle(fontSize: 20.0,color: Colors.red),)
             

            ],
          ),
        ),
      ),
    
    );
  }
  _onChanged(bool value) async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      checkValue = value;
      sharedPreferences.setBool("check", checkValue);
      sharedPreferences.setString("username", user.text);
      sharedPreferences.setString("password", pass.text);
      sharedPreferences.commit();
      getCredential();  
    });
  }

  getCredential() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      checkValue = sharedPreferences.getBool("check");
      if (checkValue != null) {
        if (checkValue) {
          user.text = sharedPreferences.getString("username");
          pass.text = sharedPreferences.getString("password");
        } else {
          user.clear();
          pass.clear();
          sharedPreferences.clear();
        }
      } else {
        checkValue = false;
      }
    });
  }

}