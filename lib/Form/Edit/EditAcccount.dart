// ignore: file_names
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../APIService.dart' as APISend;

class data_user{
  String ID;
  String f_name;
  String l_name;
  String full_name;
  String username;
  String password;
  String phone;
  String pp_name;

  data_user({required this.ID, required this.f_name, required this.l_name, required this.full_name, required this.username,
    required this.password, required this.phone, required this.pp_name});
  factory data_user.dataFromJson(Map<String, dynamic> map){
    return data_user(ID: map["ID"], f_name: map["first_name"], l_name: map["last_name"], full_name: map["full_name"], username: map["username"], password: map["password"], phone: map["telp_number"],  pp_name: map["profile"]);
  }
}

List<data_user> dataFromJson(String JsonData){
  final data = json.decode(JsonData);
  return List<data_user>.from(data.map((item)=>data_user.dataFromJson(item)));
}

class APIService{
  const APIService({required this.idLogin});
  final String idLogin;
  Future<List<data_user>> getDataIndex() async{
    String url = "https://my-todolist-restapi.herokuapp.com/user_process.php?id_login="+idLogin;
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200){
      print(response.body.toString());
      return dataFromJson(response.body);
    }else{
      return [];
    }
  }
}

class EditAccount extends StatelessWidget {
  const EditAccount({Key? key, required this.idLogin}) : super(key: key);
  final String idLogin;

  @override
  Widget build(BuildContext context) {

    APIService(idLogin: idLogin).getDataIndex().then((value) => print("value:$value"));
    return Scaffold(
        appBar: AppBar(title: Text("Edit Akun Saya"),),
        body: Container(child: FutureBuilder(future: APIService(idLogin: idLogin).getDataIndex() ,builder: (BuildContext context, AsyncSnapshot<List<data_user>> snapshot){

          if (snapshot.hasError){
            return Container(
              child: Text("Ada kesalahan : ${snapshot.error}"),
            );
          }else if (snapshot.connectionState == ConnectionState.done){
            List<data_user> list = [];
            print("====================== ID Login : "+idLogin);
            List<TextEditingController> listEdit = List.generate(8, (i) => TextEditingController());;
            for (var i=0; i<snapshot.data!.length; i++){
              list.add(snapshot.data![i]);
              listEdit[0].text = snapshot.data![i].ID;
              listEdit[1].text = snapshot.data![i].username;
              listEdit[2].text = snapshot.data![i].password;
              listEdit[3].text = snapshot.data![i].full_name;
              listEdit[4].text = snapshot.data![i].f_name;
              listEdit[5].text = snapshot.data![i].l_name;
              listEdit[6].text = snapshot.data![i].phone;
              listEdit[7].text = snapshot.data![i].pp_name;
            }
            String urlImg = "https://my-todolist-restapi.herokuapp.com/media/";
            if (list[0].pp_name == "-"){
              urlImg = "https://my-todolist-restapi.herokuapp.com/media/default.jpg";
            }else{
              urlImg += list[0].pp_name;
            }
            TextEditingController textTest = new TextEditingController();
            textTest.text = "Hallo dunia";
            print("============= Test data =============\n"+urlImg);
            return buildFormEdit(listEdit: listEdit, img:urlImg, idLogin: idLogin,);
          }
          return Center(child:CircularProgressIndicator());
        },),
        )
    );
  }
}

// ignore: camel_case_types
class buildFormEdit extends StatefulWidget {
  const buildFormEdit({Key? key, required this.listEdit, required this.img, required this.idLogin}) : super(key: key);

  // final TextEditingController textEditTest;
  final List<TextEditingController> listEdit;
  final String img;
  final String idLogin;
  @override
  _buildFormEditState createState() => _buildFormEditState();
}

class _buildFormEditState extends State<buildFormEdit> {
  // @override
  // Widget build(BuildContext context) {
  //   return Container();
  // }
  List<TextEditingController> listEdit = [];
  String img = "";
  bool indicator = false;
  File? imgShow;

