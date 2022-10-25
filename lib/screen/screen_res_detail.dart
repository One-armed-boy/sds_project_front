import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sds/model/model_review.dart';
import 'package:intl/intl.dart';
import 'screen_res_review.dart';

//void main() {
//  runApp(const res_detail()); //runApp: 앱 구동시켜주세요~
//}

class res_detail extends StatefulWidget {
  const res_detail({required this.token,required this.res_id,required this.email,Key? key}) : super(key: key);
  final int res_id;
  final token;
  final String email;
  @override
  _res_detailState createState() => _res_detailState();
}

class _res_detailState extends State<res_detail> {

  final formkey=GlobalKey<FormState>();
  var res={};

  double review_score=0;
  String review_text="";
  bool is_review=false;
  //double already_review_score=0;
  //String already_review_text="";
  bool is_modify=false;
  DateTime create_date=DateTime.now();
  double next_score=-1;

  @override
  void setState(fn){
    if (this.mounted){
      super.setState(fn);
    }
  }


  Future<void> _fetchRes(var token,var res_id) async {
    var dio = Dio();
    dio.options.headers["Authorization"] = "Bearer ${token}";
    var response = await dio.get("http://sds-projects.herokuapp.com/res/${res_id}");
    setState(() {
      res = response.data;
      res["score"] = double.parse(res["score"].toStringAsFixed(2));
    });
    if(response.statusCode ==200) {
      var rev_response = await dio.get("http://sds-projects.herokuapp.com/res/${res_id}/review/");
      List<Review> review = (rev_response.data).map<Review>((json){
        return Review.fromJson(json);
      }).toList();
      for(var i=0;i<review.length;i++){
        if (review[i].author == widget.email){
          setState(() {
            is_review=true;
            //already_review_text=review[i].comment;
            //already_review_score=review[i].score;
            review_score=review[i].score;
            review_text = review[i].comment;
            create_date=review[i].create_date;
          });
          break;
        }
      }
    } else {
      throw Exception('failed to load data');
    }
  }

