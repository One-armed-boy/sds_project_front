import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sds/model/model_review.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';


class Reviews extends StatefulWidget {
  const Reviews({required this.token, required this.email,required this.res_id,Key? key}) : super(key: key);
  final String token;
  final String email;
  final int res_id;

  @override
  _ReviewsState createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {

  List<Review> reviews=[];

  Future<void> _fetchRev() async{
    var dio = Dio();
    dio.options.headers["Authorization"] = "Bearer ${widget.token}";
    var response = await dio.get("https://sds-projects.herokuapp.com/res/${widget.res_id}/review/");
    if (response.statusCode==200){
      if (response.data!="없다."){
        setState(() {
          reviews = (response.data).map<Review>((json){
            return Review.fromJson(json);
          }).toList();
        });
      }
    } else {
    }
  }

  @override
  Widget build(BuildContext context) {
    _fetchRev();
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(icon:Icon(Icons.reply), onPressed: (){Navigator.pop(context);},),
          title: const Text('전체 리뷰'),
        ),
        body: ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: reviews.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              width: 300,
              color: Colors.white60,
              child: Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 13,),
                          Text(reviews[index].author,style: TextStyle(fontSize: 15, ),),
                          SizedBox(width: 13,),
                          Text(DateFormat.yMMMd('en_US').format(reviews[index].create_date), style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey
                          ),
                          ),
                          SizedBox(width: 5,),
                          RatingBarIndicator(
                            rating: reviews[index].score/2, //already_review_score/2, // 여기에 기존에 입력된 별점데이터 넣으면 됨
                            itemBuilder: (context,index) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 15,
                            direction: Axis.horizontal,),

                        ],
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 15),
                        width: double.maxFinite,
                        child: RichText(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 10,
                          strutStyle: StrutStyle(fontSize: 10),
                          text: TextSpan(
                              text: reviews[index].comment,
                              style: TextStyle(
                                  height: 1.5,
                                  fontSize: 15
                              )
                          ),

                        ) ,
                      )

                    ],
                  )),
            );
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(),
        )
      //padding: const EdgeInsets.all(12),
      //itemCount: entries.length,
      //itemBuilder: (BuildContext context, int index) {
      //return Container()

    );
  }
}

