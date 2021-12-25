
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../APIService.dart' as APISend;

// Define a corresponding State class.
// This class holds data related to the form.
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
}

class EditProjectState extends StatelessWidget {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  EditProjectState({required this.url, required this.idLogin});
  final String url;
  final String idLogin;


  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(title: Text("Edit Project"),),
      body: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
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
              return createForm(list: projects, idLogin: idLogin,);
            }
            return Center(child:CircularProgressIndicator());
            // return Text("data");
          },
        )
      ),
    );
  }
}

class createForm extends StatelessWidget {

  createForm({Key? key, required this.list, required this.idLogin}) : super(key: key);

  final List<data_projects> list;
  final String idLogin;

  TextEditingController inputName = new TextEditingController();
  TextEditingController inputDesc = new TextEditingController();
  TextEditingController inputComp = new TextEditingController();
  DateTime? valFirstDate;
  DateTime? valEndDate;
  bool indicator  = false;

  final _formKey = GlobalKey<FormState>();

  // TextEditingController inputName = new TextEditingController();
  // TextEditingController inputDesc = new TextEditingController();
  // TextEditingController inputComp = new TextEditingController();
  // DateTime? valFirstDate;
  // DateTime? valEndDate;

  @override
  Widget build(BuildContext context) {

    if (indicator == false){
      inputName.text = list[0].name_prj;
      inputDesc.text = list[0].desc;
      inputComp.text = list[0].company;
      valFirstDate = DateTime.parse(list[0].start_date);
      valEndDate = DateTime.parse(list[0].end_date);

      indicator = true;
    }
    return Form(
      key: _formKey,
      child: ListView(
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add TextFormFields and ElevatedButton here.
          TextField(
            controller: inputName,
            decoration: InputDecoration(
                hintText: "Input text",
                label: Text("Nama Project"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                )
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 10)),
          DateTimeFormField(
            decoration: const InputDecoration(
              hintStyle: TextStyle(color: Colors.black45),
              errorStyle: TextStyle(color: Colors.redAccent),
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.event_note),
              labelText: 'Tanggal Mulai',
            ),
            mode: DateTimeFieldPickerMode.date,
            autovalidateMode: AutovalidateMode.always,
            initialValue: valFirstDate,
            onDateSelected: (DateTime value) {
              print(value);
              valFirstDate = value;
            },),
          Padding(padding: EdgeInsets.only(top: 10)),
          DateTimeFormField(
            decoration: const InputDecoration(
              hintStyle: TextStyle(color: Colors.black45),
              errorStyle: TextStyle(color: Colors.redAccent),
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.event_note),
              labelText: 'Tanggal Deadline',
            ),
            mode: DateTimeFieldPickerMode.date,
            autovalidateMode: AutovalidateMode.always,
            initialValue: valEndDate,
            onDateSelected: (DateTime value) {
              print(value);
              valEndDate = value;
            },),
          Padding(padding: EdgeInsets.only(top: 10)),
          TextField(
            controller: inputDesc,
            decoration: InputDecoration(
                hintText: "Input text",
                label: Text("Deskripsi Project"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                )
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 10)),
          TextField(
            controller: inputComp,
            decoration: InputDecoration(
                hintText: "Input text",
                label: Text("Korporasi / organisasi"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                )
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 10)),
          ElevatedButton(onPressed: (){
            print("Kirim ditekan");
            dynamic resData = {"name_prj":inputName.text,
              "f_date":valFirstDate.toString(),
              "end_date":valEndDate.toString(),
              "desc":inputDesc.text,
              "comp":inputComp.text,
              "ID":list[0].ID,
              "edit":"true"};
            print("Data yang disubmit : \n");
            print(resData);

            if ((inputName.text == null || inputName.text.isEmpty)||(valFirstDate == null)||(valEndDate == null)||(inputDesc == null || inputDesc.text.isEmpty)||(inputComp == null || inputComp.text.isEmpty)){
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Semua fiels harus diisi gan !!!')),
              );
            }else{
              APISend.APIService(Url: "https://my-todolist-restapi.herokuapp.com/project_data_process.php?id_login="+idLogin,
                  bodyData: resData, context: context).sendData();
              print(resData);
            }

          },

            child: Text("Submit"),
            style: ElevatedButton.styleFrom(primary: Colors.red, onPrimary: Colors.white, shadowColor: Colors.red, elevation: 5,),)
        ],
      ),
    );
  }
}

