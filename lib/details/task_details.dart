import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' as math;
import '../cardView.dart';
import '../Form/Edit/EditTask.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Form/APIDelete.dart' as APIDel;


//=================== MODEL DATA ===================================================

class data_members{
  String f_name;
  String ID;
  String l_name;
  String full_name;
  String usr_namw;
  String password;
  String phone;
  String profile;

  data_members({required this.ID, required this.f_name, required this.l_name,
    required this.full_name, required this.usr_namw, required this.password,
    required this.phone, required this.profile});

  //  Mengambil data text berupa JSON di API ke dalam objek class ini (factory agar tidak objeknya tetap sama)
  // Mengubah dataMAP JSON menjadi variabel yang dipassing ke objek class ini
  factory data_members.dataFromJson(Map<String, dynamic> map){
    String pp = "";
    if (map["profile"] == "-"){
      pp = "https://my-todolist-restapi.herokuapp.com/media/default.jpg";
    }else{
      pp = "https://my-todolist-restapi.herokuapp.com/media/"+map["profile"];
    }
    return data_members(ID: map["ID"], f_name: map["first_name"], l_name: map["last_name"], full_name: map["full_name"], usr_namw: map["username"], password: map["password"], phone: map["telp_number"], profile: pp);
  }
}

class data_tasks{
  String task_name;
  String ID;
  String start_task;
  String end_task;
  String desc;
  String prj_name;
  String status;
  String str_file;

  data_tasks({required this.ID, required this.task_name, required this.start_task,
    required this.end_task, required this.desc, required this.prj_name, required this.status, required
    this.str_file});

  factory data_tasks.dataFromJson(Map<String, dynamic> map){
    return data_tasks(ID: map["ID"], task_name: map["task_name"], start_task: map["start_task"], end_task: map["end_task"], desc: map["description"], prj_name: map["FK_Projects"], status: map["status"], str_file: map["3"]);
  }
}

List<data_members> dataFromJson_m(String JsonData){
  final data = json.decode(JsonData);
  return List<data_members>.from(data.map((item)=>data_members.dataFromJson(item)));
}

List<data_tasks> dataFromJson_t(String JsonData){
  final data = json.decode(JsonData);
  return List<data_tasks>.from(data.map((item)=>data_tasks.dataFromJson(item)));
}
// String dataToJson(data_projects data){
//   final jsonData = data.toJson();
//   return json.encode(jsonData);
// }

//===================================================================================
//=============== API CONNECTOR =====================================================

class ApiService {
  ApiService({
    required this.url
  });
  final String url;

  Future<List<data_members>> getDataIndex_m() async{
    final response = await http.get(Uri.parse(url));
    print("Response API :");
    print(response);
    print("=================================");
    if (response.statusCode == 200){
      print(response.body.toString());
      return dataFromJson_m(response.body);
    }
    else{
      return [];
    }
  }

  Future<List<data_tasks>> getDataIndex_t() async{
    final response = await http.get(Uri.parse(url));
    print("Response API :");
    print(response);
    print("=================================");
    if (response.statusCode == 200){
      print(response.body.toString());
      return dataFromJson_t(response.body.toString());
    }
    else{
      return [];
    }
  }
}

//================================================================================

//============== KELAS UTAMA RETURN CONTAINER KE HOME PAGE =======================
class task_details extends StatelessWidget {
  task_details({
    required this.url, required this.url1, required this.idLogin
  });

  final String url;
  final String url1;
  final String idLogin;

