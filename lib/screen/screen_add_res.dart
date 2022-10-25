import "package:flutter/material.dart";
import 'package:dio/dio.dart';

class Add_res extends StatelessWidget {
  const Add_res({required this.token, required this.email,Key? key}) : super(key: key);
  final String token;
  final String email;
  @override
  Widget build(BuildContext context) {
    
    final formkey = GlobalKey<FormState>();
    String name="";
    String address="";
    String phone="";
    
    Future<void> _submit() async{
      if (formkey.currentState!.validate()){
        formkey.currentState!.save();
        var dio = Dio();
        dio.options.headers["Authorization"]="Bearer ${token}";
        var response = await dio.postUri(Uri.parse("https://sds-projects.herokuapp.com/res/add/"),
        data:{"name":name,"address":address,"phone":phone});
        print(response.data);
        print(response.statusCode);
        print(response.statusMessage);
        if (response.statusCode==201){
          Navigator.pop(context);
        } else {
          return ;
        }
      } else {
        return ;
      }
    }
    
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.reply),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          title: Text("음식점 신청"),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          margin: EdgeInsets.all(15),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "음식점 이름",
                    ),
                    validator: (value){
                      if (value!.isEmpty){
                        return "입력하셔야합니다.";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value){
                      name = value!;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "주소",
                    ),
                    validator: (value){
                      if (value!.isEmpty){
                        return "입력하셔야합니다.";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value){
                      address = value!;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "전화번호",
                    ),
                    validator: (value){
                      if (value!.isEmpty){
                        return "입력하셔야합니다.";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value){
                      phone = value!;
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  child: ElevatedButton(
                    child: Text("신청"),
                    onPressed: (){
                      _submit();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
