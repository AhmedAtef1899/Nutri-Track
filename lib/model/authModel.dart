
class AuthModel{
   String? name;
   String? location;
   String? email;
   String? password;
   String? uId;

  AuthModel(this.name,  this.location,  this.email,  this.password,  this.uId);

  AuthModel.fromJson(Map<String,dynamic>json){
    name = json['name'];
    location = json['location'];
    email = json['email'];
    password= json['password'];
    uId= json['uId'];
  }

  Map<String,dynamic> toMap(){
    return {
      'name' : name,
      'location' : location,
      'email' : email,
      'password' : password,
      'uId' : uId,
    };
  }
}