

class Validator{
  static List isEmpty(String value){
    if(value.isEmpty){
      return [true, 'Enter some text'];
    }
    return [false, ''];
  }

  static List notEmail(String value){
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
    if(!emailValid){
      return [true, 'Enter a valid email address'];
    }
    return [false, ''];
  }
  static List notNumber(String value){
    if(double.tryParse(value) == null){
    return [true, 'Enter valid numeric value'];
    }
    return [false, ''];
  }
  static List notMatch(String value, String value2){
    if(value != value2){
      return [true, 'Fields do not match'];
    }
    return [false, ''];
  }
  static List min(String value, int no){
    if(value.length < no){
      return [true, 'Fields character must be greater than ${no}'];
    }
    return [false, ''];
  }
}