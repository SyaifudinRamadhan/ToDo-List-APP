// ignore: file_names
import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/main.dart';
import './cardView.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' as math;


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

List<data_projects> dataFromJson(String JsonData){
  final data = json.decode(JsonData);
  return List<data_projects>.from(data.map((item)=>data_projects.dataFromJson(item)));
}

// String dataToJson(data_projects data){
//   final jsonData = data.toJson();
//   return json.encode(jsonData);
// }

//===================================================================================
//=============== API CONNECTOR =====================================================

class ApiService {

  Future<List<data_projects>> getDataIndex(String idLogin) async{
    final response = await http.get(Uri.parse("https://my-todolist-restapi.herokuapp.com/index.php?id_login="+idLogin)).timeout(Duration(minutes: 60));
    print("Response API :");
    print(response);
    print("=================================");
    if (response.statusCode == 200){
      return dataFromJson(response.body);
    }
    else{
      return [];
    }
  }
}

//================================================================================

//============== KELAS UTAMA RETURN CONTAINER KE HOME PAGE =======================
class HomeContent extends StatelessWidget {
  const HomeContent({Key? key, required this.idLogin}) : super(key: key);
  final String idLogin;
  @override
  Widget build(BuildContext context) {
    print("IdLogin "+idLogin);
    ApiService().getDataIndex(idLogin).then((value) => print("value:$value"));
    return Container(
        child: FutureBuilder(
          future: ApiService().getDataIndex(idLogin),
          builder: (BuildContext context, AsyncSnapshot<List<data_projects>> snapshot){
            if (snapshot.hasError){
              return Center(
                child: Text("Ada kesalahan : ${snapshot.error}"),
              );
            }else if (snapshot.connectionState == ConnectionState.done){
              List<data_projects> projects = [];
              List<String> deadlineList = [];
              List<String> nameProjects = [];
              for (var i = 0; i<snapshot.data!.length; i++){
                projects.add(snapshot.data![i]);
                deadlineList.add(projects[i].end_date);
                nameProjects.add(projects[i].name_prj);
              }
              print("Print list data : ");
              print(projects);
              List<String> dataKosong = [
                "Buah apael", "Buah Jeruk", "Buah mangga", "Macbook", "Laptop"
              ];
              return searchList(list: projects, nameProjects: nameProjects, dlList: deadlineList, idLogin: idLogin,);
            }
            return Center(child:CircularProgressIndicator());
          },
        )
    );
  }

}

//===================================================================================

//============================= Membangun search bar =================================

class searchList extends StatefulWidget {
  const searchList({Key? key, required this.list, required this.nameProjects, required this.dlList, required this.idLogin}) : super(key: key);
  final List<data_projects> list;
  final List<String> nameProjects;
  final List<String> dlList;
  final String idLogin;

  @override
  _searchListState createState() => _searchListState();
}

class _searchListState extends State<searchList> {

  TextEditingController _textController = TextEditingController();
  List<data_projects> newDataList = [];
  List<String> projectsName = [];
  List<String> deadlineList = [];
  bool indicator = false;

  onItemChanged(String value) {
    setState(() {
      projectsName = widget.nameProjects
          .where((string) => string.toLowerCase().contains(value.toLowerCase()))
          .toList();
      deadlineList = widget.dlList
          .where((string) => string.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
    //Pembersihan searching
    List<String> keyDl = [];
    List<String> keyName = [];

    for (int i=0; i<projectsName.length; i++){
      int same = 0;
      for (int j=0; j<keyName.length; j++){
        if (keyName[j] == projectsName[i]){
          same++;
        }
      }
      if (i == 0){
        keyName.add(projectsName[i]);
      }else{
        if (same == 0){
          keyName.add(projectsName[i]);
        }
      }
    }

    for (int i=0; i<deadlineList.length; i++){
      int same = 0;
      for (int j=0; j<keyDl.length; j++){
        if (keyDl[j] == deadlineList[i]){
          same++;
        }
      }
      if (i == 0){
        keyDl.add(deadlineList[i]);
      }else{
        if (same == 0){
          keyDl.add(deadlineList[i]);
        }
      }
    }
    //Komparasi length hasil search
    if (projectsName.length > deadlineList.length){
      newDataList = [];
      for (int i=0; i<keyName.length; i++){
        for (int j=0; j<widget.list.length; j++){
          if (widget.list[j].name_prj == keyName[i]){
            newDataList.add(widget.list[j]);
          }
        }
      }
    }else{
      newDataList = [];
      for (int i=0; i<keyDl.length; i++){
        for (int j=0; j<widget.list.length; j++){
          if (widget.list[j].end_date == keyDl[i]){
            newDataList.add(widget.list[j]);
          }
        }
      }
    }
    // return list_dm_new;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.list);
    if (indicator == false){
      projectsName = widget.nameProjects;
      deadlineList = widget.dlList;
      newDataList = widget.list;
      indicator = true;
    }
    return Container(
      child: Column(
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
            itemCount: newDataList.length,
            itemBuilder: (context, index){
              int val_color = (math.Random().nextDouble()*0xFFFFFF).toInt();
              print("====== LISR DUMMY ===============");
              print(projectsName);
              print(deadlineList);
              // return Container();
              return cardView(name: newDataList[index].name_prj, icon: Icon(Icons.list, size: 50,),
                f_date: newDataList[index].start_date, l_date: newDataList[index].end_date,color: Color(val_color).withOpacity(1.0),
                textColor: Colors.black, addVar1: newDataList[index].desc, addVar2: newDataList[index].company, addVar3: newDataList[index].ID,
                view_for: "home", idLogin: widget.idLogin,);
            },
          ),)


        ],
      ),
    );
  }
}


//==================================================================================

//======= MEMBANGUN LISTVIEW UNTUK DIISIKAN KE CONTAINER JIKA TIDAK ADA ERROR =======
// class _buildListView extends StatelessWidget {
//
//   List <data_projects> list;
//   _buildListView({required this.list});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//      child:
//     );
//   }
// }

//===================================================================================