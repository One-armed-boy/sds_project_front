import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'screen_unvisited_res.dart';
import 'package:get/get.dart';
import 'screen_main.dart';
import 'screen_signup.dart';

void main() {
  runApp(MaterialApp(
    title: 'LoginView',
    home: Login(),
  )); //runApp: 앱 구동시켜주세요~
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formkey = GlobalKey<FormState>();
  String email ="";
  String password = "";
  Future<void> _submit() async {
    if (formkey.currentState!.validate() == false) {
      return ;
    } else {
      var dio = Dio();
      formkey.currentState!.save();
      var response = await dio.postUri(Uri.parse("http://sds-projects.herokuapp.com/accounts/login/"),
          data: {"username":"","email":email,"password":password});
      if(response.statusCode == 200) {
        final accesstoken = response.data['access_token'];
        final refreshtoken = response.data['refresh_token'];
        final user_email = response.data['user']['email'];
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Main(token:accesstoken,email:user_email)));
      } else {
        Get.snackbar('로그인 시도','실패!');
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(flex:3,child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("오늘 뭐 먹지?",style: TextStyle(fontWeight: FontWeight.w400, fontSize: 50),),
                  Icon(Icons.restaurant_menu,size:100),
                ],
              )),
              Flexible(flex:4,child: Padding(
                padding: const EdgeInsets.fromLTRB(15,0,15,0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(flex:5,child: Form(
                      key:formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(padding: EdgeInsets.fromLTRB(30, 0, 50,20),child: TextFormField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText:"email"
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value){
                              if(value!.isEmpty){
                                return "입력하셔야합니다.";
                              }
                              return null;
                            },
                            onSaved: (value){
                              email = value!;
                            },
                          ),),
                          Padding(padding: EdgeInsets.fromLTRB(30, 20, 50,0),child: TextFormField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "password"
                              ),
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              validator: (value){
                                if(value!.isEmpty){
                                  return "입력하셔야합니다.";
                                }
                                return null;
                              },
                              onSaved: (value){
                                password = value!;
                              }
                          ),),
                        ],
                      ),
                    )),
                    Expanded(child: ElevatedButton(onPressed: (){
                      _submit();
                    }, child: Text('로그인'))),
                  ],
                ),
              )),
              Expanded(child: TextButton(onPressed: (){
                Navigator.push(context,MaterialPageRoute(builder: (context) => Signup()));
              },
                  child: Text('회원가입',style: TextStyle(color: Colors.grey),))),
            ],
          ),
        )
    );
  }
}

