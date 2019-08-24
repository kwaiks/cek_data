import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' show get;
import 'dart:convert';
import 'package:qrcode_reader/qrcode_reader.dart';


class Mobil {
  final String nama,alamat,tahun,warna,rangka,mesin,merk,nopol,user;

  Mobil ({
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

factory Mobil.fromJson(Map<String, dynamic> jsonData){
  return Mobil(
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

Future<List<Mobil>> downloadJSON(uniq) async {
    String s = "";
    if (uniq != null){
      s = await uniq;
    }
    
    final jsonEndPoint = 
    "http://192.168.100.9:8080/run/makanan.php?uniq=" + s;
    print(jsonEndPoint);

    final response = await get(jsonEndPoint);

    if(response.statusCode == 200){
      List mobil = json.decode(response.body);
      return mobil 
        .map((mobil) => new Mobil.fromJson(mobil))
        .toList();
    }else{
    throw Exception('Error');
  }
  }


  class CustomListView extends StatelessWidget {
  final List<Mobil> mobil;
  final String username;
  CustomListView(this.mobil,this.username);

  Widget build (BuildContext context){
    return ListView.builder(
      itemCount: mobil.length,
      itemBuilder: (context, int currentIndex){
        return createViewItem(mobil[currentIndex], context);
      },
    );
  }

  Widget createViewItem(Mobil mobil, BuildContext context){
    if(mobil.user == username){
      return Card(margin: EdgeInsets.all(20.0),
      child: Padding(
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
                Text(mobil.nama)
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
                Text(mobil.nopol)
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
                Text(mobil.warna)
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
                Text(mobil.merk)
              ],),
            ),
          )
        ],),),

        Padding(padding: EdgeInsets.only(top: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Alamat', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          Text(mobil.alamat)
        ],),),

        Padding(padding: EdgeInsets.only(top: 30.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Nomor Rangka', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          Text(mobil.rangka)
        ],),),

        Padding(padding: EdgeInsets.only(top: 30.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Nomor Mesin', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          Text(mobil.mesin)
        ],),)
        
      ],)
    ),);
    }else{
      return Card(margin: EdgeInsets.all(20.0),
      child: Padding(
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
                Text(mobil.nama)
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
                Text(mobil.nopol)
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
                Text(mobil.warna)
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
                Text(mobil.merk)
              ],),
            ),
          )
        ],),),
        ],)
    ),);
    }
  }}



class HomeFragment extends StatefulWidget{
  HomeFragment({Key key, this.username, this.name}): super(key:key);
  final String username;
  final String name;
  final Map<String, dynamic> pluginParameters = {
  };
  @override
  State<StatefulWidget> createState(){
    return new HomeFragmentState();
  }
}

class HomeFragmentState extends State<HomeFragment>{
  Future<String> _barcodeString;
  @override
  Widget build(BuildContext context){
    return new Scaffold(
      body: new Container(
        child: new FutureBuilder<List<Mobil>>(
          future:downloadJSON(_barcodeString),
          builder: (context, snapshot){
            if(_barcodeString == null){
              return new Center(
                child: Column(children: <Widget>[
                  Icon(Icons.search, size: 50.0, color: Colors.blueAccent,),
                  Text('Silahkan Tekan Tombol dibawah untuk scan Barcode')
                ],)
              );
            }else if(snapshot.hasData){
              List<Mobil> mobil =snapshot.data;
              return new CustomListView(mobil,widget.username);
            }else if(snapshot.hasError){
              return Text('${snapshot.error}');
            }
            return new CircularProgressIndicator();
          }
          ,
        ),
      ),
      floatingActionButton: new FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            _barcodeString = new QRCodeReader()
                .setAutoFocusIntervalInMs(200)
                .setForceAutoFocus(true)
                .setTorchEnabled(true)
                .setHandlePermissions(true)
                .setExecuteAfterPermissionGranted(true)
                .scan();
          },
          );},
          icon: new Icon(Icons.add_a_photo),
          label: new Text('Scan a Barcode'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}