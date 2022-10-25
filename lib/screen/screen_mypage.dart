import 'screen_myreview.dart';
import 'package:flutter/material.dart';
import 'screen_main.dart';
import 'screen_search.dart';
import 'package:dio/dio.dart';
import 'main.dart';
import 'screen_add_res.dart';

class Mypage extends StatelessWidget {
  const Mypage({required this.token, required this.email,Key? key}) : super(key: key);
  final String token;
  final String email;


  @override
  Widget build(BuildContext context) {


    Future<void> _logout(String token,String email) async{
      var dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${token}";
      dio.options.validateStatus = (status){
        return true;
      };
      print(1);
      var response = await dio.get("https://sds-projects.herokuapp.com/accounts/logout/");
      if (response.statusCode==401){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()), (route) => false);
      } else {
        return ;
      }
    }

    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white54,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('마이페이지', style: TextStyle(color:Colors.black,
                      fontWeight: FontWeight.w400, fontSize: 30)),
                ],
              )),
          body: ListView(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  alignment: Alignment.center,
                  width: 350, height: 70,
                  margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black12
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.people_alt_rounded, size: 40),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(email),
                        ],
                      )
                    ],
                  )
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 350, height: 1,
                  margin: EdgeInsets.fromLTRB((0), 30, 0, 0),
                  decoration: BoxDecoration(
                    color: Colors.black
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 350, height: 450,
                  margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black12
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('내 정보', style: TextStyle(fontWeight: FontWeight.bold, fontSize:15),),
                      Text('비밀번호 변경'),
                      Text('로그인 이력'),
                      Text('앱 이용 안내', style: TextStyle(fontWeight: FontWeight.bold, fontSize:15),),
                      TextButton(
                        onPressed: (){
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => Add_res(token:token,email: email,)));
                        },
                          child:Text('음식점 추가 신청')),
                      TextButton(
                          onPressed: (){
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => MyReviews(token:token,email: email)));},
                          child: Text('리뷰/평점 관리', style: TextStyle(color:Colors.black)),
                      ),
                      TextButton(
                        onPressed: (){
                          _logout(token,email);},
                        child: Text('로그아웃', style: TextStyle(color:Colors.black)),
                      )
                      ]

          ),
                      ),
                ),
              ]),
        bottomNavigationBar: BottomAppBar(
          child: SizedBox(
            height: 75,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(icon:Icon(Icons.person,color:Colors.blue),onPressed: (){},),
                IconButton(icon:Icon(Icons.home),onPressed: (){
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Main(token:token,email: email,)));
                },),
                IconButton(icon:Icon(Icons.search),onPressed: (){
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Search(token:token,email: email,)));
                },),
              ],
            ),
          ),
        ),
          ),
    );
    }}
