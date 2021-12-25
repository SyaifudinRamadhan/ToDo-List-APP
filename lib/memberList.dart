
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

import 'package:flutter_app_test/Home.dart';
import 'package:flutter_app_test/cardView.dart';

//======================= MODEL DATA ============================================
class data_members{
  String f_name;
  String ID;
  String l_name;
  String full_name;
  String usr_namw;
  String password;
  String phone;
  String prj_name;
  String profile;

  data_members({required this.ID, required this.f_name, required this.l_name,
    required this.full_name, required this.usr_namw, required this.password,
    required this.phone, required this.prj_name, required this.profile});

  //  Mengambil data text berupa JSON di API ke dalam objek class ini (factory agar tidak objeknya tetap sama)
  // Mengubah dataMAP JSON menjadi variabel yang dipassing ke objek class ini
  factory data_members.dataFromJson(Map<String, dynamic> map){
    String pp = "";
    if (map["profile"] == "-"){
      pp = "https://my-todolist-restapi.herokuapp.com/media/default.jpg";
    }else{
      pp = "https://my-todolist-restapi.herokuapp.com/media/"+map["profile"];
    }
    return data_members(ID: map["ID"], f_name: map["first_name"], l_name: map["last_name"], full_name: map["full_name"], usr_namw: map["username"], password: map["password"], phone: map["telp_number"], prj_name: map["0"], profile: pp);
  }

// Mengubah data varibel menjadi JSON kembali jika perlu
// Map<String, dynamic> toJson(){
//   return { "ID":ID, "task_name":task_name, "start_task":start_task, "end_task":end_task, "desc":desc };
// }

// Mengubah data variabell menjasi string jika diperlukan
// String toString(){
//   return 'data_members(ID: $ID, task_name: $task_name, start_task: $start_task, end_task: $end_task, desc: $desc)';
// }

}

// Membuat list JSON file berdasar model data (Model data sebagai kontroller pengambil JSON dari API
List<data_members> dataJson(String JsonData){
  final data = json.decode(JsonData);
  // Memanggil object model data untuk mengambil data dari API
  return List<data_members>.from(data.map((item)=>data_members.dataFromJson(item)));
}

// Membuat data variabel menjadi data json
// Jika perlu
// String dtataToJson(data_members data){
//   final jsonData = data.toJson();
//   return jsonData;
// }

//=======================================================================================
//============================ API Connector ============================================
class APIService{

  Future<List<data_members>> getDataIndex(String idLogin) async{
    print("Masuk API task list");
    final response = await http.get(Uri.parse("https://my-todolist-restapi.herokuapp.com/view_members.php?id_login="+idLogin));
    print("Response API tasks : ");
    print(response.statusCode);
    if (response.statusCode == 200){
      // print(jsonDecode(response.body));
      print(response.body);
      return dataJson(response.body);
    }else{
      return [];
    }
  }
}

//=====================================================================================

//=========================== KELAS UTAMA RETURN CONTINER KE HOME =======================
class MemberList extends StatelessWidget {
  const MemberList({Key? key, required this.idLogin}) : super(key: key);
  final String idLogin;
  @override
  Widget build(BuildContext context) {
    print("Masuk task list");
    return Container(
      child: FutureBuilder(
          future: APIService().getDataIndex(idLogin),
          builder: (BuildContext context, AsyncSnapshot<List<data_members>> snapshot){
            if (snapshot.hasError){
              return Center(
                  child: Text("Ada kesalahan : ${snapshot.error}")
              );
            }else if (snapshot.connectionState == ConnectionState.done){
              List<data_members> tasks = [];
              List<String> membersName = [];
              for (var i = 0; i<snapshot.data!.length; i++){
                tasks.add(snapshot.data![i]);
                membersName.add(tasks[i].full_name);
              }
              print("Print list data : ");
              print(tasks);
              return buildList(list: tasks,membersName: membersName, idLogin: idLogin,);
            }
            return Center(child: CircularProgressIndicator(),);
          }
      ),
    );
  }
}

//======================================================================================

//============================ Membangun search ========================================
class buildList extends StatefulWidget {
  const buildList({Key? key, required this.list, required this.membersName, required this.idLogin}) : super(key: key);
  final List<data_members> list;
  final List<String> membersName;
  final String idLogin;

  @override
  _buildListState createState() => _buildListState();
}

class _buildListState extends State<buildList> {

  TextEditingController _textController = new TextEditingController();

  List<data_members> list = [];
  List<String> membersName = [];
  bool indicator = false;

  onItemChanged(String value){
    setState(() {
      membersName = widget.membersName
          .where((string) => string.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
    list = [];
    //clening kunci nama anggota
    List<String> key = [];
    for (int i=0; i<membersName.length; i++){
      int same = 0;
      for (int j=0; j<key.length; j++){
        if (key[j] == membersName[i]){
          same++;
        }
      }

      if (i == 0){
        key.add(membersName[i]);
      }else{
        if (same == 0){
          key.add(membersName[i]);
        }
      }

    }
    print("======= Kunci ==========");
    print(key);
    for (int i=0; i<key.length; i++){
      for (int j=0; j<widget.list.length; j++){
        if (widget.list[j].full_name == key[i]){
          list.add(widget.list[j]);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    if (indicator == false){
      list = widget.list;
      membersName = widget.membersName;
      indicator = true;
    }

    return Container(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: _textController,
            decoration: InputDecoration(
                labelText: "Search",
                hintText: "Cari berdasar nama atau deadline",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)))),
            onChanged: onItemChanged,
          ),
        ),
        Expanded(child: ListView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (context, index){
            print(membersName);
            return cardView(name: list[index].prj_name +"\n("+list[index].full_name+")", icon: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),child: Image.network(list[index].profile, width: 120, height: 120,)), f_date: "", l_date: "",
                color: Colors.lightBlueAccent, textColor: Colors.black, addVar1: list[index].usr_namw, addVar2: list[index].phone, addVar3: list[index].ID,
                view_for: "users", idLogin: widget.idLogin,);
          },
        ),)

      ],
    ),);
  }
}


//=====================================================================================

//==================
// class buildList extends StatelessWidget {
//
//   List <data_members> list;
//   buildList({required this.list});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child:
//     );
//   }
// }

