import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:social_app/models/user_model.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    emit(RegisterInitialState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      print(value.user!.email);
      userCreate(name: name, email: email, uId: value.user!.uid, phone: phone,);
      emit(RegisterSuccessStates(value.user!.uid),);
    }).catchError((error) {
      emit(
        RegisterErrorStates(error.toString()),
      );
    });
  }

  void userCreate({
    required String name,
    required String email,
    required String uId,
    required String phone,
  }) {
    emit(UserCreateLoadingStates());
    UserModel model = UserModel(
      name: name,
      email: email,
      phone: phone,
      image:
      'https://image.freepik.com/free-photo/young-english-woman-isolated-yellow-background-doubting-shrugging-shoulders-questioning-gesture_1187-217417.jpg',
      cover:
      'https://image.freepik.com/free-photo/young-english-woman-isolated-yellow-background-shocked-pointing-with-index-fingers-copy-space_1187-217414.jpg',
      bio: 'write a bio...',
      uId: uId,
    );
    emit(UserCreateLoadingStates());
    FirebaseFirestore.instance
        .collection('user')
        .doc(uId)
        .set(
      model.toMap(),
    )
        .then((value) {
      emit(UserCreateSuccessStates());
    }).catchError((error) {
      emit(UserCreateErrorStates(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
    isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(ChangeRegisterPasswordVisibilityStates());
  }
}
