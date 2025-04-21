
class UserDetailsModel
{
  String? age;
  String? height;
  String? weight;
  String? health;
  String? gender;
  String? bmi;

  UserDetailsModel(this.age,this.health,this.height,this.weight,this.gender,this.bmi);

  UserDetailsModel.fromJson(Map<String,dynamic>json){
    age = json['age'];
    height = json['height'];
    weight = json['weight'];
    health = json['health'];
    gender = json['gender'];
    bmi = json['bmi'];
  }

  Map<String,dynamic>toMap(){
    return {
      'age' : age,
      'height' : height,
      'weight' : weight,
      'health' : health,
      'gender' : gender,
      'bmi' : bmi,
    };
  }
}