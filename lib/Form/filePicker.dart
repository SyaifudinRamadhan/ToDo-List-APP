// ignore: file_names
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';

class testPicFile extends StatelessWidget {
  const testPicFile({Key? key}) : super(key: key);

  void openFile(PlatformFile file){
    OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: new Text("Testing pick file"),),
      body: new Container(
        child: new ElevatedButton(onPressed: () async {
          final filePick = await FilePicker.platform.pickFiles();

          if (filePick == null) return;

          final fileShow = filePick.files.first;
          openFile(fileShow);

        }, child: new Text("Choose File")),
      ),
    );
  }
}