  Future<void> _submit(int code) async{
    if (code==0){ //code==0 => create
      formkey.currentState!.save();
      var dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${widget.token}";
      var response = await dio.postUri(Uri.parse("http://sds-projects.herokuapp.com/res/scoring/create/"),
          data:{"author":widget.email,"res":widget.res_id,"score":review_score,"comment":review_text}); // 여기
      if(response.statusCode ==200) {
        setState(() {});
      } else {
        throw Exception('failed to load data');
      }
    } else if(code==1){ //code ==1 => update
      formkey.currentState!.save();
      var dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${widget.token}";
      print("update plz!: ${{"author":widget.email,"res":widget.res_id,"score":review_score,"comment":review_text,"create_date":create_date.toIso8601String()}}");
      var response = await dio.putUri(Uri.parse("http://sds-projects.herokuapp.com/res/scoring/update/"),
          data:{"author":widget.email,"res":widget.res_id,"score":(next_score!=-1)?next_score:review_score,"comment":review_text,"create_date":create_date.toIso8601String()});
      if(response.statusCode ==200) {
        setState(() {
          next_score=-1;
          is_modify=false;
        });
      } else {
        throw Exception('failed to load data');
      }
    } else { //code ==2 => delete
      var dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${widget.token}";
      var response = await dio.delete("https://sds-projects.herokuapp.com/res/scoring/delete/${widget.res_id}");
      if (response.statusCode==204){
        setState(() {
          is_review=false;
          review_score=0;
          review_text="";
        });
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    _fetchRes(widget.token, widget.res_id);
    return MaterialApp(
        home: Scaffold(
            body: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: 300,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Image.asset('khu.jpg',fit: BoxFit.cover,),
                    ),
                    leading: IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.reply),
                    ),
                  ),
                  SliverList(
                      delegate: SliverChildListDelegate(
                          [
                            Container(
                                height: 250,
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 2,horizontal: 30),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  child:Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('${res['name']}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 40),),
                                        Row(
                                          children: [
                                            Icon(Icons.star,color: Colors.yellow,size: 20,),
                                            Text(' ${res['score']}',style: TextStyle(fontSize: 20),),
                                          ],
                                        ),
                                        Text('${res['address']}',style: TextStyle(fontSize: 15),),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Row(children: [Icon(Icons.phone),Text('전화')],),
                                            Row(children: [Icon(Icons.favorite),Text('찜하기')],),
                                            Row(children: [Icon(Icons.wifi_protected_setup),Text('공유')],),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),)
                            ),
                            (is_review==true)?(is_modify==false)?Container( // 나의 리뷰(리뷰 써놨을 경우)
                              height: 300,
                              width: double.maxFinite,
                              child: Column(
                                children: [
                                  SizedBox(height: 5,),
                                  Text('나의 별점', style: TextStyle(
                                      color: Colors.lightBlue,
                                      fontSize: 15
                                  ),),
                                  SizedBox(height: 5,),
                                  RatingBarIndicator(
                                    rating: review_score/2, // 여기에 기존에 입력된 별점데이터 넣으면 됨
                                    itemBuilder: (context,index) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    itemSize: 18,
                                    direction: Axis.horizontal,),
                                  Container(
                                    margin: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(color: Colors.blue,width: 0.1)
                                    ),
                                    child: Column(
                                      children: [
                                        Container( // 이 컨테이너에 기존 리뷰 글 넣으면 됨
                                            height: 80,
                                            padding: EdgeInsets.all(12),
                                            width: double.maxFinite,
                                            alignment: Alignment.centerLeft,

                                            child: Text(
                                                review_text
                                            )
                                        ),
                                        Container(
                                          height: 20,
                                          width: double.maxFinite,
                                          alignment: Alignment.topRight,
                                          margin: EdgeInsets.all(12),
                                          child: Text(DateFormat.yMMMd('en_US').format(create_date)),
                                        ),
                                      ],
                                    ),),
                                  Container(
                                    margin: EdgeInsets.all(12),
                                    alignment: Alignment.centerRight,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(onPressed: (){
                                          setState(() {
                                            is_modify=true;
                                          });
                                        },
                                          child: Text('수정하기'),
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.lightBlueAccent,),),
                                        SizedBox(width: 5,),
                                        ElevatedButton(onPressed: (){
                                          _submit(2);
                                        },
                                          child: Text('삭제하기'),
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.lightBlueAccent),)
                                      ],
                                    ),
                                  )
                                ],
                              ),):Container( //이미 리뷰를 남긴 사람들 중 수정하기를 눌렀을 때
                              height: 300,
                              width: double.maxFinite,
                              child: Column(
                                children: [
                                  SizedBox(height: 5,),
                                  Text('나의 별점', style: TextStyle(
                                      color: Colors.lightBlue,
                                      fontSize: 15
                                  ),),
                                  SizedBox(height: 5,),
                                  RatingBar.builder(
                                      initialRating: review_score/2,
                                      minRating: 0,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemSize: 18,
                                      itemCount: 5,
                                      //itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {
                                        print(rating);
                                        next_score=rating*2;
                                      }
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(12),
                                    child: Form(
                                      key:formkey,
                                      child: Container( // 이 컨테이너에 기존 리뷰 글 넣으면 됨
                                          height: 100,
                                          margin: EdgeInsets.all(12),
                                          width: double.maxFinite,
                                          alignment: Alignment.centerLeft,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              border: Border.all(color: Colors.blue,width: 3)
                                          ),
                                          child: TextFormField(
                                            initialValue: review_text,
                                            keyboardType: TextInputType.text,
                                            maxLines: 5,
                                            decoration: InputDecoration(
                                              fillColor: Colors.grey[300],
                                              filled: true,
                                            ),
                                            onSaved: (value){
                                              review_text=value!; //여기
                                            },
                                          )
                                      ),
                                    ),),
                                  Container(
                                    margin: EdgeInsets.all(12),
                                    alignment: Alignment.centerRight,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(onPressed: (){
                                            _submit(1);
                                        },
                                          child: Text('완료'),
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.lightBlueAccent,),),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ):Container( //리뷰를 남기지 않았을 때
                              //color: Colors.black,
                              height: 200,
                              child: Form(
                                key:formkey,
                                child: Column(
                                  children: [
                                    SizedBox(height: 5,),
                                    Text('별점 남기기',
                                      style: TextStyle(
                                          color: Colors.lightBlue,
                                          fontSize: 15
                                      ),),
                                    SizedBox(height: 5),
                                    RatingBar.builder(
                                        initialRating: 0,
                                        minRating: 0,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemSize: 18,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {
                                          print(rating);
                                          review_score=rating*2; //여기
                                        }
                                    ),
                                Container(
                                  margin: EdgeInsets.all(12),
                                  height: 5 * 19.0,
                                  alignment: Alignment.centerLeft,
                                  child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      maxLines: 5,
                                      decoration: InputDecoration(
                                        hintText: "리뷰를 남겨주세요.",
                                        fillColor: Colors.grey[300],
                                        filled: true,
                                      ),
                                      onSaved: (value){
                                        review_text = value!; //여기
                                      }
                                  ),
                                ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 12, 0),
                                      alignment: Alignment.centerRight,
                                      child: ElevatedButton(onPressed: (){
                                        _submit(0);
                                      },
                                        child: Text('입력완료'),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.lightBlueAccent,
                                        ),),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              decoration: BoxDecoration(border: Border.all(color: Colors.black,width: 0.05)),
                              height: 50,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: TextButton(onPressed: (){
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => Reviews(token:widget.token,email: widget.email,res_id: widget.res_id,)));
                              },
                                child: Text('리뷰 전체보기',style: TextStyle(color:Colors.blue),),
                                ),
                              ),
                          ]
                      )
                  )
                ]
            )
        )
    );
  }
}
