import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' as math;
import '../cardView.dart';
import '../Form/Edit/EditProject.dart';
import '../Form/APIDelete.dart' as APIDel;


//=================== MODEL DATA ===================================================
class data_projects{
  String ID;
  String name_prj;
  String start_date;
  String end_date;
  String desc;
  String company;

  data_projects({required this.ID, required this.name_prj, required this.start_date, required this.end_date, required this.desc, required this.company});
  factory data_projects.dataFromJson(Map<String, dynamic> map){
    return data_projects(ID:map["ID"], name_prj: map["project_name"], start_date: map["start_date"], end_date: map["end_date"], desc: map["description"], company: map["company"]);
  }

// Map<String, dynamic> toJson(){
//   return {"ID": ID, "name_prj":name_prj, "start_date":start_date, "end_date":end_date, "decs":desc, "company":company};
// }

// @override
// String toString(){
//   return 'data_projects(ID:$ID, name_prj: $name_prj, start_date: $start_date, end_date: $end_date, desc: $desc, company: $company)';
// }

}

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
  factory data_members.dataFromJson_m(Map<String, dynamic> map){
    String pp = "";
    if (map["profile"] == "-"){
      pp = "https://my-todolist-restapi.herokuapp.com/media/default.jpg";
    }else{
      pp = "https://my-todolist-restapi.herokuapp.com/media/"+map["profile"];
    }
    // print(map["ID"]);
    // print(map["first_name"]);
    // print(map["last_name"]);
    // print(map["full_name"]);
    // print(map["username"]);
    // print(map["password"]);
    // print( map["telp_number"]);
    // print(map["profile"]);
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

  data_tasks({required this.ID, required this.task_name, required this.start_task,
    required this.end_task, required this.desc, required this.prj_name, required this.status});

  factory data_tasks.dataFromJson_t(Map<String, dynamic> map){
    return data_tasks(ID: map["ID"], task_name: map["task_name"], start_task: map["start_task"], end_task: map["end_task"], desc: map["description"], prj_name: map["FK_Projects"], status: map["status"]);
  }
}

List<data_projects> dataFromJson(String JsonData){
  final data = json.decode(JsonData);
  return List<data_projects>.from(data.map((item)=>data_projects.dataFromJson(item)));
}

List<data_members> dataFromJson_m(String JsonData){
  final data = json.decode(JsonData);
  return List<data_members>.from(data.map((item)=>data_members.dataFromJson_m(item)));
}

