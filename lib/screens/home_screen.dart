import 'package:adocao/screens/add_pet.dart';
import 'package:adocao/screens/detail_screen.dart';
import 'package:adocao/screens/login_screen.dart';
import 'package:adocao/screens/my_likes.dart';
import 'package:adocao/screens/my_pets.dart';
import 'package:adocao/screens/utils/firebase_auth_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launch/flutter_launch.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:swiping_card_deck/swiping_card_deck.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  final AuthFunc? auth;
  final VoidCallback? signedOut;
  final String? userId;

  const HomeScreen({Key? key, this.auth, this.signedOut, this.userId})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List imageMockPets = [
    'https://www.petz.com.br/blog/wp-content/uploads/2021/03/piercing-para-cachorro-2.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSBxl78tJZB1Qd0rAhg3FqXN613TjgIGYIV7JbZe6xp_UdrOnhqEk6PS-XgtcV33zscU2w&usqp=CAU',
    'https://conteudo.imguol.com.br/c/entretenimento/54/2020/04/28/cachorro-pug-1588098472110_v2_1x1.jpg',
    'https://www.royalpets.com.br/blog/wp-content/uploads/2020/08/cachorro-fofinho-750x470.jpg'
  ];

  bool isFilter = false;
  bool pressedTypeDog = false;
  bool pressedTypeCat = false;
  bool pressedTypeOther = false;
  bool pressedSexFem = false;
  bool pressedSexMas = false;
  bool pressedAgePuppy = false; //filhote
  bool pressedAgeAdult = false;
  bool pressedAgeOld = false;
  bool pressedSizeSmall = false;
  bool pressedSizeMedium = false;
  bool pressedSizeBigger = false;
  bool pressedConditionCastrated = false;
  bool pressedConditionVaccinated = false;
  bool pressedConditionDewormed = false; //desverminado
  bool pressedLikeChild = false;
  bool pressedLikeOtherAnimals = false;
  bool pressedLikeOld = false;

  List<SwipeItem>? _swipeItems = <SwipeItem>[];
  MatchEngine? _matchEngine;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List<String> _names = [];
  List<String> _images = [];
  List<String> _ongs = [];
  List<String> _postId = [];
  List<String> _userId = [];
  List<String> _tel = [];

  List<Color> _colors = [
    Colors.red,
    Colors.deepPurple,
    Colors.green,
    Colors.yellow,
    Colors.orange
  ];

  bool loading = true;

  String name = 'user';
  String email = 'email';

  @override
  void initState() {
    super.initState();

    // retorna os dados do usuário (email e nome)
    FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: widget.userId)
        .snapshots()
        .listen(
          (data) => data.docs.forEach(
            (doc) {
              name = doc.get('name');
              email = doc.get('email');
            },
          ),
        );

    // retorna os dados dos pets para mostrar nos cards para dar like ou procurar outro pet
    FirebaseFirestore.instance.collection('pets').snapshots().listen(
          (data) => data.docs.forEach(
            (doc) {
              _images.add(doc.get('firstImage'));
              _ongs.add(doc.get('ong'));
              _postId.add(doc.get('postId'));
              _tel.add(doc.get('tel'));
              return _names.add(doc.get('namePet'));
            },
          ),
        );

    Future.delayed(
      const Duration(seconds: 3),
      () {
        setState(() {
          loading = false;
        });
        // monta os itens com o pet para o usuário dar o swipe
        for (int i = 0; i < _names.length; i++) {
          _swipeItems!.add(
            SwipeItem(
              content:
                  Content(text: _names[i], images: _images[i], tel: _tel[i]),
              likeAction: () {
                // quando o usuário der um like no pet, salva as informações na collection likes para retornar as
                // informações na tela MyLikes de acordo com cada usuário
                String likeId;
                final docRef = FirebaseFirestore.instance.collection('posts');

                DocumentReference docReferance = docRef.doc();
                likeId = docReferance.id;

                FirebaseFirestore.instance.collection('likes').doc(likeId).set({
                  'likeId': likeId,
                  'namePet': _names[i],
                  'ong': _ongs[i],
                  'photoPet': _images[i],
                  'postId': _postId[i],
                  'userId': widget
                      .userId, // salva o id do usuário para recuperar na tela MyLikes onde
                  // o id for igual ao do usuário
                });
                _showOverlay(context, _names[i], _images[i], _tel[i]);
              },
              nopeAction: () {
                // passa para o próximo
                _scaffoldKey.currentState!.showSnackBar(SnackBar(
                  content: Text("Nope ${_names[i]}"),
                  duration: Duration(milliseconds: 500),
                ));
              },
              superlikeAction: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(
                      postId: _postId[i],
                    ),
                  ),
                );
              },
            ),
          );
        }
        _matchEngine = MatchEngine(swipeItems: _swipeItems);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('iNeed Help'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.filter_alt_outlined,
              size: 30.0,
            ),
            onPressed: () {
              setState(() {
                // mostra/esconde o filtro
                isFilter = !isFilter;
              });
            },
          ),
        ],
      ),
      // mostra/esconde o filtro
      floatingActionButton: isFilter
          ? FloatingActionButton.extended(
              onPressed: () {
                // mostra/esconde o filtro
                setState(() {
                  isFilter = !isFilter;
                });
              },
              label: Text('Salvar'),
              icon: Icon(Icons.save_outlined),
            )
          : Container(),
      drawer: navDrawer(),
      body: SingleChildScrollView(
        child: isFilter
            ?

            // mostra a tela do filtro
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: 15.0,
                    ),
                    child: Text(
                      'Tipo:',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                pressedTypeDog
                                    ? Colors.deepPurple
                                    : Colors.transparent),
                            textStyle: MaterialStateProperty.all(
                              TextStyle(color: Colors.white),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                    width: 1,
                                    color: Colors.deepPurple,
                                    style: BorderStyle.solid),
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              pressedTypeDog = !pressedTypeDog;
                            });
                          },
                          child: Text(
                            'Cachorro',
                            style: TextStyle(
                              color:
                                  pressedTypeDog ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                pressedTypeCat
                                    ? Colors.deepPurple
                                    : Colors.transparent),
                            textStyle: MaterialStateProperty.all(
                              TextStyle(color: Colors.white),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                    width: 1,
                                    color: Colors.deepPurple,
                                    style: BorderStyle.solid),
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              pressedTypeCat = !pressedTypeCat;
                            });
                          },
                          child: Text(
                            'Gato',
                            style: TextStyle(
                              color:
                                  pressedTypeCat ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                pressedTypeOther
                                    ? Colors.deepPurple
                                    : Colors.transparent),
                            textStyle: MaterialStateProperty.all(
                              TextStyle(color: Colors.white),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                    width: 1,
                                    color: Colors.deepPurple,
                                    style: BorderStyle.solid),
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              pressedTypeOther = !pressedTypeOther;
                            });
                          },
                          child: Text(
                            'Outro',
                            style: TextStyle(
                              color: pressedTypeOther
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: 15.0,
                      top: 5.0,
                    ),
                    child: Text(
                      'Sexo:',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                pressedSexFem
                                    ? Colors.deepPurple
                                    : Colors.transparent),
                            textStyle: MaterialStateProperty.all(
                              TextStyle(color: Colors.white),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                    width: 1,
                                    color: Colors.deepPurple,
                                    style: BorderStyle.solid),
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              pressedSexFem = !pressedSexFem;
                            });
                          },
                          child: Text(
                            'Feminino',
                            style: TextStyle(
                              color:
                                  pressedSexFem ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                pressedSexMas
                                    ? Colors.deepPurple
                                    : Colors.transparent),
                            textStyle: MaterialStateProperty.all(
                              TextStyle(color: Colors.white),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                    width: 1,
                                    color: Colors.deepPurple,
                                    style: BorderStyle.solid),
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              pressedSexMas = !pressedSexMas;
                            });
                          },
                          child: Text(
                            'Masculino',
                            style: TextStyle(
                              color:
                                  pressedSexMas ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: 15.0,
                      top: 5.0,
                    ),
                    child: Text(
                      'Idade:',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                pressedAgePuppy
                                    ? Colors.deepPurple
                                    : Colors.transparent),
                            textStyle: MaterialStateProperty.all(
                              TextStyle(color: Colors.white),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                    width: 1,
                                    color: Colors.deepPurple,
                                    style: BorderStyle.solid),
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              pressedAgePuppy = !pressedAgePuppy;
                            });
                          },
                          child: Text(
                            'Filhote',
                            style: TextStyle(
                              color:
                                  pressedAgePuppy ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                pressedAgeAdult
                                    ? Colors.deepPurple
                                    : Colors.transparent),
                            textStyle: MaterialStateProperty.all(
                              TextStyle(color: Colors.white),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                    width: 1,
                                    color: Colors.deepPurple,
                                    style: BorderStyle.solid),
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              pressedAgeAdult = !pressedAgeAdult;
                            });
                          },
                          child: Text(
                            'Adulto',
                            style: TextStyle(
                              color:
                                  pressedAgeAdult ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                pressedAgeOld
                                    ? Colors.deepPurple
                                    : Colors.transparent),
                            textStyle: MaterialStateProperty.all(
                              TextStyle(color: Colors.white),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                    width: 1,
                                    color: Colors.deepPurple,
                                    style: BorderStyle.solid),
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              pressedAgeOld = !pressedAgeOld;
                            });
                          },
                          child: Text(
                            'Idoso',
                            style: TextStyle(
                              color:
                                  pressedAgeOld ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: 15.0,
                      top: 5.0,
                    ),
                    child: Text(
                      'Tamanho:',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                pressedSizeSmall
                                    ? Colors.deepPurple
                                    : Colors.transparent),
                            textStyle: MaterialStateProperty.all(
                              TextStyle(color: Colors.white),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                    width: 1,
                                    color: Colors.deepPurple,
                                    style: BorderStyle.solid),
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              pressedSizeSmall = !pressedSizeSmall;
                            });
                          },
                          child: Text(
                            'Pequeno',
                            style: TextStyle(
                              color: pressedSizeSmall
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                pressedSizeMedium
                                    ? Colors.deepPurple
                                    : Colors.transparent),
                            textStyle: MaterialStateProperty.all(
                              TextStyle(color: Colors.white),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                    width: 1,
                                    color: Colors.deepPurple,
                                    style: BorderStyle.solid),
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              pressedSizeMedium = !pressedSizeMedium;
                            });
                          },
                          child: Text(
                            'Médio',
                            style: TextStyle(
                              color: pressedSizeMedium
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                pressedSizeBigger
                                    ? Colors.deepPurple
                                    : Colors.transparent),
                            textStyle: MaterialStateProperty.all(
                              TextStyle(color: Colors.white),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                    width: 1,
                                    color: Colors.deepPurple,
                                    style: BorderStyle.solid),
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              pressedSizeBigger = !pressedSizeBigger;
                            });
                          },
                          child: Text(
                            'Grande',
                            style: TextStyle(
                              color: pressedSizeBigger
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: 15.0,
                      top: 5.0,
                    ),
                    child: Text(
                      'Condição:',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                pressedConditionCastrated
                                    ? Colors.deepPurple
                                    : Colors.transparent),
                            textStyle: MaterialStateProperty.all(
                              TextStyle(color: Colors.white),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                    width: 1,
                                    color: Colors.deepPurple,
                                    style: BorderStyle.solid),
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              pressedConditionCastrated =
                                  !pressedConditionCastrated;
                            });
                          },
                          child: Text(
                            'Castrado',
                            style: TextStyle(
                              color: pressedConditionCastrated
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                pressedConditionVaccinated
                                    ? Colors.deepPurple
                                    : Colors.transparent),
                            textStyle: MaterialStateProperty.all(
                              TextStyle(color: Colors.white),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                    width: 1,
                                    color: Colors.deepPurple,
                                    style: BorderStyle.solid),
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              pressedConditionVaccinated =
                                  !pressedConditionVaccinated;
                            });
                          },
                          child: Text(
                            'Vacinado',
                            style: TextStyle(
                              color: pressedConditionVaccinated
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                pressedConditionDewormed
                                    ? Colors.deepPurple
                                    : Colors.transparent),
                            textStyle: MaterialStateProperty.all(
                              TextStyle(color: Colors.white),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                    width: 1,
                                    color: Colors.deepPurple,
                                    style: BorderStyle.solid),
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              pressedConditionDewormed =
                                  !pressedConditionDewormed;
                            });
                          },
                          child: Text(
                            'Desverminado',
                            style: TextStyle(
                              color: pressedConditionDewormed
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: 15.0,
                      top: 5.0,
                    ),
                    child: Text(
                      'Gosta de:',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                pressedLikeChild
                                    ? Colors.deepPurple
                                    : Colors.transparent),
                            textStyle: MaterialStateProperty.all(
                              TextStyle(color: Colors.white),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                    width: 1,
                                    color: Colors.deepPurple,
                                    style: BorderStyle.solid),
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              pressedLikeChild = !pressedLikeChild;
                            });
                          },
                          child: Text(
                            'Crianças',
                            style: TextStyle(
                              color: pressedLikeChild
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                pressedLikeOtherAnimals
                                    ? Colors.deepPurple
                                    : Colors.transparent),
                            textStyle: MaterialStateProperty.all(
                              TextStyle(color: Colors.white),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                    width: 1,
                                    color: Colors.deepPurple,
                                    style: BorderStyle.solid),
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              pressedLikeOtherAnimals =
                                  !pressedLikeOtherAnimals;
                            });
                          },
                          child: Text(
                            'Outros Animais',
                            style: TextStyle(
                              color: pressedLikeOtherAnimals
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                pressedLikeOld
                                    ? Colors.deepPurple
                                    : Colors.transparent),
                            textStyle: MaterialStateProperty.all(
                              TextStyle(color: Colors.white),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                    width: 1,
                                    color: Colors.deepPurple,
                                    style: BorderStyle.solid),
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              pressedLikeOld = !pressedLikeOld;
                            });
                          },
                          child: Text(
                            'Idosos',
                            style: TextStyle(
                              color:
                                  pressedLikeOld ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  loading
                      ? Container(
                          height: 400,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                backgroundColor: Colors.deepPurple,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Carregando pets',
                                style: TextStyle(
                                  fontSize: 25.0,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          height: 400,
                          child: Column(
                            children: [
                              SwipeCards(
                                matchEngine: _matchEngine!,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    children: [
                                      Container(
                                        color: Colors.white,
                                        height: 300,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Image.network(
                                          _swipeItems![index].content.images,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: Colors.white,
                                        child: Text(
                                          _swipeItems![index].content.text,
                                          style: TextStyle(fontSize: 25),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                onStackFinished: () {
                                  _scaffoldKey.currentState!.showSnackBar(
                                    SnackBar(
                                      content: Text("Stack Finished"),
                                      duration: Duration(milliseconds: 500),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(
                        color: Colors.pink,
                        onPressed: () {
                          _matchEngine!.currentItem!.nope();
                        },
                        child: Text(
                          "Nope",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      RaisedButton(
                          color: Colors.pink,
                          onPressed: () {
                            _matchEngine!.currentItem!.superLike();
                          },
                          child: Text(
                            "+ Detalhes",
                            style: TextStyle(color: Colors.white),
                          )),
                      RaisedButton(
                          color: Colors.pink,
                          onPressed: () {
                            _matchEngine!.currentItem!.like();
                          },
                          child: Text(
                            "Like",
                            style: TextStyle(color: Colors.white),
                          ))
                    ],
                  )
                ],
              ),
      ),
    );
  }

  Widget navDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.bottomLeft,
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  email,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: Colors.pink,
            ),
            title: Text('Início'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.favorite, color: Colors.pink),
            title: Text('Minhas Curtidas'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyLikes(
                    userId: widget.userId,
                  ),
                ),
              )
            },
          ),
          Divider(color: Colors.pink),
          Container(
            padding: EdgeInsets.only(
              left: 10.0,
              top: 10.0,
            ),
            child: Text(
              'Parceiro',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.add, color: Colors.pink),
            title: Text('Adicionar Pet'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPet(
                    userId: widget.userId,
                  ),
                ),
              )
            },
          ),
          ListTile(
            leading: Icon(Icons.pets, color: Colors.pink),
            title: Text('Meus Pets'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyPets(
                    userId: widget.userId,
                  ),
                ),
              )
            },
          ),
          Divider(color: Colors.pink),
          Container(
            padding: EdgeInsets.only(
              left: 10.0,
              bottom: 10.0,
              top: 10.0,
            ),
            child: Text(
              'Mais',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.pink),
            title: Text('Sair'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showOverlay(
      BuildContext context, String name, String image, String tel) {
    Navigator.of(context)
        .push(TutorialOverlay(name: name, image: image, tel: tel));
  }
}

class TutorialOverlay extends ModalRoute<void> {
  final String? name;
  final String? image;
  final String? tel;

  TutorialOverlay({
    Key? key,
    this.name,
    this.image,
    this.tel,
  });

  @override
  Duration get transitionDuration => Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.9);

  @override
  String get barrierLabel => '';

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  // tela de match
  Widget _buildOverlayContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Text(
            'Auuuuuuuuuuuu!',
            style: TextStyle(color: Colors.white, fontSize: 33.0),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              name! + ' está muito feliz que você deseja adotá-lo!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.10,
          ),
          Container(
            height: 200,
            width: 200,
            child: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(image!),
            ),
          ),
          Spacer(),
          Align(
            child: RaisedButton(
              onPressed: () => () async {
                // abre o whatsapp caso o usuario tenha o app instalado
                await FlutterLaunch.launchWhatsapp(
                    phone: tel!,
                    message:
                        "Olá, gostaria de saber mais sobre o pet " + name!);
              },
              child: Text('Enviar mensagem'),
            ),
          ),
          RaisedButton(
            onPressed: () => {Navigator.pop(context)},
            child: Text('Continuar Procurando'),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}

class Content {
  final String? text;
  final String? images;
  final String? tel;

  Content({this.text, this.images, this.tel});
}
