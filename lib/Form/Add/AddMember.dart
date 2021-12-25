
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:dropdown_formfield/dropdown_formfield.dart';
import '../APIService.dart' as APISend;

int test = 0;


class data_user{
  String f_name;
  String ID;
  String l_name;
  String full_name;
  String usr_namw;
  String password;
  String phone;
  String profile;

  data_user({required this.ID, required this.f_name, required this.l_name,
    required this.full_name, required this.usr_namw, required this.password,
    required this.phone, required this.profile});

  //  Mengambil data text berupa JSON di API ke dalam objek class ini (factory agar tidak objeknya tetap sama)
  // Mengubah dataMAP JSON menjadi variabel yang dipassing ke objek class ini
  factory data_user.dataFromJson(Map<String, dynamic> map){
    String pp = "";
    if (map["profile"] == "-"){
      pp = "https://my-todolist-restapi.herokuapp.com/media/default.jpg";
    }else{
      pp = "https://my-todolist-restapi.herokuapp.com/media/"+map["profile"];
    }
    return data_user(ID: map["ID"], f_name: map["first_name"], l_name: map["last_name"], full_name: map["full_name"], usr_namw: map["username"], password: map["password"], phone: map["telp_number"], profile: pp);
  }
}

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


List<data_user> dataFromJson_m(String JsonData){
  final data = json.decode(JsonData);
  return List<data_user>.from(data.map((item)=>data_user.dataFromJson(item)));
}

List<data_projects> dataFromJson(String JsonData){
  final data = json.decode(JsonData);
  return List<data_projects>.from(data.map((item)=>data_projects.dataFromJson(item)));
}

List<data_tasks> dataFromJson_t(String JsonData){
  final data = json.decode(JsonData);
  return List<data_tasks>.from(data.map((item)=>data_tasks.dataFromJson_t(item)));
}

class APIService{
  Future<List<data_user>> getDataIndex(String idLogin) async{
    print("Masuk API task list");
    final response = await http.get(Uri.parse("https://my-todolist-restapi.herokuapp.com/view_all_user.php?id_login="+idLogin));
    print("Response API tasks : ");
    print(response.statusCode);
    if (response.statusCode == 200){
      // print(jsonDecode(response.body));
      print(response.body);
      return dataFromJson_m(response.body);
    }else{
      return [];
    }
  }

  Future<List<data_projects>> getDataIndex_p(String idLogin) async{
    final response = await http.get(Uri.parse("https://my-todolist-restapi.herokuapp.com/index.php?id_login="+idLogin));
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

  Future<List<data_tasks>> getDataIndex_t(String IDProject, String idLogin) async{

    if (IDProject != ""){
      final response = await http.get(Uri.parse("https://my-todolist-restapi.herokuapp.com/view_task.php?get=FK_Projects&data="+IDProject+"&id_login="+idLogin));
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
    }else{
      return [];
    }
  }
}

class AddMember extends StatefulWidget {
  const AddMember({Key? key, required this.idLogin}) : super(key: key);
  final String idLogin;
  @override
  _AddMemberState createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  // @override
  // Widget build(BuildContext context) {
  //   return Container();
  // }

