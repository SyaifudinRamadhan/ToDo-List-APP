
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:date_field/date_field.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_test/details/project_details.dart';
import 'package:flutter_app_test/main.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../APIService.dart' as APISend;
import '../APIDelete.dart' as APIDel;
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter_app_test/cardView.dart';

String url1 = "";
String url2 = "";

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

class data_members{
  String f_name;
  String ID;
  String l_name;
  String full_name;
  String usr_namw;
  String password;
  String phone;
  String profile;
  String ID_member;

  data_members({required this.ID, required this.f_name, required this.l_name,
    required this.full_name, required this.usr_namw, required this.password,
    required this.phone, required this.profile, required this.ID_member});

  //  Mengambil data text berupa JSON di API ke dalam objek class ini (factory agar tidak objeknya tetap sama)
  // Mengubah dataMAP JSON menjadi variabel yang dipassing ke objek class ini
  factory data_members.dataFromJson(Map<String, dynamic> map){
    String pp = "";
    if (map["profile"] == "-"){
      pp = "https://my-todolist-restapi.herokuapp.com/media/default.jpg";
    }else{
      pp = "https://my-todolist-restapi.herokuapp.com/media/"+map["profile"];
    }
    return data_members(ID: map["ID"], f_name: map["first_name"], l_name: map["last_name"], full_name: map["full_name"], usr_namw: map["username"], password: map["password"], phone: map["telp_number"], profile: pp, ID_member: map["ID_member"]);
  }
}

List<data_tasks> dataFromJson_t(String JsonData){
  final data = json.decode(JsonData);
  return List<data_tasks>.from(data.map((item)=>data_tasks.dataFromJson(item)));
}

List<data_members> dataFromJson_m(String JsonData){
  final data = json.decode(JsonData);
  return List<data_members>.from(data.map((item)=>data_members.dataFromJson(item)));
}

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

class EditTask extends StatefulWidget {
  const EditTask({Key? key, required this.url, required this.url2, required this.idLogin}) : super(key: key);

  final String url;
  final String url2;
  final String idLogin;
  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  // @override
  // Widget build(BuildContext context) {
  //   return Container();
  // }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    // APIService().getDataIndex().then((value) => {
    //   createSourceSelect(value),
    //   print("awalinivalue:$value")
    // });
    url1 = widget.url;
    url2 = widget.url2;
    print("dimuat ulang");
    return Scaffold(
      appBar: AppBar(title: Text("Edit Tugas"),),
      body: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        child: ListView(children: [
          FutureBuilder(
            future: new ApiService(url: widget.url).getDataIndex_t(),
            builder: (BuildContext context, AsyncSnapshot<List<data_tasks>> snapshot){
              print(widget.url);
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
                return buildFormEdit(list: tasks, idLogin: widget.idLogin,);
              }
              return Center(child:CircularProgressIndicator());
              // return Text("data");
            },
          ),
          FutureBuilder(
            future: new ApiService(url: widget.url2).getDataIndex_m(),
            builder: (BuildContext context, AsyncSnapshot<List<data_members>> snapshot){
              print(widget.url2);
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
                return _buildListView_m(list: members, idLogin: widget.idLogin,);
              }
              return Center(child:CircularProgressIndicator());
              // return Text("data");
            },
          )

        ],)
      ),
    );
  }

}

class buildFormEdit extends StatelessWidget {
   buildFormEdit({Key? key, required this.list, required this.idLogin}) : super(key: key);

   final String idLogin;
  final _formKey = GlobalKey<FormState>();

  final List<data_tasks> list;

   TextEditingController taskName = new TextEditingController();
   TextEditingController desc = new TextEditingController();
   TextEditingController status = new TextEditingController();
   String projectSelect = "";
   DateTime? fDate;
   DateTime? endDate;

   List<PlatformFile>? filePicked;
   List<String?> fileName = [];

   bool indicator = false;

