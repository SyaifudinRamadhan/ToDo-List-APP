import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart' as main;
import 'loginPage.dart' as loginPage;
import './Form/APIService.dart' as APIWeb;


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {
  bool? isChecked = false;

  TextEditingController fName = new TextEditingController();
  TextEditingController lName = new TextEditingController();
  TextEditingController fullName = new TextEditingController();
  TextEditingController phoneNumber =  new TextEditingController();
  TextEditingController username =  new TextEditingController();
  TextEditingController password = new TextEditingController();

  Widget _buildTextField({
    required bool obscureText,
    Widget? prefixedIcon,
    String? hintText,
    TextEditingController? editingController,
    TextInputType typetext = TextInputType.text,
    int? textLength
  }) {
    return Material(
      color: Colors.transparent,
      elevation: 2,
      child: TextField(
        cursorColor: Colors.white,
        cursorWidth: 2,
        obscureText: obscureText,
        controller: editingController,
        maxLength: textLength,
        style: const TextStyle(color: Colors.white),
        keyboardType: typetext,
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
          'Daftar',
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
          // print("Username : "+username.text);
          // print("f name : "+fName.text);
          // print("l name : "+lName.text);
          // print("full name : "+fullName.text);
          // print("no telpon : "+phoneNumber.text);
          // print("password : "+password.text);
          if((username.text.isEmpty || username.text == null) || (password.text.isEmpty || password.text == null) ||
              (fName.text.isEmpty || fName.text == null) || (lName.text.isEmpty || lName.text == null) || (fullName.text.isEmpty || fullName.text == null) ||
              (phoneNumber.text.isEmpty || phoneNumber.text == null)){
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Semua fiels harus diisi gan !!!')),
            );
          }else{
            dynamic resData = {"username":username.text,"password":password.text,"sign_up":"true","f_name":fName.text,"l_name":lName.text,
            "full_name":fullName.text,"phone_num":phoneNumber.text};
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
          'Sudah Punya Akun? ',
          style: TextStyle(
            fontFamily: 'PT-Sans',
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        InkWell(
          child: const Text(
            'Login Sekarang',
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
                MaterialPageRoute(
                    builder: (context) => loginPage.LoginScreen()
                ));
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
                    'Daftar / Sign Up',
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
                    editingController: username,
                    obscureText: false,
                    prefixedIcon: const Icon(Icons.people_alt, color: Colors.white),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Nama Depan',
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
                    hintText: 'Inputkan nama depan kamu',
                    editingController: fName,
                    obscureText: false,
                    prefixedIcon: const Icon(Icons.text_fields, color: Colors.white),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Nama Belakang',
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
                    hintText: 'Inputkan nama belakang',
                    obscureText: false,
                    editingController: lName,
                    prefixedIcon: const Icon(Icons.text_fields, color: Colors.white),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Nama Lengkap',
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
                    hintText: 'Inputkan nama lengkap',
                    obscureText: false,
                    editingController: fullName,
                    prefixedIcon: const Icon(Icons.text_fields, color: Colors.white),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'No Telelpon / WhatsApp',
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
                    hintText: 'Inputkan no telepon / WA',
                    obscureText: false,
                    editingController: phoneNumber,
                    typetext: TextInputType.number,
                    prefixedIcon: const Icon(Icons.phone_android, color: Colors.white),
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
                    textLength: 8,
                    editingController: password,
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
                  _buildSignUpQuestion(),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}