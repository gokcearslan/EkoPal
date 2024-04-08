class Validator {
  static String? validateName({required String name}) {
    if (name.isEmpty) {
      return 'İsim boş kalamaz';
    }
    return null;
  }

  static String? validateEmail({required String email}) {
    RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@(std\.ieu\.edu\.tr|std\.izmirekonomi\.edu\.tr|ieu\.edu\.tr|izmirekonomi\.edu\.tr)$",
    );

    if (email.isEmpty) {
      return 'Mail adresi boş kalamaz, lütfen mail adresinizi giriniz';
    } else if (!emailRegExp.hasMatch(email)) {
      return 'Geçersiz mail adresi!';
    }
    return null;
  }

  static String? validatePassword({required String password}) {
    if (password.isEmpty) {
      return 'Şifre boş kalamaz, lütfen şifrenizi giriniz.';
    } else if (password.length < 6) {
      return 'Şifre en az 6 karakter içermelidir';
    }
    return null;
  }
}
