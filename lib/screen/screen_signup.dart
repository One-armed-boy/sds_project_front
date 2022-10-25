import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final formkey =GlobalKey<FormState>();
  String email ="";
  String password1 = "";
  String password2 ="";

  Future<void> _submit() async{
    print(1);
    if (formkey.currentState!.validate()==false){
      return ;
    } else{
      var dio = Dio();
      print(2);
      formkey.currentState!.save();
      if (password1==password2) {
        print(3);
        print({
          "username": "",
          "email": email,
          "password1": password1,
          "password2": password2
        });
        var response = await dio.postUri(
            Uri.parse("http://sds-projects.herokuapp.com/accounts/"),
            data: {
              "email": email,
              "password1": password1,
              "password2": password2
            });
        print(4);
        print(response.statusCode);
        print(response.statusMessage);
        if (response.statusCode == 201) {
          Get.dialog(
              AlertDialog(
                title: Text("회원가입"),
                content: Text("성공!"),
                actions: [
                  TextButton(
                    child: Text('확인'),
                    onPressed: (){
                      Get.back();
                    },
                  )
                ],
              )
          );
          Navigator.pop(
              context);
        } else {
          return;
        }
      } else {
        Get.dialog(
          AlertDialog(
            title: Text("비밀번호 오류"),
            content: Text("두 비밀번호가 일치하지 않습니다."),
            actions: [
              TextButton(
                child: Text('확인'),
                onPressed: (){
                  Get.back();
                },
              )
            ],
          )
        );
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SignUp",
      home: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Form(
            key: formkey,
            child: Column(
              children: [
                Container(
                  height:300,
                  child: ListView(
                    children: [
                      Container(height:50,alignment: Alignment.centerLeft,color:Colors.blue,child:Text("회원가입",style: TextStyle(color: Colors.white),)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "email",
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value){
                            if (value!.isEmpty){
                              return "입력해라";
                            } else{
                              return null;
                            }
                          },
                          onSaved: (value){
                            email = value!;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "password",
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value){
                            if (value!.isEmpty){
                              return "입력해라";
                            } else{
                                return null;
                              }
                          },
                          onSaved: (value){
                            password1 = value!;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "password 확인",
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value){
                            if (value!.isEmpty){
                              return "입력해라";
                            } else{
                                return null;
                              }
                          },
                          onSaved: (value){
                            password2 = value!;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(child: Text('취소',style: TextStyle(color:Colors.grey),),
                    onPressed: (){
                      Navigator.pop(context);
                    },),
                    TextButton(child: Text('회원가입',style: TextStyle(color:Colors.grey),),
                      onPressed: (){
                        _submit();
                      },),
                  ],
                ))
              ],
            ),
          ),
        ),
      )
    );
  }
}
