import 'package:flutter/material.dart';
import 'package:cek_data/fragments/home_fragment.dart';
import 'package:cek_data/fragments/car_list.dart';
import 'package:cek_data/fragments/profile.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class HomePage extends StatefulWidget{

  HomePage({Key key, this.username, this.name}) : super(key: key);

  final String username;

  final String name;

  final drawerItems = [
    new DrawerItem("Beranda", Icons.home),
    new DrawerItem("Mobilku", Icons.directions_car)
  ];

  @override
  State<StatefulWidget> createState(){
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {

  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos){
    switch (pos){
      case 0:
        return new HomeFragment(username:username, name:name);
      case 1:
        return new CarListFragment(username);
      
      default:
        return new Text("Error");
    }
  }

  _onSelectedItem(int index){
    setState(()=> _selectedDrawerIndex = index);
    Navigator.of(context).pop();
  }
  @override
  Widget build(BuildContext context){
    var drawerOptions = <Widget>[];
    for (var i = 0; i<widget.drawerItems.length; i++){
      var d = widget.drawerItems[i];
      drawerOptions.add(
        new ListTile(
          leading: new Icon(d.icon),
          title: new Text(d.title),
          selected: i ==_selectedDrawerIndex,
          onTap: () => _onSelectedItem(i)
        ),
      );
    }
    drawerOptions.add(
      new ListTile(
        leading: new Icon(Icons.reply),
        title: new Text('Keluar'),
        onTap: () async {
                // hapus shared prefs login
                final prefs = await SharedPreferences.getInstance();
                prefs.remove('login');
                // redirect page/route ke login
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              }
    ));


    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.drawerItems[_selectedDrawerIndex].title),
      ),
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            new Column(
              children:drawerOptions, 
            )
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}