  Future chooseImg(ImageSource src) async {
    try{

      final Image = await ImagePicker().pickImage(source: src);
      if (Image == null) return;

      final imgTmp = File(Image.path);
      setState((){
        this.imgShow = imgTmp;
      });

    }on PlatformException catch (e){
      print("Failed pick image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {

    if (indicator == false){
      listEdit = widget.listEdit;
      img = widget.img;
      indicator = true;
    }

    Future<void> uploadData(File? imgData, List<TextEditingController> listEdit) async {
      String url = "https://my-todolist-restapi.herokuapp.com/user_process.php?id_login="+widget.idLogin;
      String imgStr = "";
       if (imgData != null){
         List<int> imgBytes = imgData.readAsBytesSync();
          imgStr = base64Encode(imgBytes);
       }
      dynamic dataPost = {"username":listEdit[1].text, "password":listEdit[2].text, "full_name":listEdit[3].text,
        "f_name":listEdit[4].text, "l_name":listEdit[5].text, "phone":listEdit[6].text, "img_data":imgStr,
        "edit":"true", "img_ori":listEdit[7].text, "ID":listEdit[0].text};
      APISend.APIService(Url: url, bodyData: dataPost, context: context).sendData();

    }

    return Container(
      padding: EdgeInsets.all(2.0),
      margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0, bottom: 0.0),
      child: Form(child: ListView(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                inputFormatters: [
                  LengthLimitingTextInputFormatter(20)
                ],
                controller: listEdit[1],
                decoration: InputDecoration(
                    labelText: "Username",
                    hintText: "Username anda",
                    prefixIcon: Icon(Icons.people),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10)
                ],
                controller: listEdit[4],
                decoration: InputDecoration(
                    labelText: "Nama Depan",
                    hintText: "Nama depan anda",
                    prefixIcon: Icon(Icons.card_membership),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10)
                ],
                controller: listEdit[5],
                decoration: InputDecoration(
                    labelText: "Nama Belakang",
                    hintText: "Nama belakang anda",
                    prefixIcon: Icon(Icons.card_membership),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                inputFormatters: [
                  LengthLimitingTextInputFormatter(70)
                ],
                controller: listEdit[3],
                decoration: InputDecoration(
                    labelText: "Nama Lengkkap",
                    hintText: "Nama lengkap anda",
                    prefixIcon: Icon(Icons.card_membership),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                inputFormatters: [
                  LengthLimitingTextInputFormatter(17)
                ],
                controller: listEdit[6],
                decoration: InputDecoration(
                    labelText: "No Telpon",
                    hintText: "No Telpon anda",
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                inputFormatters: [
                  LengthLimitingTextInputFormatter(8)
                ],
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                controller: listEdit[2],
                decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "Ketik password anda",
                    prefixIcon: Icon(Icons.keyboard),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Visibility(
              visible: false,
              child: TextField(
                inputFormatters: [
                  LengthLimitingTextInputFormatter(17)
                ],
                controller: listEdit[0],
                decoration: InputDecoration(
                    labelText: "",
                    hintText: "",
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(12.0),
                child: imgShow != null ? Image.file(imgShow!,  width: 100, height: 100,):
                Image.network(img, width: 100, height: 100,)
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(onPressed: (){chooseImg(ImageSource.gallery);}, child: Text("Upload Foto")),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(onPressed: (){

                print("Kirim ditekan");
                if (listEdit[0].text.isEmpty || listEdit[1].text.isEmpty|| listEdit[2].text.isEmpty|| listEdit[3].text.isEmpty|| listEdit[4].text.isEmpty||
                listEdit[5].text.isEmpty|| listEdit[6].text.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tidak boleh ada yang kosong !!!')),
                  );
                }else{
                  uploadData(imgShow, listEdit);
                }

                },
                child: Text("Kirm Perubahan"),
                style: ElevatedButton.styleFrom(primary: Colors.red, onPrimary: Colors.white, shadowColor: Colors.red, elevation: 5,),),
            )

          ],)
      ],)),);
  }

}
//
//
// class buildFormEdit extends StatelessWidget {
//
// }

