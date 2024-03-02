class Validator {
  static String? validateName({required String name}) {
    if (name == null) {
      return null;
    }if(name.isEmpty){
      return 'Lütfen İsim giriniz';
    }
    return null;
  }
  static String? validateEmail({required String email}) {
    if (email == null) {
      return null;
    }
    RegExp emailRegExp = RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    if (email.isEmpty) {
      return 'Lütfen mailinizi giriniz';
    } else if(!emailRegExp.hasMatch(email)){
      return 'GEçerli bir mail giriniz';
    }
    return null;
  }
  static String? validatePassword({required String password}) {
    if (password == null) {
      return null;
    }
    if (password.isEmpty) {
      return 'Lütfen şifenizi giriniz';
    } else if (password.length < 6) {
      return 'Şifre en az 6 karakterden oluşmalıdır';
    }
    return null;
  }
}
