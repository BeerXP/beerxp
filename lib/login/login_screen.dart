import 'package:beerxp/main_old.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: '',
      logo: 'assets/images/logo.png',
      onLogin: (_) => Future(null),
      onSignup: (_) => Future(null),
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MyHomePage(),
        ));
      },
      onRecoverPassword: (_) => Future(null),
      messages: LoginMessages(
        usernameHint: 'Usuário',
        passwordHint: 'Senha',
        confirmPasswordHint: 'Confirmação',
        loginButton: 'LOG IN',
        signupButton: 'REGISTRO',
        forgotPasswordButton: 'Esqueceu sua senha?',
        goBackButton: 'VOLTAR',
        confirmPasswordError: 'As senhas não combinam!',
        recoverPasswordIntro: 'Recupere sua senha aqui',
        recoverPasswordDescription:
            'As instruções serão enviadas por e-mail',
        recoverPasswordButton: 'AJUDA',
        recoverPasswordSuccess: 'Password rescued successfully',
      ),
    );
  }
}