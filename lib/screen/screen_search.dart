import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:sds/model/model_res.dart';
import 'screen_main.dart';
import 'screen_res_detail.dart';
import 'screen_mypage.dart';

class Search extends StatefulWidget {
  const Search({required this.token,required this.email,Key? key}) : super(key: key);
  final String token;
  final String email;

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  List<Res> res=[];
  String kw="";

  final formkey = GlobalKey<FormState>();

  
  Future<void> _submit(var token) async{
    formkey.currentState!.save();
    if (formkey.currentState!.validate()){
      var dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${token}";
      String encoded_kw = Uri.encodeComponent(kw);
      var response = await dio.getUri(Uri.parse("https://sds-projects.herokuapp.com/res/search/kw=${encoded_kw}/"));
      if (response.statusCode==404||response.data=="검색결과가 존재하지 않습니다."){
        setState(() {
          res=[];
        });
      } else{
        setState(() {
          res = (response.data).map<Res>((json){
            return Res.fromJson(json);
          }).toList();
        });
      }
    } else {
      return;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:'search',
      home: Scaffold(
        body:Column(
          children: [
            Container(
              width: double.infinity,
              height: 100,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key:formkey,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.go,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "검색",
                          ),
                          validator: (value){
                            if(value!.isEmpty){
                              return "입력해주세요.";
                            }
                            return null;
                          },
                          onSaved: (value){
                            kw = value!;
                          },
                          onFieldSubmitted: (value){
                            _submit(widget.token);
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 100,
                    child: IconButton(icon:Icon(Icons.arrow_forward),onPressed: (){
                      _submit(widget.token);
                    },),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: (res.length!=0) ? [
                  for(var i=0;i<res.length;i++)
                    Container(
                      height: 50,
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(border: Border.all(color: Colors.black,width: 0.05)),
                      child: TextButton(child: Text('${res[i].name}'),onPressed: (){
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => res_detail(token:widget.token,res_id:res[i].id,email: widget.email,)));
                      },),
                    )
                ]:[Text("검색결과가 존재하지 않습니다.")],
              ),
            ),
          ],
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
                IconButton(icon:Icon(Icons.home),onPressed: (){
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Main(token:widget.token,email: widget.email,)));
                },),
                IconButton(icon:Icon(Icons.search,color:Colors.blue),onPressed: (){},),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
