import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' as math;
import '../cardView.dart';


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

List<data_projects> dataFromJson(String JsonData){
  final data = json.decode(JsonData);
  return List<data_projects>.from(data.map((item)=>data_projects.dataFromJson(item)));
}

List<data_members> dataFromJson_m(String JsonData){
  final data = json.decode(JsonData);
  return List<data_members>.from(data.map((item)=>data_members.dataFromJson(item)));
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
    print("=================================");
    if (response.statusCode == 200){
      print(response.body.toString());
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
    print("=================================");
    if (response.statusCode == 200){
      print(response.body.toString());
      return dataFromJson_m(response.body.toString());
    }
    else{
      return [];
    }
  }
}

//================================================================================

//============== KELAS UTAMA RETURN CONTAINER KE HOME PAGE =======================
class member_details extends StatelessWidget {
  member_details({
    required this.url, required this.url1, required this.idLogin
  });

  final String url;
  final String url1;
  final String idLogin;



  @override
  Widget build(BuildContext context) {
    // ApiService(url: url).getDataIndex().then((value) => print("value:$value"));
    print("cek container details members");
    return Scaffold(
      appBar: AppBar(title: Text("Deatil Member"),),
      body: ListView(
        children: [

          FutureBuilder(
            future: new ApiService(url: url).getDataIndex_m(),
            builder: (BuildContext context, AsyncSnapshot<List<data_members>> snapshot){
              print(url);
              print("=========== Cek error dimana ===========\n"+url+"\n==================================");
              if (snapshot.hasError){
                // print("============Test errornya dimana---------------\n"+snapshot.data![0].full_name);
                // int c = snapshot.data!.length;
                return Center(
                  child: Text("Ada kesalahan : ${snapshot.error}"+" ============Test errornya dimana---------------\n"),
                );
              }else if (snapshot.connectionState == ConnectionState.done){
                List<data_members> members = [];
                for (var i = 0; i<snapshot.data!.length; i++){
                  members.add(snapshot.data![i]);
                }
                // print("Print list data : ");
                // print(members);
                return _buildListView_m(list: members,);
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
                Text("Daftar Project",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      fontFamily: "Times",
                      color: Colors.black,
                    )),
              ],
            ),),

          Container(
              child: FutureBuilder(
                future: new ApiService(url: url1).getDataIndex(),
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
                    return _buildListView(list: projects, idLogin: idLogin,);
                  }
                  return Center(child:CircularProgressIndicator());
                  // return Text("data");
                },
              )
          ),
        ],
      ),
    );
  }
}

//===================================================================================


//======= MEMBANGUN LISTVIEW UNTUK DIISIKAN KE CONTAINER JIKA TIDAK ADA ERROR =======
class _buildListView extends StatelessWidget {

  List <data_projects> list;
  final String idLogin;
  _buildListView({required this.list, required this.idLogin});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (context, index){
          // int val_color = (math.Random().nextDouble()*0xFFFFFF).toInt();
          return cardView(name: list[index].name_prj, icon: Icon(Icons.list, size: 50,), 
            f_date: list[index].start_date, l_date: list[index].end_date,color: Colors.yellow.withOpacity(1.0), 
            textColor: Colors.black, addVar1: list[index].desc, addVar2: list[index].company, addVar3: list[index].ID, 
            view_for: "home", idLogin: idLogin,);
          // return Text(list[index].full_name);
        },
      ),
    );
  }
}

class _buildListView_m extends StatelessWidget {

  List <data_members> list;

  _buildListView_m({required this.list});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(2.0),
        margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0, bottom: 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.all(5.0)),
            CircleAvatar(
              backgroundImage: NetworkImage(list[0].profile),
              radius: 130,
              backgroundColor: Colors.transparent,
            ),
            Text("\n\nNama Anggota : "+ list[0].full_name+"\n",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20.0,
                  fontFamily: "Times",
                  color: Colors.black,

                )),
            Text("Username : "+list[0].usr_namw+"\n",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20.0,
                  fontFamily: "Times",
                  color: Colors.black,

                )),
            Text("No Telephone : "+list[0].phone+"\n",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20.0,
                  fontFamily: "Times",
                  color: Colors.black,

                )),
          ],)
    );
  }
}

//===================================================================================