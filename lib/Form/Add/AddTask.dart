
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:date_field/date_field.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../APIService.dart' as APISend;



class data_project{
  String ID;
  String name_prj;
  String start_date;
  String end_date;
  String desc;
  String company;

  data_project({required this.ID, required this.name_prj, required this.start_date, required this.end_date, required this.desc, required this.company});
  factory data_project.dataFromJson(Map<String, dynamic> map){
    return data_project(ID:map["ID"], name_prj: map["project_name"], start_date: map["start_date"], end_date: map["end_date"], desc: map["description"], company: map["company"]);
  }
}

List<data_project> dataFromJson(String JsonData){
  final data = json.decode(JsonData);
  return List<data_project>.from(data.map((item)=>data_project.dataFromJson(item)));
}

class APIService{
  Future<List<data_project>> getDataIndex(String idLogin) async{
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
}

class AddTask extends StatefulWidget {
  const AddTask({Key? key, required this.idLogin}) : super(key: key);
  final String idLogin;
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  // @override
  // Widget build(BuildContext context) {
  //   return Container();
  // }
  String projectSelect = "";
  TextEditingController taskName = new TextEditingController();
  TextEditingController desc = new TextEditingController();
  DateTime? fDate;
  DateTime? endDate;

  bool indicator = false;
  final _formKey = GlobalKey<FormState>();
  List<dynamic> source = [];



  void selectProject(String value) {
    setState(() {
      projectSelect = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    // APIService().getDataIndex().then((value) => {
    //   createSourceSelect(value),
    //   print("awalinivalue:$value")
    // });
    return Scaffold(
      appBar: AppBar(title: Text("Tambah Tugas"),),
      body: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: ListView(

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
                    LengthLimitingTextInputFormatter(100)
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
                child: Container(
                  child: FutureBuilder(
                    future: APIService().getDataIndex(widget.idLogin) ,builder: (BuildContext context, AsyncSnapshot<List<data_project>> snapshot){
                if (snapshot.hasError){
                  return Container(
                    child: Text("Ada kesalahan : ${snapshot.error}"),
                  );
                }else if (snapshot.connectionState == ConnectionState.done){
                  List<data_project> list = [];
                  source = [];
                  for (var i=0; i<snapshot.data!.length; i++){
                    list.add(snapshot.data![i]);
                    dynamic tmp = {"display":list[i].name_prj,"value":list[i].ID};
                    print(tmp);
                    source.add(tmp);
                    if (indicator == false){
                      projectSelect = list[0].ID;
                      indicator = true;
                    }

                  }

                  return DropDownFormField(
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
                      dataSource: source,
                      textField: "display",
                      valueField: "value",
                  );
                }

                return Center(child:CircularProgressIndicator());

                    } ),),
              ),
              Padding(
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
                          dynamic resData = {"task_name":taskName.text,"desc":desc.text,"f_date":fDate.toString(),"end_date":endDate.toString(),"project_id":projectSelect};
                          APISend.APIService(Url: "https://my-todolist-restapi.herokuapp.com/task_data_process.php?id_login="+widget.idLogin,
                              bodyData: resData, context: context).sendData();
                          taskName.text = "";
                          desc.text = "";
                          endDate = null;
                          fDate = null;
                          print(resData);
                        }

                      },
                  child: Text("Submit"),
                  style: ElevatedButton.styleFrom(primary: Colors.red, onPrimary: Colors.white, shadowColor: Colors.red, elevation: 5,),),
              )

            ],
          ),
        ),
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

