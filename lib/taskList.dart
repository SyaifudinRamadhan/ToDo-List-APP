
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

import 'package:flutter_app_test/Home.dart';
import 'package:flutter_app_test/cardView.dart';

//======================= MODEL DATA ============================================
class data_task{
  String task_name;
  String ID;
  String start_task;
  String end_task;
  String desc;
  String prj_name;

  data_task({required this.ID, required this.task_name, required this.start_task,
    required this.end_task, required this.desc, required this.prj_name});

  //  Mengambil data text berupa JSON di API ke dalam objek class ini (factory agar tidak objeknya tetap sama)
  // Mengubah dataMAP JSON menjadi variabel yang dipassing ke objek class ini
  factory data_task.dataFromJson(Map<String, dynamic> map){
    return data_task(ID: map["ID"], task_name: map["task_name"], start_task: map["start_task"], end_task: map["end_task"], desc: map["description"], prj_name: map["0"]);
  }

// Mengubah data varibel menjadi JSON kembali jika perlu
// Map<String, dynamic> toJson(){
//   return { "ID":ID, "task_name":task_name, "start_task":start_task, "end_task":end_task, "desc":desc };
// }

// Mengubah data variabell menjasi string jika diperlukan
// String toString(){
//   return 'data_task(ID: $ID, task_name: $task_name, start_task: $start_task, end_task: $end_task, desc: $desc)';
// }

}

// Membuat list JSON file berdasar model data (Model data sebagai kontroller pengambil JSON dari API
List<data_task> dataJson(String JsonData){
  final data = json.decode(JsonData);
  // Memanggil object model data untuk mengambil data dari API
  return List<data_task>.from(data.map((item)=>data_task.dataFromJson(item)));
}

// Membuat data variabel menjadi data json
// Jika perlu
// String dtataToJson(data_task data){
//   final jsonData = data.toJson();
//   return jsonData;
// }

//=======================================================================================
//============================ API Connector ============================================
class APIService{

  Future<List<data_task>> getDataIndex(String idLogin) async{
    print("Masuk API task list");
    final response = await http.get(Uri.parse("https://my-todolist-restapi.herokuapp.com/view_task.php?id_login="+idLogin));
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
class TaskList extends StatelessWidget {
  const TaskList({Key? key, required this.idLogin}) : super(key: key);
  final String idLogin;
  @override
  Widget build(BuildContext context) {
    print("Masuk task list");
    return Container(
      child: FutureBuilder(
          future: APIService().getDataIndex(idLogin),
          builder: (BuildContext context, AsyncSnapshot<List<data_task>> snapshot){
            if (snapshot.hasError){
              return Center(
                  child: Text("Ada kesalahan : ${snapshot.error}")
              );
            }else if (snapshot.connectionState == ConnectionState.done){
              List<data_task> tasks = [];
              List<String> tasksName = [];
              List<String> dlTimes = [];
              for (var i = 0; i<snapshot.data!.length; i++){
                tasks.add(snapshot.data![i]);
                tasksName.add(tasks[i].task_name);
                dlTimes.add(tasks[i].end_task);
              }
              print("Print list data : ");
              // print(tasks[0].prj_name);
              return buildList(list: tasks,tasksName: tasksName, dlTimes: dlTimes, idLogin: idLogin);
            }
            return Center(child: CircularProgressIndicator(),);
          }
      ),
    );
  }
}

//======================================================================================

//============================ Membangun search =========================================
class buildList extends StatefulWidget {
  const buildList({Key? key, required this.list, required this.tasksName, required this.dlTimes, required this.idLogin}) : super(key: key);
  final List<data_task> list;
  final List<String> tasksName;
  final List<String> dlTimes;
  final String idLogin;

  @override
  _buildListState createState() => _buildListState();
}

class _buildListState extends State<buildList> {

  TextEditingController _textController = new TextEditingController();

  List<data_task> list = [];
  List<String> tasksName = [];
  List<String> dlTimes = [];
  bool indicator = false;

  onItemChanged(String value){
    setState(() {
      tasksName = widget.tasksName
          .where((string) => string.toLowerCase().contains(value.toLowerCase()))
          .toList();
      dlTimes = widget.dlTimes
          .where((string) => string.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });

    List<String> keyDl = [];
    List<String> keyName = [];

    for (int i=0; i<tasksName.length; i++){
      int same = 0;
      for (int j=0; j<keyName.length; j++){
        if (keyName[j] == tasksName[i]){
          same++;
        }
      }
      if (i == 0){
        keyName.add(tasksName[i]);
      }else{
        if (same == 0){
          keyName.add(tasksName[i]);
        }
      }
    }

    for (int i=0; i<dlTimes.length; i++){
      int same = 0;
      for (int j=0; j<keyDl.length; j++){
        if (keyDl[j] == dlTimes[i]){
          same++;
        }
      }
      if (i == 0){
        keyDl.add(dlTimes[i]);
      }else{
        if (same == 0){
          keyDl.add(dlTimes[i]);
        }
      }
    }

    if (tasksName.length > dlTimes.length){
      list = [];
      for (int i=0; i<keyName.length; i++){
        for (int j=0; j<widget.list.length; j++){
          if (widget.list[j].task_name == keyName[i]){
            list.add(widget.list[j]);
          }
        }
      }
    }else{
      list = [];
      for (int i=0; i<keyDl.length; i++){
        for (int j=0; j<widget.list.length; j++){
          if (widget.list[j].end_task == keyDl[i]){
            list.add(widget.list[j]);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    if (indicator == false){
      list = widget.list;
      tasksName = widget.tasksName;
      dlTimes = widget.dlTimes;
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
            print("============ Data pencarian ===========");
            print(tasksName);
            print(dlTimes);
            return cardView(name: list[index].prj_name +"\n("+list[index].task_name+")", icon: Icon(Icons.task_alt),
              f_date: list[index].start_task, l_date: list[index].end_task, color: Colors.white, textColor: Colors.black,
              addVar1: list[index].desc, addVar3: list[index].ID, view_for: "Tasks", idLogin: widget.idLogin,);
          },
        ),)

      ],
    ),);
  }
}

//======================================================================================

//==================
// class buildList extends StatelessWidget {
//
//   List <data_task> list;
//   buildList({required this.list});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child:
//     );
//   }
// }