  @override
  Widget build(BuildContext context) {

    if (indicator == false){
      taskName.text = list[0].task_name;
      desc.text = list[0].desc;
      status.text = list[0].status;
      projectSelect = list[0].prj_name;
      fDate = DateTime.parse(list[0].start_task);
      endDate = DateTime.parse(list[0].end_task);

      print(projectSelect);
      indicator = true;
    }

    String fileSelectName = "Choose File";

    return Form(
      key: _formKey,
      child: Column(

        children: [
          // Add TextFormFields and ElevatedButton here.

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(20)
              ],
              controller: taskName,
              decoration: InputDecoration(
                  labelText: "Nama Tugas",
                  hintText: "Input Text",
                  prefixIcon: Icon(Icons.task),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),
            ),
          ),
          Padding(padding: const EdgeInsets.all(12.0), child: DateTimeFormField(
            decoration: const InputDecoration(
              hintStyle: TextStyle(color: Colors.black45),
              errorStyle: TextStyle(color: Colors.redAccent),
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25.0)),),
              suffixIcon: Icon(Icons.event_note),
              labelText: 'Tanggal Mulai',
            ),
            initialValue: fDate,
            mode: DateTimeFieldPickerMode.date,
            autovalidateMode: AutovalidateMode.always,
            onDateSelected: (DateTime value) {
              print(value);
              fDate = value;
            },),),

          Padding(padding: const EdgeInsets.all(12.0), child: DateTimeFormField(
            decoration: const InputDecoration(
              hintStyle: TextStyle(color: Colors.black45),
              errorStyle: TextStyle(color: Colors.redAccent),
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25.0)),),
              suffixIcon: Icon(Icons.event_note),
              labelText: 'Tanggal Deadline',
            ),
            initialValue: endDate,
            mode: DateTimeFieldPickerMode.date,
            autovalidateMode: AutovalidateMode.always,
            onDateSelected: (DateTime value) {
              print(value);
              endDate = value;
            },),),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(100),
              ],
              controller: desc,
              decoration: InputDecoration(
                  labelText: "Deskripsi",
                  hintText: "Input text",
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(3),
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
              ],
              controller: status,
              decoration: InputDecoration(
                  labelText: "Pesentase Selesai",
                  hintText: "Input angka",
                  prefixIcon: Icon(Icons.confirmation_num),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),
            ),
          ),
          Container(
            child: new ElevatedButton(onPressed: () async {
            final filePick = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['jpg', 'pdf', 'docx', 'doc', 'xls', 'xlsx', 'png']);

            filePicked = filePick!.files;
            fileName = filePick.names;
            print(fileName);
            fileSelectName = fileName[0].toString();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("File berhasil di pilih ")),
            );
            // openFile(fileShow);

            }, child: new Text(fileSelectName)),
            width: double.infinity,
          ),
          // Container(
          //   child: Text("File dipilih : "+fileName.toString()),
          // ),
          Container(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(onPressed: (){

              print("Kirim ditekan");
              if ((taskName.text == null || taskName.text.isEmpty)||
                  (fDate == null)||(endDate == null)||
                  (desc == null || desc.text.isEmpty)||
                  (projectSelect == null || projectSelect == "")){
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Semua fiels harus diisi gan !!!')),
                );
              }else{
                dynamic resData = {"task_name":taskName.text,"desc":desc.text,"f_date":fDate.toString(),
                  "end_date":endDate.toString(),"project_id":projectSelect, "file_ori":list[0].str_file,
                  "status":status.text, "ID":list[0].ID, "edit":"true"};
                APISend.APIService(Url: "https://my-todolist-restapi.herokuapp.com/task_data_process.php?id_login="+idLogin,
                    bodyData: resData, context: context).sendData();

                if (filePicked != null){
                  print("FIle nggak kosong");
                  resData = {"task_name":taskName.text,"desc":desc.text,"f_date":fDate.toString(),
                    "end_date":endDate.toString(),"project_id":projectSelect, "file_ori":list[0].str_file,
                    "status":status.text, "ID":list[0].ID, "edit":"true","new_file":"true"};
                  APISend.APIService(Url: "https://my-todolist-restapi.herokuapp.com/task_data_process.php?id_login="+idLogin,
                      bodyData: resData, context: context).sendFile(filePicked, list[0].ID);
                }

                print(resData);
              }

            },
              child: Text("Submit"),
              style: ElevatedButton.styleFrom(primary: Colors.yellow, onPrimary: Colors.black, shadowColor: Colors.red, elevation: 5,),
            ),
            width: double.infinity,
          ),
          Text("\n\n")

        ],
      ),
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
            // return cardView(name: "" +"\n("+list[index].full_name+")", icon: ClipRRect(
            //     borderRadius: BorderRadius.circular(20.0),child: Image.network(list[index].profile, width: 120, height: 120,)), f_date: "", l_date: "", color: Colors.lightBlueAccent, textColor: Colors.black, addVar1: list[index].usr_namw, addVar2: list[index].phone, addVar3: list[index].ID, view_for: "users",);
            return ElevatedButton(onPressed: (){

              String url = "https://my-todolist-restapi.herokuapp.com/member_data_process.php?delete="+list[index].ID_member+"&id_login="+idLogin;
              print(url);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => EditTask(
              //           url: url1, url2: url2
              //       )
              //   ),);

              APIDel.APIService(Url: url, context: context).delData();
              Navigator.pop(context,true);

            },
                child: Text("Hapus member tugas => "+list[index].full_name),
                style: ElevatedButton.styleFrom(primary: Colors.red, onPrimary: Colors.white, shadowColor: Colors.red, elevation: 5,)
            );
          }
      ),
    );
  }
}



// // Define a corresponding State class.
// // This class holds data related to the form.
// class AddTask extends StatelessWidget {
//   // Create a global key that uniquely identifies the Form widget
//   // and allows validation of the form.
//   //
//   // Note: This is a `GlobalKey<FormState>`,
//   // not a GlobalKey<MyCustomFormState>.
//
// }

