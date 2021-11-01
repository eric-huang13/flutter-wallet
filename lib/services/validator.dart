final RegExp _emailRegex =
RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

// must contain a-z A-Z _!@#$%^&*()= and can contain digits
final RegExp _passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[_!@#$%^&*()=])[A-Za-z\d_!@#$%^&*()=]{8,21}$');

final EmailValidator emailValidator = const EmailValidator();
final PasswordValidator passwordValidator = const PasswordValidator();

class EmailValidator {
  const EmailValidator();

  bool email(String input) => _emailRegex.hasMatch(input);
}

class PasswordValidator{
  const PasswordValidator();
  bool password(String input) => _passwordRegex.hasMatch(input);
}
