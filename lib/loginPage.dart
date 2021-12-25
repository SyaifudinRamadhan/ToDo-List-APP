// import 'main.dart' as main;
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);
//
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   @override
//   // Widget build(BuildContext context) {
//   //   return Scaffold(
//   //     appBar: new AppBar(title: Text("Project Manager App | Login"),) ,
//   //     // body: new Center(
//   //     //   child: new ElevatedButton(onPressed: (){
//   //     //     Navigator.push(
//   //     //       context,
//   //     //       MaterialPageRoute(
//   //     //           builder: (context) => main.HomePage()
//   //     //       ),);
//   //     //   },
//   //     //   child: new Text("Login")),
//   //     //   )
//   //     body: new Material(
//   //     color: Colors.transparent,
//   //     elevation: 2,
//   //     child: TextField(
//   //       cursorColor: Colors.white,
//   //       cursorWidth: 2,
//   //       style: const TextStyle(color: Colors.white),
//   //          decoration: InputDecoration(
//   //             border: InputBorder.none,
//   //             filled: true,
//   //             fillColor: Color(0xFF5180ff),
//   //             hintStyle: const TextStyle(
//   //             color: Colors.white54,
//   //             fontWeight: FontWeight.bold,
//   //             fontFamily: 'PTSans',
//   //            ),
//   //          )
//   //        )
//   //     )
//   //   );
//   // }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart' as main;
import 'signUpPage.dart' as signUp;
import './Form/APIService.dart' as APIWeb;


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool? isChecked = false;

  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();

  Widget _buildTextField({
    required bool obscureText,
    Widget? prefixedIcon,
    String? hintText,
    TextEditingController? textController,
  }) {
    return Material(
      color: Colors.transparent,
      elevation: 2,
      child: TextField(
        cursorColor: Colors.white,
        cursorWidth: 2,
        obscureText: obscureText,
        controller: textController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          filled: true,
          fillColor: Color(0xFF5180ff),
          prefixIcon: prefixedIcon,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.white54,
            fontWeight: FontWeight.bold,
            fontFamily: 'PTSans',
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      height: 64,
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            Colors.white,
          ),
          elevation: MaterialStateProperty.all(6),
          shape: MaterialStateProperty.all(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
          ),
        ),
        child: const Text(
          'Login',
          style: TextStyle(
            fontFamily: 'PT-Sans',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        onPressed: () {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(builder:
          //         (context) => main.HomePage()
          //     )
          // );
          // print(" Username : "+username.text);
          // print("Passsword : "+password.text);

          if((username.text.isEmpty || username.text == null) || (password.text.isEmpty || password.text == null)){
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Semua fiels harus diisi gan !!!')),
            );
          }else{
            dynamic resData = {"username":username.text,"password":password.text,"login":"true"};
            APIWeb.APIService(Url: "https://my-todolist-restapi.herokuapp.com/login.php",
                bodyData: resData, context: context).loginSignUp();
            print(resData);


          }

        },
      ),
    );
  }



  Widget _buildSignUpQuestion() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Tidak Punya Akun? ',
          style: TextStyle(
            fontFamily: 'PT-Sans',
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        InkWell(
          child: const Text(
            'Daftar Sekarang',
            style: TextStyle(
              fontFamily: 'PT-Sans',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder:
                  (context) => signUp.SignUpScreen()
                )
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF5967ff),
                Color(0xFF5374ff),
                Color(0xFF5180ff),
                Color(0xFF538bff),
                Color(0xFF5995ff),
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
              ).copyWith(top: 60),
              child: Column(
                children: [
                  const Text(
                    'Sing in',
                    style: TextStyle(
                      fontFamily: 'PT-Sans',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Username',
                      style: TextStyle(
                        fontFamily: 'PT-Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildTextField(
                    hintText: 'Inputkan username kamu',
                    obscureText: false,
                    textController: username,
                    prefixedIcon: const Icon(Icons.people_alt, color: Colors.white),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Password',
                      style: TextStyle(
                        fontFamily: 'PT-Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildTextField(
                    hintText: 'Password kamu',
                    obscureText: true,
                    textController: password,
                    prefixedIcon: const Icon(Icons.lock, color: Colors.white),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  _buildLoginButton(),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    '- Atau -',
                    style: TextStyle(
                      fontFamily: 'PT-Sans',
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  _buildSignUpQuestion()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
