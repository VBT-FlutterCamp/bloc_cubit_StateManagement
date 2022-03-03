import 'package:bloc/bloc.dart';
import 'package:bloc_state_managament_example/login/model/login_request_model.dart';
import 'package:bloc_state_managament_example/login/model/login_response_model.dart';
import 'package:bloc_state_managament_example/login/service/login_service.dart';
import 'package:flutter/cupertino.dart';

class LoginCubit extends Cubit<LoginState> {
  final GlobalKey<FormState> formkey;

  final TextEditingController emaillerController;
  final TextEditingController paswordController;

  final ILoginService service;

  bool isLoginFail = false;
  bool isLoading = false;
  LoginCubit(this.formkey, this.emaillerController, this.paswordController, {required this.service})
      : super(LoginInitial());

  Future<void> postUserData() async {
    if (formkey.currentState?.validate() ?? false) {
      changceLoding();
      final data = await service
          .postUserData(LoginRequestModel(email: emaillerController.text, password: paswordController.text));

      changceLoding();
      if (data is LoginResponseModel) {
        emit(LoginComplete(data));
      }
    } else {
      isLoginFail = true;
      emit(LoginValidateState(isLoginFail)); //state sayfada güncellemek için
    }
  }

  void changceLoding() {
    isLoading = !isLoading;

    emit(LoginLoadingState(isLoading));
  }
}

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginComplete extends LoginState {
  final LoginResponseModel model;

  LoginComplete(this.model);
}

class LoginValidateState extends LoginState {
  final bool isValidate;

  LoginValidateState(this.isValidate);
}

class LoginLoadingState extends LoginState {
  final bool isLoading;

  LoginLoadingState(this.isLoading);
}
