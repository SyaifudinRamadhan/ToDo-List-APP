
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../APIService.dart';

// Define a corresponding State class.
// This class holds data related to the form.

class AddProjectState extends StatelessWidget {
  const AddProjectState({Key? key, required this.idLogin}) : super(key: key);

  final String idLogin;

  // @override
  // Widget build(BuildContext context) {
  //   return Container();
  // }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.


    final _formKey = GlobalKey<FormState>();
    TextEditingController inputName = new TextEditingController();
    TextEditingController inputDesc = new TextEditingController();
    TextEditingController inputComp = new TextEditingController();
    DateTime? valFirstDate;
    DateTime? valEndDate;
    String loginId = this.idLogin;

    // print("ID Login : "+loginId);

    return Scaffold(
      appBar: AppBar(title: Text("Tambah Project"),),
      body: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        child: Form(
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
                  "comp":inputComp.text,};

                print("Data yang disubmit : \n");
                print(resData);

                if ((inputName.text == null || inputName.text.isEmpty)||(valFirstDate == null)||(valEndDate == null)||(inputDesc == null || inputDesc.text.isEmpty)||(inputComp == null || inputComp.text.isEmpty)){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Semua fiels harus diisi gan !!!')),
                  );
                }else{
                  APIService(Url: "https://my-todolist-restapi.herokuapp.com/project_data_process.php?id_login="+idLogin,
                      bodyData: resData, context: context).sendData();
                  inputName.text = "";
                  inputDesc.text = "";
                  inputComp.text = "";
                  valEndDate = null;
                  valFirstDate = null;
                  print(resData);
                }

              },

                child: Text("Submit"),
                style: ElevatedButton.styleFrom(primary: Colors.red, onPrimary: Colors.white, shadowColor: Colors.red, elevation: 5,),)
            ],
          ),
        ),
      ),
    );
  }

}


// class AddProjectState extends StatelessWidget {
//   // Create a global key that uniquely identifies the Form widget
//   // and allows validation of the form.
//   //
//   // Note: This is a `GlobalKey<FormState>`,
//   // not a GlobalKey<MyCustomFormState>.
//   final String idLogin;
//
//
// }