  @override
  Widget build(BuildContext context) {
    // ApiService(url: url).getDataIndex().then((value) => print("value:$value"));
    print("cek container 1");
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Tugas"),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditTask(
                          url: url, url2:url1,
                          idLogin: idLogin,
                        )
                    ),);

                },
                child: Icon(
                  Icons.edit,
                  size: 26.0,
                ),
              )
          ),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {

                  var urlCopy = url;
                  // urlCopy.split("data=");
                  print(urlCopy.split("data=")[1]);
                  String url_del = "https://my-todolist-restapi.herokuapp.com/task_data_process.php?delete="+urlCopy.split("data=")[1];
                  print(url_del);

                  APIDel.APIService(Url: url_del, context: context).delData();
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => task_details(
                  //           url: url, url1: url1
                  //       )
                  //   ),);
                  Navigator.pop(context,true);

                },
                child: Icon(
                  Icons.delete,
                  size: 26.0,
                ),
              )
          ),
        ],
      ),
      body: ListView(
        children: [

          FutureBuilder(
            future: new ApiService(url: url).getDataIndex_t(),
            builder: (BuildContext context, AsyncSnapshot<List<data_tasks>> snapshot){
              print(url);
              if (snapshot.hasError){
                return Center(
                  child: Text("Ada kesalahan : ${snapshot.error}"),
                );
              }else if (snapshot.connectionState == ConnectionState.done){
                List<data_tasks> tasks = [];
                for (var i = 0; i<snapshot.data!.length; i++){
                  tasks.add(snapshot.data![i]);
                }
                // print("Print list data : ");
                //print(tasks[0]);
                return _buildListView_t(list: tasks,);
              }
              return Center(child:CircularProgressIndicator());
              // return Text("data");
            },
          ),
          Padding(
            padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  color: Colors.black,
                ),
                Text("Daftar Anggota Tugas",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 20.0,
                      fontFamily: "Times",
                      color: Colors.black,
                    )),
              ],
            ),),

          FutureBuilder(
            future: new ApiService(url: url1).getDataIndex_m(),
            builder: (BuildContext context, AsyncSnapshot<List<data_members>> snapshot){
              print(url1);
              if (snapshot.hasError){
                return Center(
                  child: Text("Ada kesalahan : ${snapshot.error}"),
                );
              }else if (snapshot.connectionState == ConnectionState.done){
                List<data_members> members = [];
                for (var i = 0; i<snapshot.data!.length; i++){
                  members.add(snapshot.data![i]);
                }
                // print("Print list data : ");
                // print(members);
                return _buildListView_m(list: members, idLogin: idLogin);
              }
              return Center(child:CircularProgressIndicator());
              // return Text("data");
            },
          )
        ],
      ),
    );
  }
}

//===================================================================================


//======= MEMBANGUN LISTVIEW UNTUK DIISIKAN KE CONTAINER JIKA TIDAK ADA ERROR =======

class _buildListView_t extends StatelessWidget {

  List <data_tasks> list;


  _buildListView_t({required this.list});

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    String note = "(Data belum tersedia)";
    if (list[0].str_file != ""){
      note = "(Lampiran tersedia)";
    }
    return Container(
        padding: EdgeInsets.all(2.0),
        margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0, bottom: 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.all(5.0)),
            Text("Nama Tugas : "+ list[0].task_name+"\n",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20.0,
                  fontFamily: "Times",
                  color: Colors.black,

                )),
            Text("Tanggal Mulai : "+list[0].start_task+"\n",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20.0,
                  fontFamily: "Times",
                  color: Colors.black,

                )),
            Text("Deadline : "+list[0].end_task+"\n",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20.0,
                  fontFamily: "Times",
                  color: Colors.black,

                )),
            Text("Status : "+list[0].status+" %"+"\n",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20.0,
                  fontFamily: "Times",
                  color: Colors.black,

                )),
            Text("Deskripsi :\n\n"+list[0].desc+"\n\n",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20.0,
                  fontFamily: "Times",
                  color: Colors.black,

                )),
            Text("File Lampiran : \n"+list[0].str_file+"\n",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20.0,
                  fontFamily: "Times",
                  color: Colors.black,

                )),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.teal, onPrimary: Colors.white, shadowColor: Colors.red, elevation: 5,),
              onPressed: (){
                if ( list[0].str_file == ""){
                  print("Hello");
                }else{
                  print("ada linknya");
                  String url_open = "https://my-todolist-restapi.herokuapp.com/media/"+list[0].str_file;
                  _launchURL(url_open);
                }
              },
              child: Text("\nLihat Lampiran\n"+note+"\n",style: TextStyle(fontSize: 16,color: Colors.white, fontStyle: FontStyle.italic,), textAlign: TextAlign.center,),
            ),

          ],)
    );
  }
}

class _buildListView_m extends StatelessWidget {

  List <data_members> list;
  final String idLogin;

  _buildListView_m({required this.list, required this.idLogin});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (context, index) {
            print("Data dalam listview :\n");
            // print(list[0].prj_name);
            // return Text(list[index].task_name);
            return cardView(name: "" +"\n("+list[index].full_name+")", icon: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),child: Image.network(list[index].profile, width: 120, height: 120,)),
              f_date: "", l_date: "", color: Colors.lightBlueAccent, textColor: Colors.black, addVar1: list[index].usr_namw,
              addVar2: list[index].phone, addVar3: list[index].ID, view_for: "users", idLogin: idLogin,);
          }
      ),
    );
  }
}
//===================================================================================