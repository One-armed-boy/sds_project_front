class Review{
  int res_id;
  String author;
  double score;
  String comment;
  DateTime create_date;

  Review(this.res_id, this.author, this.score, this.comment,this.create_date);

  Review.fromJson(Map<String, dynamic> json)
      : res_id = json['res'],
        author = json['author'],
        score = json['score'],
        comment = (json['comment'] != "")?json["comment"]:"",
        create_date = DateTime.parse(json["create_date"]);



  Map<String,dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String,dynamic>();
    data['res_id']=this.res_id;
    //data['user_id']=this.user_id;
    data['score']=this.score;
    //data['review']=this.review;
    return data;
}}