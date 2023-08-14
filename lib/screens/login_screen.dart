import 'package:adocao/screens/create_account.dart';
import 'package:adocao/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// appineedhelp@gmail.com
// senhas123

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final controllerPassword = TextEditingController();
  final controllerEmail = TextEditingController();

  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Adoção de animais',
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.15,
                bottom: MediaQuery.of(context).size.height * 0.15,
              ),
              alignment: Alignment.center,
              child: Text(
                'Faça o login',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: TextFormField(
                controller: controllerEmail,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 20.0,
              ),
              child: TextFormField(
                controller: controllerPassword,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  suffixIcon: IconButton(
                    icon: Icon(
                      // mostra/esconde senha
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.pink,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 40),
                  enableFeedback: true,
                ),
                onPressed: () async {
                  try {
                    // se der certo o login com o email e senha, chama a tela de HomeScreen
                    UserCredential userCredential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: controllerEmail.text,
                            password: controllerPassword.text);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                    );
                  } on FirebaseAuthException catch (e) {
                    // se o código retornado do Firebase for user-not-found, retornar para o usuário o erro
                    if (e.code == 'user-not-found') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Senha/Email não conferem."),
                        ),
                      );
                      // se o código retornado do Firebase for wrong-password, retornar para o usuário o erro
                    } else if (e.code == 'wrong-password') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Senha/Email não conferem."),
                        ),
                      );
                    }
                    // se o código retornado do Firebase for nenhuma das acima, retornar para o usuário o erro
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Senha/Email não conferem."),
                      ),
                    );
                  }
                },
                child: Text('Entrar'),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 15.0,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 40),
                  enableFeedback: true,
                ),
                onPressed: () {
                  // Clicar no botão 'Criar conta' chama a tela CreateAccount
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateAccount(),
                    ),
                  );
                },
                child: Text('Criar conta'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
