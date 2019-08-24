
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' show get;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Data {
  final String nama,alamat,tahun,warna,rangka,mesin,merk,nopol,user;

  Data ({
    this.alamat,
    this.nama,
    this.tahun,
    this.rangka,
    this.warna,
    this.mesin,
    this.merk,
    this.nopol,
    this.user
  });

factory Data.fromJson(Map<String, dynamic> jsonData){
  return Data(
    nama: jsonData['nama'],
    alamat: jsonData['alamat'],
    tahun: jsonData['tahun'],
    rangka: jsonData['rangka'],
    warna: jsonData['warna'],
    mesin: jsonData['mesin'],
    merk: jsonData['merk'],
    nopol: jsonData['nopol'],
    user: jsonData['owner'],
  );
 }
}

Future<List<Data>> downloadJSON(uniq) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String a = sharedPreferences.getString("username");
    String s = '';
    if (uniq != null){
      s = await uniq;
    }

    print(a);
    
    final jsonEndPoint = 
    "http://192.168.100.9:8080/run/list.php?own=" + s;
    print(jsonEndPoint);

    final response = await get(jsonEndPoint);

    if(response.statusCode == 200){
      List data = json.decode(response.body);
      return data 
        .map((data) => new Data.fromJson(data))
        .toList();
    }else{
    throw Exception('Error');
  }
  }

class CustomListView extends StatelessWidget {
  final List<Data> data;

  CustomListView(this.data);

  Widget build(context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, int currentIndex) {
        return createViewItem(data[currentIndex], context);
      },
    );
  }

  Widget createViewItem(Data data, BuildContext context) {
    return new ListTile(
        title: new Card(
          elevation: 5.0,
          child: new Container(
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.all(20.0),
            child: Row(children: <Widget>[
              Padding(padding: EdgeInsets.symmetric(horizontal:10.0),
              child: Text(data.merk, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),)),
              Text('|', style: TextStyle(fontSize: 20.0),),
              Padding(padding: EdgeInsets.symmetric(horizontal:10.0),
              child: Text(data.nopol, style:TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0)),)
            ],)),
        ),
        onTap: () {
          //We start by creating a Page Route.
          //A MaterialPageRoute is a modal route that replaces the entire
          //screen with a platform-adaptive transition.
          var route = new MaterialPageRoute(
            builder: (BuildContext context) =>
            new SecondScreen(value: data),
          );
          //A Navigator is a widget that manages a set of child widgets with
          //stack discipline.It allows us navigate pages.
          Navigator.of(context).push(route);
        });
  }
}

//Future is n object representing a delayed computation

class SecondScreen extends StatefulWidget {
  final Data value;

  SecondScreen({Key key, this.value}) : super(key: key);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('Detail Page')),
      body: new Container(
        child: new Center(
          child: Column(
            children: <Widget>[
              Padding(
                child: new Text(
                  'DETAIL',
                  style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),
                  textAlign: TextAlign.center,
                ),
                padding: EdgeInsets.symmetric(vertical: 20.0),
              ),
              Padding(
                padding: EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                  Row(children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                          Text('Nama Pemilik', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                          Text(widget.value.nama)
                        ],),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                          Text('Nomor Polisi', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                          Text(widget.value.nopol)
                        ],),
                      ),
                    )
                  ],),
                  Padding(padding: EdgeInsets.only(top: 30.0),
                  child: Row(children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                          Text('Warna Kendaraan', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                          Text(widget.value.warna)
                        ],),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                          Text('Merk Kendaraan', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                          Text(widget.value.merk)
                        ],),
                      ),
                    )
                  ],),),

                  Padding(padding: EdgeInsets.only(top: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Alamat', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                    Text(widget.value.alamat)
                  ],),),

                  Padding(padding: EdgeInsets.only(top: 30.0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Nomor Rangka', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                    Text(widget.value.rangka)
                  ],),),

                  Padding(padding: EdgeInsets.only(top: 30.0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Nomor Mesin', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                    Text(widget.value.mesin)
                  ],),)
                  
                ],)
              ),
            ],   ),
        ),
      ),
    );
  }
}

class CarListFragment extends StatelessWidget{
  CarListFragment(this.username);
  final String username;

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      body: new Center(
        child: new FutureBuilder<List<Data>>(
          future: downloadJSON(username),
          builder: (context, snapshot){
            if(snapshot.hasData){
              List<Data> data =snapshot.data;
              return new CustomListView(data);
            }else if(snapshot.error){
              return Text('${snapshot.error}');
            }
            return new CircularProgressIndicator();
          },)
      ),
    );
  }
}