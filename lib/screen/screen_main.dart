import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:sds/model/model_res.dart';
import 'screen_unvisited_res.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'screen_res_detail.dart';
import 'screen_all.dart';
import 'screen_search.dart';
import 'screen_mypage.dart';
//void main(){
//  runApp(const Main(token:"123"));
//}

class Main extends StatefulWidget {
  const Main({required this.token, required this.email,Key? key}) : super(key: key);
  final token;
  final email;

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {

  List<Res> All =[];
  List<Res> unvisited = [];
  String messages = "음식점의 점수를 하나라도 남겨주세요.";
  Future<void> _fetchRes(var token) async {
    setState(() {
      //isLoading=true;
    });
    var dio = Dio();
    dio.options.headers["Authorization"] = "Bearer ${token}";
    var response = await dio.get("http://sds-projects.herokuapp.com/res/");
    if (response.data[0]==messages){} else {
    unvisited = (response.data[0]).map<Res>((json){
      return Res.fromJson(json);
    }).toList();}
    All = (response.data[1]).map<Res>((json){
      return Res.fromJson(json);
    }).toList();
    if(response.statusCode ==200) {
      setState(() {
        //isLoading=false;
      });
    } else {
      throw Exception('failed to load data');
    }}


  @override
  Widget build(BuildContext context) {
    _fetchRes(widget.token);
    return MaterialApp(
      title:'Main',
      home: Scaffold(
        appBar: AppBar(
          title: Text("오늘 뭐 먹지"),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              Flexible(flex:1,child: Container(
                padding: const EdgeInsets.fromLTRB(60, 30,60 , 15),
                child: Column(
                  children: [
                    Flexible(flex:1,child:Container(
                      alignment: Alignment.centerLeft,
                      color: Colors.blue,
                      child: TextButton(
                        child:Text('개인화 추천 음식점 5선',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400),),
                        onPressed: (){
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => unvisited_res(token:widget.token,email:widget.email)));
                      },),
                    )),
                    Flexible(
                      flex:6,
                      child: ListView(
                        children:[
                          for(var i=0;i<((unvisited.length<5)?unvisited.length:5);i++)
                            Container(
                              decoration: BoxDecoration(border: Border.all(color: Colors.black,width: 0.01)),
                              width: double.infinity,
                              height: 30,
                              child:
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(height:double.infinity,width:250,alignment: Alignment.center,
                                        child: Container(
                                          child: TextButton(child:Text('${unvisited[i].name}',style: TextStyle(fontSize: 20),),
                                          onPressed: (){
                                            Navigator.push(
                                                context, MaterialPageRoute(builder: (context) => res_detail(token:widget.token,res_id:unvisited[i].id,email: widget.email,)));
                                          },),
                                        )),
                                    Expanded(
                                      child: Container(
                                        height:double.infinity,
                                        width: double.infinity,
                                        alignment: Alignment.centerRight,
                                        child: RatingBar.builder(
                                        initialRating: (unvisited[i].score)/2,
                                        minRating: 0,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: 20,
                                        itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.blue,
                                        ),
                                        onRatingUpdate: (rating) {
                                          print(rating);
                                        },
                                    ),
                                      ),),
                                  ],
                                )
                            )
                        ],
                      ),
                    )
                  ],
                ),
              )),
              Flexible(flex:1,child: Container(
                padding: const EdgeInsets.fromLTRB(60, 15, 60, 30),
                child: Column(
                  children: [
                    Flexible(flex:1,child: Container(
                        alignment: Alignment.centerLeft,
                        color: Colors.blue,
                        child: TextButton(
                          child:Text('최대 평점 음식점 5선',style: TextStyle(color:Colors.white,fontWeight: FontWeight.w400),),
                          onPressed: (){
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => res_All(token:widget.token,email: widget.email,)));
                    },))),
                    Flexible(
                      flex: 5,
                      child: ListView(
                        children:[
                          for(var i=0;i<((All.length<5)?All.length:5);i++)
                            Container(
                                decoration: BoxDecoration(border: Border.all(color: Colors.black,width: 0.01)),
                                width: double.infinity,
                                height: 30,
                                alignment: Alignment.center,
                                child:
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(height:double.infinity,width: 250,alignment: Alignment.center,
                                        child: TextButton(child:Text('${All[i].name}',style: TextStyle(fontSize: 20),),
                                        onPressed: (){
                                          Navigator.push(
                                              context, MaterialPageRoute(builder: (context) => res_detail(token:widget.token,res_id:All[i].id,email: widget.email,)));
                                        },)),
                                    Expanded(
                                        child: Container(
                                          height: double.infinity,
                                          width: double.infinity,
                                          alignment: Alignment.centerRight,
                                          child: RatingBar.builder(
                                            initialRating: (All[i].score)/2,
                                            minRating: 0,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemSize: 20,
                                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Colors.blue,
                                            ),
                                            onRatingUpdate: (rating) {
                                              print(rating);
                                            },
                                          ),
                                        ),),
                                  ],
                                )
                            )
                        ],
                      ),
                    )
                  ],
                ),
              )),
            ],
          )
        ),
        bottomNavigationBar: BottomAppBar(
          child: SizedBox(
            height: 75,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(icon:Icon(Icons.person),onPressed: (){
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Mypage(token:widget.token,email: widget.email,)));
                },),
                IconButton(icon:Icon(Icons.home,color:Colors.blue),onPressed: (){},),
                IconButton(icon:Icon(Icons.search),onPressed: (){
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Search(token:widget.token,email: widget.email,)));
                },),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