List<data_tasks> dataFromJson_t(String JsonData){
  final data = json.decode(JsonData);
  return List<data_tasks>.from(data.map((item)=>data_tasks.dataFromJson_t(item)));
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

  Future<List<data_projects>> getDataIndex() async{
    final response = await http.get(Uri.parse(url));
    print("Response API :");
    print(response);
    print("===============atas==================");
    if (response.statusCode == 200){
      print(response.body.toString());
      print("==============bawah================");
      return dataFromJson(response.body);
    }
    else{
      return [];
    }
  }

  Future<List<data_members>> getDataIndex_m() async{
    final response = await http.get(Uri.parse(url));
    print("Response API :");
    print(response);
    print("===============atas m==================");
    if (response.statusCode == 200){
      print(response.body.toString());
      print("==============bawah m================");
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
    print("===============atas t==================");
    if (response.statusCode == 200){
      print(response.body.toString());
      print("===============bawah t===============");
      return dataFromJson_t(response.body.toString());
    }
    else{
      return [];
    }
  }
}

//================================================================================

//============== KELAS UTAMA RETURN CONTAINER KE HOME PAGE =======================
class Project_details extends StatelessWidget {
  Project_details({
    required this.url, required this.url1, required this.url2, required this.idLogin
  });

  final String url;
  final String url1;
  final String url2;
  final String idLogin;

  @override
  Widget build(BuildContext context) {
    // ApiService(url: url).getDataIndex().then((value) => print("value:$value"));
    print("cek container 1");
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Project"),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                      builder: (context) => EditProjectState(
                        url: url,
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

                  String urlCopy = url;
                  String url_del = "https://my-todolist-restapi.herokuapp.com/project_data_process.php?delete="+urlCopy.split("data=")[1];
                  print(url_del);
                  APIDel.APIService(Url: url_del, context: context).delData();
                  Navigator.pop(context,true);

                },
                child: Icon(
                  Icons.delete,
                  size: 26.0,
                ),
              )
          ),
        ],),
      body: ListView(
        children: [
          Container(
              child: FutureBuilder(
                future: new ApiService(url: url).getDataIndex(),
                builder: (BuildContext context, AsyncSnapshot<List<data_projects>> snapshot){
                  if (snapshot.hasError){
                    return Center(
                      child: Text("Ada kesalahan : ${snapshot.error}"),
                    );
                  }else if (snapshot.connectionState == ConnectionState.done){
                    List<data_projects> projects = [];
                    for (var i = 0; i<snapshot.data!.length; i++){
                      projects.add(snapshot.data![i]);
                    }
                    // print("Print list data : ");
                    // print(projects);
                    return _buildListView(list: projects,);
                  }
                  return Center(child:CircularProgressIndicator());
                  // return Text("data");
                },
              )
          ),
          FutureBuilder(
            future: new ApiService(url: url1).getDataIndex_t(),
            builder: (BuildContext context, AsyncSnapshot<List<data_tasks>> snapshot){
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
                return _buildListView_t(list: tasks, idLogin: idLogin);
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
                Text("Daftar Anggota Project",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      fontFamily: "Times",
                      color: Colors.black,
                    )),
              ],
            ),),

          FutureBuilder(
            future: new ApiService(url: url2).getDataIndex_m(),
            builder: (BuildContext context, AsyncSnapshot<List<data_members>> snapshot){
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
              // print(snapshot);
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
        itemBuilder: (context, index){
          // int val_color = (math.Random().nextDouble()*0xFFFFFF).toInt();
          return cardView(name: "" +"\n("+list[index].full_name+")", icon: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),child: Image.network(list[index].profile, width: 120,
            height: 120,)), f_date: "", l_date: "", color: Colors.lightBlueAccent, textColor: Colors.black,
            addVar1: list[index].usr_namw, addVar2: list[index].phone, addVar3: list[index].ID,
            view_for: "users", idLogin: idLogin,);
          // return Text(list[index].full_name);
        },
      ),
    );
  }
}

class _buildListView extends StatelessWidget {

  List <data_projects> list;

  _buildListView({required this.list});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(2.0),
        margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0, bottom: 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.all(5.0)),
            Text("Nama Project : "+ list[0].name_prj+"\n",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20.0,
                  fontFamily: "Times",
                  color: Colors.black,

                )),
            Text("Tanggal Mulai : "+list[0].start_date+"\n",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20.0,
                  fontFamily: "Times",
                  color: Colors.black,

                )),
            Text("Deadline : "+list[0].end_date+"\n",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20.0,
                  fontFamily: "Times",
                  color: Colors.black,

                )),
            Text("Company  : "+list[0].company+"\n",
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
            Text("Daftar Tugas Project",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  fontFamily: "Times",
                  color: Colors.black,
                ))
          ],)
    );
  }
}

class _buildListView_t extends StatelessWidget {

  List <data_tasks> list;
  final String idLogin;
  _buildListView_t({required this.list, required this.idLogin});

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
            return cardView(name: "" +"\n("+list[index].task_name+")", icon: Icon(Icons.task_alt),
              f_date: list[index].start_task, l_date: list[index].end_task, color: Colors.white,
              textColor: Colors.black, addVar1: list[index].desc, addVar3: list[index].ID,
              view_for: "task", idLogin: idLogin,);
          }
      ),
    );
  }
}
//===================================================================================