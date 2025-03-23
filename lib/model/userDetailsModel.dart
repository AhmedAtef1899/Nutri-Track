
class UserDetailsModel
{
  String? age;
  String? height;
  String? weight;
  String? health;

  UserDetailsModel(this.age,this.health,this.height,this.weight);

  UserDetailsModel.fromJson(Map<String,dynamic>json){
    age = json['age'];
    height = json['height'];
    weight = json['weight'];
    health = json['health'];
  }

  Map<String,dynamic>toMap(){
    return {
      'age' : age,
      'height' : height,
      'weight' : weight,
      'health' : health,
    };
  }
}