  final _formKey = GlobalKey<FormState>();
  String projectSelect = "";
  String userSelect = "";
  String taskSelect = "";
  List<dynamic> source = [];
  List<dynamic> sourceProjects = [];
  List<dynamic> sourceTasks = [];
  bool indicator = false;
  bool indicator2 = false;
  bool indicator3 = false;


  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(title: Text("Tambah Anggota"),),
      body: Container(
        child: Form(key: _formKey,child: ListView(children: [

          //Mebuat search form dan list select dropdown usernya
          FutureBuilder(
              future: APIService().getDataIndex(widget.idLogin),
              builder: (BuildContext context, AsyncSnapshot<List<data_user>> snapshot){
                if (snapshot.hasError){
                  return Center(
                      child: Text("Ada kesalahan : ${snapshot.error}")
                  );
                }else if (snapshot.connectionState == ConnectionState.done){
                  source = [];
                  List<data_user> users = [];
                  List<String> membersName = [];
                  for (var i = 0; i<snapshot.data!.length; i++){
                    users.add(snapshot.data![i]);
                    membersName.add(users[i].full_name);
                    dynamic tmp = {"display":users[i].full_name+" | "+users[i].phone,"value":users[i].ID};
                    source.add(tmp);
                  }
                  if (indicator == false){
                    // userSelect = users[0].ID;
                    userSelect = "";
                    indicator = true;
                  }
                  print("Print list data : ");
                  print(users);
                  return Padding(padding: EdgeInsets.all(12), child: DropDownFormField(
                    titleText: "Siapa yang kamu rekrut ?",
                    hintText: "Pilih anggota",
                    value: userSelect,
                    onSaved: (value){
                      setState(() {
                        userSelect = value;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        userSelect = value;
                      });
                      print("Value : "+value);
                    },
                    dataSource: source,
                    textField: "display",
                    valueField: "value",
                  ),);
                  // return Container();
                }
                return Center(child: CircularProgressIndicator(),);
              }
          ),
          FutureBuilder(
              future: APIService().getDataIndex_p(widget.idLogin),
              builder: (BuildContext context, AsyncSnapshot<List<data_projects>> snapshot){
                if (snapshot.hasError){
                  return Center(
                      child: Text("Ada kesalahan : ${snapshot.error}")
                  );
                }else if (snapshot.connectionState == ConnectionState.done){
                  sourceProjects = [];
                  List<data_projects> projects = [];
                  for (var i = 0; i<snapshot.data!.length; i++){
                    projects.add(snapshot.data![i]);
                    dynamic tmp = {"display":projects[i].name_prj,"value":projects[i].ID};
                    sourceProjects.add(tmp);
                  }
                  if (indicator2 == false){
                    // projectSelect = projects[0].ID;
                    projectSelect = "";
                    indicator2 = true;
                  }
                  print("Print list data : ");
                  print(projects);
                  return Padding(padding: EdgeInsets.all(12), child: DropDownFormField(
                    titleText: "Dari Project Apa ?",
                    hintText: "Pilih project",
                    value: projectSelect,
                    onSaved: (value){
                      setState(() {
                        projectSelect = value;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        projectSelect = value;
                      });
                      print("Value : "+value);
                    },
                    dataSource: sourceProjects,
                    textField: "display",
                    valueField: "value",
                  ),);
                  // return Container();
                }
                return Center(child: CircularProgressIndicator(),);
          }),
          FutureBuilder(
              future: APIService().getDataIndex_t(projectSelect, widget.idLogin),
              builder: (BuildContext context, AsyncSnapshot<List<data_tasks>> snapshot){
                print("======= Projrct slect : "+projectSelect+" ===============");
                if (snapshot.hasError){
                  return Center(
                      child: Text("Ada kesalahan : ${snapshot.error}")
                  );
                }else if (snapshot.connectionState == ConnectionState.done){
                  sourceTasks = [];
                  List<data_tasks> tasks = [];
                  for (var i = 0; i<snapshot.data!.length; i++){
                    tasks.add(snapshot.data![i]);
                    dynamic tmp = {"display":tasks[i].task_name,"value":tasks[i].ID};
                    sourceTasks.add(tmp);
                  }
                  print("Data tasks : ===========================");
                  print(tasks);
                  print("======================================");
                  if (indicator3 == false){
                    taskSelect = "";
                    indicator3 = true;
                  }
                  if(tasks.length == 0){
                    taskSelect = "";
                  }
                  print("Print list data : ");
                  print(tasks);
                  return Padding(padding: EdgeInsets.all(12), child: DropDownFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tidak boleh kosong';
                      }
                      return null;
                    },
                    titleText: "Tugasnya apa ?",
                    hintText: "Pilih tugas",
                    value: taskSelect,
                    onSaved: (value){
                      setState(() {
                        taskSelect = value;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        taskSelect = value;
                      });
                      print("Value : "+value);
                    },
                    dataSource: sourceTasks,
                    textField: "display",
                    valueField: "value",
                  ),);
                  // return Container();
                }
                return Center(child: CircularProgressIndicator(),);
              }),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(onPressed: (){print("Kirim ditekan");
            if (_formKey.currentState!.validate()) {
              // If the form is valid, display a snackbar. In the real world,
              // you'd often call a server or save the information in a database.
              dynamic resData = {"user_id":userSelect,"project_id":projectSelect,"task_id":taskSelect};
              APISend.APIService(Url: "https://my-todolist-restapi.herokuapp.com/member_data_process.php?id_login="+widget.idLogin,
                  bodyData: resData, context: context).sendData();
              taskSelect = "";
              print(resData);
            }},
              child: Text("Submit"),
              style: ElevatedButton.styleFrom(primary: Colors.red, onPrimary: Colors.white, shadowColor: Colors.red, elevation: 5,),),
          )


        ],))
      ),
    );
  }

}

