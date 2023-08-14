import 'dart:convert';

import 'package:adocao/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:crypto/crypto.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final controllerPassword = TextEditingController();
  final controllerConfirmPassword = TextEditingController();
  final controllerEmail = TextEditingController();
  final controllerName = TextEditingController();
  final controllerAddress = TextEditingController();
  final controllerCPF = TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  bool? isCNPJ = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                top: 55.0,
              ),
              child: Text(
                'Crie sua conta',
                style: TextStyle(
                  fontSize: 35.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 15.0,
              ),
              child: TextFormField(
                controller: controllerName,
                decoration: InputDecoration(labelText: 'Nome'),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 15.0,
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
                      // atualiza a variável _passwordVisible para mostrar ou não a senha
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 15.0,
              ),
              child: TextFormField(
                controller: controllerConfirmPassword,
                obscureText: !_confirmPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Confirme a senha',
                  suffixIcon: IconButton(
                    icon: Icon(
                      // mostra/esconde senha
                      _confirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.pink,
                    ),
                    onPressed: () {
                      // atualiza a variável _passwordVisible para mostrar ou não a senha
                      setState(() {
                        _confirmPasswordVisible = !_confirmPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 15.0,
              ),
              child: TextFormField(
                controller: controllerEmail,
                decoration: InputDecoration(labelText: 'E-mail'),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 15.0,
              ),
              child: TextFormField(
                controller: controllerAddress,
                decoration: InputDecoration(labelText: 'Endereço'),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 15.0,
              ),
              child: TextFormField(
                controller: controllerCPF,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'CPF ou CNPJ',
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 50.0,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 40),
                  enableFeedback: true,
                ),
                onPressed: () async {
                  // verifica se os campos estão vazios para poder salvar no Firestore
                  if (emptyFields()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Existem campos vazios."),
                      ),
                    );
                  } else {
                    // verifica se os campos senha e confirmar senha são iguais para poder salvar no Firestore
                    if (controllerConfirmPassword.text
                        .contains(controllerPassword.text)) {
                      try {
                        // cria o usuário no Authentication do Firebase com email e senha
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .createUserWithEmailAndPassword(
                                email: controllerEmail.text,
                                password: controllerPassword.text);
                        // salva no banco de dados Firestore
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(userCredential.user!.uid)
                            .set({
                          'id': userCredential.user!.uid,
                          'email': controllerEmail.text.toString(),
                          'password': textToMd5(
                              controllerConfirmPassword.text.toString()),
                          'name': controllerName.text,
                          'cpf': controllerCPF.text,
                          'address': controllerAddress.text.toString()
                        });

                        // após criar e salvar no banco de dados, manda o usuário para a Home screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(
                              userId: userCredential.user!.uid,
                            ),
                          ),
                        );
                      } on FirebaseAuthException catch (e) {
                        // se der algum erro, retorna o mesmo para o usuário
                        if (e.code == 'weak-password') {
                          print('The password provided is too weak.');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "Senha deve conter mais de 6 caracteres e possuir números"),
                            ),
                          );
                        } else if (e.code == 'email-already-in-use') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text("Já existe uma conta com esse e-mail."),
                            ),
                          );
                        }
                      } catch (e) {
                        print(e);
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Senhas não são iguais"),
                        ),
                      );
                    }
                  }
                },
                child: Text('Criar conta'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // método para criptografar a senha do usuário
  String textToMd5(String text) {
    return md5.convert(utf8.encode(text)).toString();
  }

  bool emptyFields() {
    if (controllerAddress.text.isEmpty ||
        controllerCPF.text.isEmpty ||
        controllerConfirmPassword.text.isEmpty ||
        controllerEmail.text.isEmpty ||
        controllerName.text.isEmpty ||
        controllerPassword.text.isEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
