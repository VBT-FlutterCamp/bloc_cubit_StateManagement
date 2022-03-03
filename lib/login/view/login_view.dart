import 'package:bloc_state_managament_example/login/service/login_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../viewmodel/login_cubit.dart';
import 'home_view.dart';

class LoginView extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController emaillerController = TextEditingController();
  final TextEditingController paswordController = TextEditingController();
  final String baseUrl = 'https://reqres.in/api';
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(formKey, emaillerController, paswordController,
          service: LoginService(Dio(BaseOptions(baseUrl: baseUrl)))),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginComplete) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: ((context) => HomeDetail(
                      model: state.model,
                    ))));
          }
        },
        builder: (context, state) {
          return buildScaffold(context, state);
        },
      ),
    );
  }

  Scaffold buildScaffold(BuildContext context, LoginState state) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: formKey,
        autovalidateMode: state is LoginValidateState
            ? (state.isValidate ? AutovalidateMode.always : AutovalidateMode.disabled)
            : AutovalidateMode.disabled,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildemail(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            buildPassword(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            buildLoginButton(context)
          ],
        ),
      ),
    );
  }

  Widget buildLoginButton(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is LoginComplete) {
          return const Card(
            child: Icon(Icons.check),
          );
        }
        return ElevatedButton(
            onPressed: () {
              context.read<LoginCubit>().postUserData();
            },
            child: Text('Login'));
      },
    );
  }

  TextFormField buildemail() {
    return TextFormField(
      controller: emaillerController,
      validator: (value) => (value ?? '').length > 6 ? null : '6 ten kucuk',
      decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Email '),
    );
  }

  TextFormField buildPassword() {
    return TextFormField(
      controller: paswordController,
      validator: (value) => (value ?? '').length > 5 ? null : '5 ten kucuk',
      decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Password '),
    );
  }
}
