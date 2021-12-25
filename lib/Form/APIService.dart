// ignore: file_names
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../main.dart' as main;

class APIService{

  APIService({required this.Url, required this.bodyData, required this.context});

  final String Url;
  final dynamic bodyData;
  final BuildContext context;

  List<String> confirm = [];

  Future<void> sendData() async{
    var responseWait = await http.post(Uri.parse(Url), body: bodyData);

    // var headers = {
    //   'Cookie': 'PHPSESSID=rric68mpr13v2b29odtmul67473jnhne'
    // };
    // var request = http.MultipartRequest('POST', Uri.parse(Url));
    // request.fields.addAll(bodyData);
    //
    // request.headers.addAll(headers);

    // http.StreamedResponse response = await request.send();

    if (responseWait.statusCode == 200){
      print("Data terkirim");
      // String dataString = await response.stream.bytesToString();
      // print(dataString);
      var data = jsonDecode(responseWait.body);

      confirm.add("200");
      confirm.add(data["valid"]);
      confirm.add(data["sending"]);
      print(responseWait.body);

    }else{
      //setting info error kirim data
      confirm.add("404");
      confirm.add("false");
      confirm.add("false");
      print(bodyData);
      print("Satus code tidak 200");

    }

    if (confirm[0] == "200"){
      if (confirm[1] == "true"){
        if (confirm[2] == "true"){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data disimpan')),
          );
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kesalahan database')),
          );
        }
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data tidak valid')),
        );
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Koneksi gagal')),
      );
    }

  }

  Future<void> sendFile(List<PlatformFile>? file, String ID) async{
    var request = http.MultipartRequest('POST', Uri.parse(Url));
    request.fields['key'] = ID;
    request.files.add(await http.MultipartFile.fromPath('file', file!.first.path.toString()));
    var responseWait = await request.send();
    if (responseWait.statusCode == 200){
      print("Data terkirim untuk file");
      // print(responseWait.);
      // var data = json.decode(responseWait.body);
      confirm.add("200");
      confirm.add("true");
      confirm.add("true");
      responseWait.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });

    }else{
      //setting info error kirim data
      confirm.add("404");
      confirm.add("false");
      confirm.add("false");
      print(bodyData);
      print("Satus code tidak 200");

    }

    if (confirm[0] == "200"){
      if (confirm[1] == "true"){
        if (confirm[2] == "true"){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data disimpan')),
          );
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kesalahan database')),
          );
        }
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data tidak valid')),
        );
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Koneksi gagal')),
      );
    }

  }

  Future<void> loginSignUp() async{
    Duration timeLimit = new Duration(seconds: 300);

    var responseWait = await http.post(Uri.parse(Url),

        body: bodyData).timeout(timeLimit);
    if (responseWait.statusCode == 200){
      print("Data terkirim");
      print(responseWait.body);
      var data = json.decode(responseWait.body);
      confirm.add("200");
      confirm.add(data["valid"]);
      confirm.add(data["sending"]);
      confirm.add(data["id_login"]);
      print(responseWait.body);

    }else{
      //setting info error kirim data
      confirm.add("404");
      confirm.add("false");
      confirm.add("false");
      confirm.add("");
      print(bodyData);
      print("Satus code tidak 200 "+responseWait.statusCode.toString());
      print(responseWait.body);

      // loginSignUp();

    }

    // var request = http.MultipartRequest('POST', Uri.parse(Url));
    // request.fields.addAll(bodyData);
    //
    // http.StreamedResponse response = await request.send();
    //
    // if (response.statusCode == 200) {
    //   String dataString = await response.stream.bytesToString();
    //   // confirm.add(response.statusCode.toString());
    //   // confirm.add(json.decode(response.))
    //   // response.stream.transform(utf8.decoder).listen((value) {
    //   //   print(value);
    //   // });
    //   var data = jsonDecode(dataString);
    //   confirm.add(response.statusCode.toString());
    //   confirm.add(data["valid"]);
    //   confirm.add(data["sending"]);
    //   confirm.add(data["id_login"]);
    //   print(dataString);
    // }
    // else {
    //     confirm.add("404");
    //     confirm.add("false");
    //     confirm.add("false");
    //     confirm.add("");
    //     print(bodyData);
    //     print("Satus code tidak 200 "+response.statusCode.toString());
    //     // print(responseWait.body);
    //   print(response.reasonPhrase);
    // }

    if (confirm[0] == "200"){
      if (confirm[1] == "true"){
        if (confirm[2] == "true"){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login sukses !!!')),
          );
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => main.HomePage(id_login: confirm[3],)
              ));
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kesalahan database')),
          );
        }
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data tidak valid')),
        );
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Koneksi gagal')),
      );
    }

  }

}