part of 'login_cubit.dart';

final class LoginState extends Equatable {
  const LoginState({
    this.name = '',
    this.email = const Email.pure(),
    this.password = const Password.dirty('Password123'),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errorMessage,
    this.teamName = '',
  });

  final String name;
  final Email email;
  final Password password;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;
  final String teamName;

  @override
  List<Object?> get props =>
      [email, password, status, isValid, errorMessage, teamName, name];

  LoginState copyWith({
    String? name,
    Email? email,
    Password? password,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
    String? teamName,
  }) {
    return LoginState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
      teamName: teamName ?? this.teamName,
    );
  }
}
