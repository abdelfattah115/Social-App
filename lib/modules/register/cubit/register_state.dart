part of 'register_cubit.dart';

@immutable
abstract class RegisterState {}

class RegisterInitialState extends RegisterState {}

class RegisterLoadingStates extends RegisterState {}
class RegisterSuccessStates extends RegisterState {
  final String? uId;

  RegisterSuccessStates(this.uId);
}
class RegisterErrorStates extends RegisterState {
  final String error;

  RegisterErrorStates(this.error);
}

class UserCreateLoadingStates extends RegisterState {}
class UserCreateSuccessStates extends RegisterState {}
class UserCreateErrorStates extends RegisterState {
  final String error;

  UserCreateErrorStates(this.error);
}

class ChangeRegisterPasswordVisibilityStates extends RegisterState {}
