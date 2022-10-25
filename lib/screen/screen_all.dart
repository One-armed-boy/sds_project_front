import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:sds/model/model_res.dart';
import 'screen_res_detail.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'screen_main.dart';
import 'screen_search.dart';
import 'screen_mypage.dart';

class res_All extends StatefulWidget {
  const res_All({required this.token,required this.email,Key? key}) : super(key: key);
  final String token;
  final String email;
  @override
  State<res_All> createState() => _res_AllState();
}

class _res_AllState extends State<res_All> {

  List<Res> res=[];
  bool isLoading=false;


  Future<void> _fetchRes(var token) async {
    setState(() {
      isLoading=true;
    });
    var dio = Dio();
    dio.options.headers["Authorization"] = "Bearer ${token}";
    var response = await dio.get("http://sds-projects.herokuapp.com/res/all/");
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
    _fetchRes(widget.token);
    return MaterialApp(
        title: 'res_All',
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
                  decoration: BoxDecoration(
                      border: Border.all(color:Colors.black,width: 0.01,)
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        Container(child: TextButton(child:Text('${res[i].name}',style:TextStyle(fontWeight: FontWeight.w900)),
                        onPressed: (){
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => res_detail(token:widget.token,res_id:res[i].id,email: widget.email,)));
                        },),width: 180,alignment: Alignment.center,),
                        Expanded(child: Container(child: RatingBar.builder(
                          initialRating: (res[i].score)/2,
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
                        ),alignment: Alignment.centerRight,)),
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
                        context, MaterialPageRoute(builder: (context) => Main(token:widget.token,email:widget.email)));
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
