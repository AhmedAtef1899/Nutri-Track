
class AuthModel{
   String? name;
   String? location;
   String? email;
   String? uId;

  AuthModel(this.name,  this.location,  this.email, this.uId);

  AuthModel.fromJson(Map<String,dynamic>json){
    name = json['name'];
    location = json['location'];
    email = json['email'];
    uId= json['uId'];
  }

  Map<String,dynamic> toMap(){
    return {
      'name' : name,
      'location' : location,
      'email' : email,
      'uId' : uId,
    };
  }
}