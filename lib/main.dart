import 'dart:convert';
import 'package:flutter/material.dart';
import './Home.dart';
import './taskList.dart';
import './memberList.dart';
import 'loginPage.dart' as login;
import 'package:http/http.dart' as http;
import './Form/Add/AddProject.dart' as adprj;
import './Form/Add/AddMember.dart' as admbr;
import './Form/Add/AddTask.dart' as adtsk;
import './Form/Edit/EditAcccount.dart' as eduser;
import './Form/filePicker.dart' as imgPick;

//Membuat navigasi bar (template)
int selectedIndex = 0;
String idLogin = "";

// void main() {
//   runApp(MaterialApp(
//     title: "Peoject Manager",
//     home: new HomePage(),
//     routes: {
//       '/AddProject':(context) => adprj.AddProjectState(),
//       '/AddTask':(context) => adtsk.AddTask(),
//       '/AddMember':(context) => admbr.AddMember(),
//       '/EditUser':(context) => eduser.EditAccount(),
//     },
//   ));
// }

void main() => runApp(MaterialApp(
  title: "Peoject Manager",
  home: new login.LoginScreen(),
  // routes: {
  //   '/AddProject':(context) => adprj.AddProjectState(idLogin: idLogin),
  //   '/AddTask':(context) => adtsk.AddTask(),
  //   '/AddMember':(context) => admbr.AddMember(),
  //   '/EditUser':(context) => eduser.EditAccount(idLogin: idLogin,),
  //   '/testPick':(context) => imgPick.testPicFile(),
  // },
));

void pageAdd(int index, context, String idLogin){
  if (index == 0){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context)=>adprj.AddProjectState(idLogin: idLogin,)
        ));
  }
  else if (index == 1){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context)=>adtsk.AddTask(idLogin: idLogin)
        ));
  }
  else if (index == 2){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context)=>admbr.AddMember(idLogin: idLogin)
        ));
  }
}

class data_user{
  String ID;
  String f_name;
  String l_name;
  String full_name;
  String username;
  String password;
  String phone;
  String pp_name;

  data_user({required this.ID, required this.f_name, required this.l_name, required this.full_name, required this.username,
    required this.password, required this.phone, required this.pp_name});
  factory data_user.dataFromJson(Map<String, dynamic> map){
    return data_user(ID: map["ID"], f_name: map["first_name"], l_name: map["last_name"], full_name: map["full_name"], username: map["username"], password: map["password"], phone: map["telp_number"],  pp_name: map["profile"]);
  }
}

List<data_user> dataFromJson(String JsonData){
  final data = json.decode(JsonData);
  return List<data_user>.from(data.map((item)=>data_user.dataFromJson(item)));
}

class APIService{

  Future<List<data_user>> getDataIndex(String id_login) async{
    final response = await http.get(Uri.parse("https://my-todolist-restapi.herokuapp.com/user_process.php?id_login="+id_login));
    if (response.statusCode == 200){
      print(response.body.toString());
      return dataFromJson(response.body);
    }else{
      return [];
    }
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.id_login}) : super(key: key);
  final String id_login;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  late TabController controller;


  @override
  void initState() {
    // TODO: implement initState
    controller = new TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    APIService().getDataIndex(widget.id_login).then((value) => print("value:$value"));
    return Scaffold(
      //  Membuat appbar
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Aplikasi Project Management"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            FutureBuilder(future: new APIService().getDataIndex(widget.id_login) ,builder: (BuildContext context, AsyncSnapshot<List<data_user>> snapshot){
              if (snapshot.hasError){
                return Center(
                  child: Text("Ada kesalahan : ${snapshot.error}"),
                );
              }else if (snapshot.connectionState == ConnectionState.done){
                List<data_user> list = [];
                for (var i=0; i<snapshot.data!.length; i++){
                  list.add(snapshot.data![i]);
                }
                String urlImg = "https://my-todolist-restapi.herokuapp.com/media/";
                if (list[0].pp_name == "-"){
                  urlImg = "https://my-todolist-restapi.herokuapp.com/media/default.jpg";
                }else{
                  urlImg += list[0].pp_name;
                }
                print(urlImg);
                return UserAccountsDrawerHeader(
                  accountName: Text(list[0].full_name),
                  accountEmail: Text(list[0].phone),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(urlImg),
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage("https://my-todolist-restapi.herokuapp.com/media/bg.png"), fit: BoxFit.cover),
                  ),
                );
              }
              return Center(child:CircularProgressIndicator());
            }),
            ListTile(title: Text("Akun Saya"), trailing: Icon(Icons.people),onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context)=>eduser.EditAccount(idLogin: widget.id_login,)
                  ));
              },)
          ],
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: [
          HomeContent(idLogin: widget.id_login),
          TaskList(idLogin: widget.id_login),
          MemberList(idLogin: widget.id_login),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          //write navigation here
          pageAdd(controller.index, context, widget.id_login);
        },
        child: const Icon(Icons.add),),
      bottomNavigationBar: Material(
        color: Colors.blue,
        child: TabBar(
            controller: controller,
            tabs: [
              Tab(icon: Icon(Icons.home_filled), text: "Home",),
              Tab(icon: Icon(Icons.task_alt_rounded), text: "Task",),
              Tab(icon: Icon(Icons.card_membership), text: "Member",),
            ]
        ),
      ),
    );
  }
}


