
import './details/project_details.dart';
import './details/member_details.dart';
import './details/task_details.dart';
import 'package:flutter/material.dart';

class cardView extends StatelessWidget {

  @override
  cardView(
      {required this.name,
        required this.icon,
        required this.f_date,
        required this.l_date,
        required this.color,
        required this.textColor,
        this.addVar1 = "", this.addVar2 = "", this.addVar3 = "", this.addVar4 = "", this.view_for = "home", required this.idLogin});
  final String name;
  final Widget icon;
  final String f_date;
  final String l_date;
  final Color color;
  final Color textColor;
  final String addVar1;
  final String addVar2;
  final String addVar3;
  final String addVar4;
  final String view_for;
  late String text1 = "";
  late String text2 = "";
  final String idLogin;

  Widget build(BuildContext context) {
    // TODO: implement build
    if (view_for == "home"){
      text1 = "Tanggal Mulai : ";
      text2 = "Deadline : ";
    }else if (view_for == "users"){
      text1 = "";
      text2 = "";
    }
    return Container(
        padding: EdgeInsets.all(2.0),
        margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0, bottom: 0.0),
        // height: 150.0,
        child: InkWell(
          onTap: (){
            String url = "";
            if (view_for == "home"){
              url = "https://my-todolist-restapi.herokuapp.com/index.php?get=detail&data=";
              url += addVar3+"&id_login="+idLogin;
              print("Masuk detail prooject");
              //kirimkan direct ke page detailnya
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Project_details(
                      idLogin: idLogin,
                      url: url,//project
                      url1: "https://my-todolist-restapi.herokuapp.com/view_task.php?get=FK_Projects&data="+addVar3+"&id_login="+idLogin,//task
                      url2: "https://my-todolist-restapi.herokuapp.com/view_members.php?get=FK_Projects&data="+addVar3+"&id_login="+idLogin,//members
                    )
                ),
              );
            }else if (view_for == "users"){
              url = "https://my-todolist-restapi.herokuapp.com/view_members.php?get=details&data=";
              url += addVar3+"&id_login="+idLogin;
              //kirimkan direct ke page detailnya
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => member_details(
                      idLogin: idLogin,
                      url: url,//member
                      url1: "https://my-todolist-restapi.herokuapp.com/index.php?get=FK_Users&data="+addVar3+"&id_login="+idLogin,//task
                      // url2: "http://localhost/view_members.php?get=FK_Projects&data="+addVar3,//members
                    )
                ),
              );
            }
            //view_for = task
            else{
              url = "https://my-todolist-restapi.herokuapp.com/view_task.php?get=details&data=";
              url += addVar3+"&id_login="+idLogin;
              //kirimkan direct ke page detailnya
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => task_details(
                      idLogin: idLogin,
                      url: url,//project
                      url1: "https://my-todolist-restapi.herokuapp.com/view_members.php?get=FK_Tasks&data="+addVar3+"&id_login="+idLogin,//task
                      // url2: "http://localhost/view_members.php?get=FK_Projects&data="+addVar3,//members
                    )
                ),
              );
            }
            print(name+" "+f_date+" "+l_date+" "+addVar1+" "+addVar2+" "+addVar3+" "+addVar4);
          },
          child: Card(
            color: color.withOpacity(0.25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Row(
              children: [
                //  Foto Icon
                Row(
                  children: [
                    Container(
                      // width: 100.0,
                      margin: EdgeInsets.only(left: 10.0, right: 10.0),
                      child:  icon,
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.all(5.0)),

                    Text("Project : " + name + "\n",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                          fontFamily: "PTSans",
                          color: textColor,

                        )),
                    Text(
                      text1 + f_date,
                      style: TextStyle(
                        fontSize: 10.0,
                        color: textColor,
                      ),
                    ),
                    Text(
                      text2 + l_date,
                      style: TextStyle(
                        fontSize: 10.0,
                        color: textColor,
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(5.0)),
                    // ))
                  ],
                ),
              ],
            ),
          ),
        )
    );
    throw UnimplementedError();
  }
}