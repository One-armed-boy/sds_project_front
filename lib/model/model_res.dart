class Res {
  String name;
  int id;
  String? phone;
  String? address;
  double score=0;

  Res(this.name,
      this.id,
      this.phone,
      this.address,
      this.score,
      );

  Res.fromMap(Map<String, dynamic> map)
    : name = map['title'],
      //address = map['address'],
      //phone = map['phone'],
      score = map['score'],
      id = map['id'];


  Res.fromJson(Map<String, dynamic> json)
    : name = (json.containsKey('res'))?json['res']:json['name'],
      id = json['id'],
      phone = json['phone']==null ? "":json['phone'],
      address = json['address']==null ? "":json['address'],
      score = (json.containsKey('score')==false) ? 0:((json['score']==null)?0:json['score']) ;

//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['name']=this.name;
 //   data['id']=this.id;
//    data['phone']=this.phone;
//    data['address']=this.address;
//    return data;
//  }
}