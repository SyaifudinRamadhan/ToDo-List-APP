import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class APIService{

  APIService({required this.Url, required this.context});

  final String Url;
  final BuildContext context;

  List<String> confirm = [];

  Future<void> delData() async{
    var responseWait = await http.get(Uri.parse(Url));
    if (responseWait.statusCode == 200){
      print("Data terkirim");
      print(responseWait.body);
      var data = json.decode(responseWait.body);
      confirm.add("200");
      confirm.add(data["valid"]);
      confirm.add(data["sending"]);

    }else{
      //setting info error kirim data
      confirm.add("404");
      confirm.add("false");
      confirm.add("false");
      print("Satus code tidak 200 "+Url);

    }

    if (confirm[0] == "200"){
      if (confirm[1] == "true"){
        if (confirm[2] == "true"){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data dihapus')),
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

}