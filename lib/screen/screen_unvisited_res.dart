import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:sds/model/model_res.dart';
import 'screen_mypage.dart';
import 'screen_res_detail.dart';
import 'screen_main.dart';
import 'screen_search.dart';
import 'screen_mypage.dart';

//void main() {
//  runApp(const unvisited_res()); //runApp: 앱 구동시켜주세요~
//}

class unvisited_res extends StatefulWidget {
  const unvisited_res({required this.token,required this.email,Key? key}) : super(key: key);
  final String token;
  final String email;
  @override
  _unvisited_resState createState() => _unvisited_resState();
}

class _unvisited_resState extends State<unvisited_res> {

  List<Res> res=[];
  bool isLoading=false;


  Future<void> _fetchRes(var token) async {
    setState(() {
      isLoading=true;
    });
    var dio = Dio();
    dio.options.headers["Authorization"] = "Bearer ${token}";
    var response = await dio.get("http://sds-projects.herokuapp.com/res/recommendation/");
    res = (response.data).map<Res>((json){
      return Res.fromJson(json);
    }).toList();
    if(response.statusCode ==200) {
      setState(() {
        isLoading=false;
      });
    } else {
      throw Exception('failed to load data');
    }
  }
  @override
  Widget build(BuildContext context) {
    //Size screenSize = MediaQuery.of(context).size;
    //double width = screenSize.width;
    //double height = screenSize.height;
    _fetchRes(widget.token);
    return MaterialApp(
      title: 'Unvisited',
        home: Scaffold(
          appBar: AppBar(
            leading: Icon(Icons.list),
            title: Text('오늘머먹지'),
            actions: [Icon(Icons.person),],
          ),
            body: ListView(
              children: [
                for(var i=0;i<res.length;i++)
                  Container(
                    height: 50,
                    width: double.infinity,
                      decoration: BoxDecoration(border: Border.all(color:Colors.black,width: 0.01,)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                          Container(child: TextButton(child:Text('${res[i].name}',style:TextStyle(fontWeight: FontWeight.w900)),
                          onPressed: (){
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => res_detail(token:widget.token,res_id:res[i].id,email:widget.email)));
                          },),width: 180,alignment: Alignment.center,),
                          Expanded(child: Container(child: Text('추천지수: ${res[i].score.toStringAsFixed(2)}'),alignment: Alignment.centerRight,)),

                        ]
                      ),
                  )
              ],
            ),
            bottomNavigationBar:  BottomAppBar(
              child: SizedBox(
                height: 75,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(icon:Icon(Icons.person),onPressed: (){
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => Mypage(token:widget.token,email: widget.email,)));
                    },),
                    IconButton(icon:Icon(Icons.home),onPressed: (){
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => Main(token:widget.token,email:widget.token)));
                    },),
                    IconButton(icon:Icon(Icons.search),onPressed: (){
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => Search(token:widget.token,email:widget.email)));
                    },),
                  ],
                ),
              ),
            ),
        )
    );
  }
}
