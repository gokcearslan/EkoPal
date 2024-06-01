import 'package:flutter_test/flutter_test.dart';
import 'package:ekopal/validator.dart';

void main() {
  group('Validator', () {
    test('validateName returns error message when name is empty', () {
      String? result = Validator.validateName(name: '');
      expect(result, 'İsim boş kalamaz');
    });

    test('validateName returns null when name is not empty', () {
      String? result = Validator.validateName(name: 'John Doe');
      expect(result, null);
    });

    test('validateEmail returns error message when email is empty', () {
      String? result = Validator.validateEmail(email: '');
      expect(result, 'Mail adresi boş kalamaz, lütfen mail adresinizi giriniz');
    });

    test('validateEmail returns error message for invalid email', () {
      String? result = Validator.validateEmail(email: 'invalid-email');
      expect(result, 'Geçersiz mail adresi!');
    });

    test('validateEmail returns null for valid email', () {
      String? result = Validator.validateEmail(email: 'test@std.ieu.edu.tr');
      expect(result, null);
    });

    test('validatePassword returns error message when password is empty', () {
      String? result = Validator.validatePassword(password: '');
      expect(result, 'Şifre boş kalamaz, lütfen şifrenizi giriniz.');
    });

    test('validatePassword returns error message for short password', () {
      String? result = Validator.validatePassword(password: '123');
      expect(result, 'Şifre en az 6 karakter içermelidir');
    });

    test('validatePassword returns null for valid password', () {
      String? result = Validator.validatePassword(password: '123456');
      expect(result, null);
    });
  });
}
