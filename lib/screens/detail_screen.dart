import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final String? postId;
  const DetailScreen({Key? key, this.postId}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List<String> _tabs = [
    'Info',
    'Dados',
    'Condição',
    'Contato'
  ]; // lista das opções

  String namePet = '';
  String photoPet = '';
  String desc = '';
  String petPort = '';
  String petSex = '';
  String petHair = '';
  String petColor = '';
  String petChild = '';
  String petOtherAnimals = '';
  String state = '';
  String city = '';
  String nameContact = '';
  String tel = '';
  String ong = '';

  bool? stateCastrated;
  bool? stateVaccinated;
  bool? stateDewormed;
  bool? likeChild;
  bool? likeOtherAnimals;
  bool? likeOld;
  bool? specialPhysic;
  bool? specialBlind;
  bool? specialBehavior;
  bool? personalityTender;
  bool? personalityPlayful;
  bool? personalityLazy;
  bool? personalityPartner;
  bool? personalityQuiet;
  bool? personalityCareful;
  bool? personalityClever;

  bool? loading = true;

  @override
  void initState() {
    readLocal();
    // delay para carregar as infos
    Future.delayed(const Duration(seconds: 2), () {
      readLocal();
    });
    super.initState();
  }

  // esse método é responsável por carregar as informações da tela com o postId que recebemos da HomeScreen na variavel widget.postId
  void readLocal() async {
    FirebaseFirestore.instance
        .collection('pets')
        .where("postId", isEqualTo: widget.postId ?? '')
        .snapshots()
        .listen(
          (data) async => data.docs.forEach(
            (doc) {
              photoPet = doc['firstImage'];
              desc = doc['description'];
              petPort = doc['port'];
              petSex = doc['petSex'];
              petHair = doc['petHair'];
              petColor = doc['petColor'];
              petChild = doc['likeChild'] ? 'Sim' : 'Não';
              petOtherAnimals = doc['likeOtherAnimals'] ? 'Sim' : 'Não';
              namePet = doc['namePet'];
              stateCastrated = doc['stateCastrated'];
              stateVaccinated = doc['stateVaccinated'];
              stateDewormed = doc['stateDewormed'];
              likeChild = doc['likeChild'];
              likeOld = doc['likeOld'];
              likeOtherAnimals = doc['likeOtherAnimals'];
              specialBehavior = doc['specialBehavior'];
              specialBlind = doc['specialBlind'];
              specialPhysic = doc['specialPhysic'];
              personalityCareful = doc['personalityCareful'];
              personalityClever = doc['personalityClever'];
              personalityLazy = doc['personalityLazy'];
              personalityQuiet = doc['personalityQuiet'];
              personalityTender = doc['personalityTender'];
              personalityPartner = doc['personalityPartner'];
              personalityPlayful = doc['personalityPlayful'];
              state = doc['state'];
              city = doc['city'];
              nameContact = doc['nameContact'];
              tel = doc['tel'];
              ong = doc['ong'];
            },
          ),
        );

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading!
          ? Center(
              child: CircularProgressIndicator(),
            )
          : DefaultTabController(
              length: _tabs.length,
              child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverOverlapAbsorber(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                      sliver: SliverAppBar(
                        pinned: true,
                        expandedHeight: 500.0,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Stack(
                            children: [
                              Positioned(
                                top: 0,
                                child: Image.network(
                                  photoPet,
                                  width: MediaQuery.of(context).size.width,
                                  height: 450.0,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                              Positioned(
                                bottom: 100.0,
                                left: 25.0,
                                child: Text(
                                  namePet,
                                  style: TextStyle(
                                    fontSize: 30.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    backgroundColor:
                                        Colors.black.withOpacity(0.9),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        forceElevated: innerBoxIsScrolled,
                        bottom: PreferredSize(
                          preferredSize: Size.fromHeight(50.0),
                          child: Container(
                            color: Colors.deepPurple,
                            child: TabBar(
                              tabs: _tabs
                                  .map((String name) => Tab(text: name))
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  children: _tabs.map((String name) {
                    return SafeArea(
                      top: false,
                      bottom: false,
                      child: Builder(
                        builder: (BuildContext context) {
                          return SingleChildScrollView(
                            child: name.contains('Info')
                                ? Column(
                                    children: [
                                      SizedBox(
                                        height: 150,
                                      ),
                                      Text(
                                        desc,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.0,
                                        ),
                                      )
                                    ],
                                  )
                                : name.contains('Dados')
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 170,
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 25.0,
                                            ),
                                            child: IntrinsicHeight(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text(
                                                        petPort,
                                                        style: TextStyle(
                                                          fontSize: 25.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text('porte')
                                                    ],
                                                  ),
                                                  VerticalDivider(
                                                    thickness: 2,
                                                    width: 30,
                                                    color: Colors.black,
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        petSex,
                                                        style: TextStyle(
                                                          fontSize: 25.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text('sexo')
                                                    ],
                                                  ),
                                                  VerticalDivider(
                                                    thickness: 2,
                                                    width: 30,
                                                    color: Colors.black,
                                                  ),
                                                  Column(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          petHair,
                                                          style: TextStyle(
                                                            fontSize: 20.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text('pelo'),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 50,
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 25.0,
                                            ),
                                            child: IntrinsicHeight(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text(
                                                        petColor,
                                                        style: TextStyle(
                                                          fontSize: 25.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text('cor')
                                                    ],
                                                  ),
                                                  VerticalDivider(
                                                    thickness: 2,
                                                    width: 30,
                                                    color: Colors.black,
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        petChild,
                                                        style: TextStyle(
                                                          fontSize: 25.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text('crianças')
                                                    ],
                                                  ),
                                                  VerticalDivider(
                                                    thickness: 2,
                                                    width: 30,
                                                    color: Colors.black,
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        petOtherAnimals,
                                                        style: TextStyle(
                                                          fontSize: 25.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        'outros \n animais',
                                                        textAlign:
                                                            TextAlign.center,
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : name.contains('Condição')
                                        ? Column(
                                            children: [
                                              SizedBox(
                                                height: 170,
                                              ),
                                              Container(
                                                child: Text(
                                                  'Estado:',
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 15.0,
                                                ),
                                                child: Card(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10),
                                                        child: TextButton(
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty.all(
                                                                    stateCastrated!
                                                                        ? Colors
                                                                            .deepPurple
                                                                        : Colors
                                                                            .white),
                                                            textStyle:
                                                                MaterialStateProperty
                                                                    .all(
                                                              TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            shape: MaterialStateProperty
                                                                .all<
                                                                    RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                side: BorderSide(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .deepPurple,
                                                                    style: BorderStyle
                                                                        .solid),
                                                              ),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            setState(() {});
                                                          },
                                                          child: Text(
                                                            'Castrado',
                                                            style: TextStyle(
                                                              color: !stateCastrated!
                                                                  ? Colors
                                                                      .deepPurple
                                                                  : Colors
                                                                      .white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        child: TextButton(
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty.all(
                                                                    stateVaccinated!
                                                                        ? Colors
                                                                            .deepPurple
                                                                        : Colors
                                                                            .white),
                                                            textStyle:
                                                                MaterialStateProperty
                                                                    .all(
                                                              TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            shape: MaterialStateProperty
                                                                .all<
                                                                    RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                side: BorderSide(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .deepPurple,
                                                                    style: BorderStyle
                                                                        .solid),
                                                              ),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            setState(() {});
                                                          },
                                                          child: Text(
                                                            'Vacinado',
                                                            style: TextStyle(
                                                              color: !stateVaccinated!
                                                                  ? Colors
                                                                      .deepPurple
                                                                  : Colors
                                                                      .white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 10),
                                                        child: TextButton(
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty.all(
                                                                    stateDewormed!
                                                                        ? Colors
                                                                            .deepPurple
                                                                        : Colors
                                                                            .white),
                                                            textStyle:
                                                                MaterialStateProperty
                                                                    .all(
                                                              TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            shape: MaterialStateProperty
                                                                .all<
                                                                    RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                side: BorderSide(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .deepPurple,
                                                                    style: BorderStyle
                                                                        .solid),
                                                              ),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            setState(() {});
                                                          },
                                                          child: Text(
                                                            'Desverminado',
                                                            style: TextStyle(
                                                              color: !stateDewormed!
                                                                  ? Colors
                                                                      .deepPurple
                                                                  : Colors
                                                                      .white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  'Gosta de:',
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 15.0,
                                                ),
                                                child: Card(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10),
                                                        child: TextButton(
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(likeChild!
                                                                        ? Colors
                                                                            .deepPurple
                                                                        : Colors
                                                                            .white),
                                                            textStyle:
                                                                MaterialStateProperty
                                                                    .all(
                                                              TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            shape: MaterialStateProperty
                                                                .all<
                                                                    RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                side: BorderSide(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .deepPurple,
                                                                    style: BorderStyle
                                                                        .solid),
                                                              ),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            setState(() {});
                                                          },
                                                          child: Text(
                                                            'Crianças',
                                                            style: TextStyle(
                                                              color: !likeChild!
                                                                  ? Colors
                                                                      .deepPurple
                                                                  : Colors
                                                                      .white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        child: TextButton(
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty.all(
                                                                    likeOtherAnimals!
                                                                        ? Colors
                                                                            .deepPurple
                                                                        : Colors
                                                                            .white),
                                                            textStyle:
                                                                MaterialStateProperty
                                                                    .all(
                                                              TextStyle(
                                                                  color: Colors
                                                                      .deepPurple),
                                                            ),
                                                            shape: MaterialStateProperty
                                                                .all<
                                                                    RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                side: BorderSide(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .deepPurple,
                                                                    style: BorderStyle
                                                                        .solid),
                                                              ),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            setState(() {});
                                                          },
                                                          child: Text(
                                                            'Outros animais',
                                                            style: TextStyle(
                                                              color: !likeOtherAnimals!
                                                                  ? Colors
                                                                      .deepPurple
                                                                  : Colors
                                                                      .white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 10),
                                                        child: TextButton(
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(likeOld!
                                                                        ? Colors
                                                                            .deepPurple
                                                                        : Colors
                                                                            .white),
                                                            textStyle:
                                                                MaterialStateProperty
                                                                    .all(
                                                              TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            shape: MaterialStateProperty
                                                                .all<
                                                                    RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                side: BorderSide(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .deepPurple,
                                                                    style: BorderStyle
                                                                        .solid),
                                                              ),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            setState(() {});
                                                          },
                                                          child: Text(
                                                            'Idosos',
                                                            style: TextStyle(
                                                              color: !likeOld!
                                                                  ? Colors
                                                                      .deepPurple
                                                                  : Colors
                                                                      .white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  'Necessidades Especiais:',
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 15.0,
                                                ),
                                                child: Card(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10),
                                                        child: TextButton(
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty.all(
                                                                    specialPhysic!
                                                                        ? Colors
                                                                            .deepPurple
                                                                        : Colors
                                                                            .white),
                                                            textStyle:
                                                                MaterialStateProperty
                                                                    .all(
                                                              TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            shape: MaterialStateProperty
                                                                .all<
                                                                    RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                side: BorderSide(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .deepPurple,
                                                                    style: BorderStyle
                                                                        .solid),
                                                              ),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            setState(() {});
                                                          },
                                                          child: Text(
                                                            'Problema Físico',
                                                            style: TextStyle(
                                                              color: !specialPhysic!
                                                                  ? Colors
                                                                      .deepPurple
                                                                  : Colors
                                                                      .white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        child: TextButton(
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty.all(
                                                                    specialBlind!
                                                                        ? Colors
                                                                            .deepPurple
                                                                        : Colors
                                                                            .white),
                                                            textStyle:
                                                                MaterialStateProperty
                                                                    .all(
                                                              TextStyle(
                                                                  color: Colors
                                                                      .deepPurple),
                                                            ),
                                                            shape: MaterialStateProperty
                                                                .all<
                                                                    RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                side: BorderSide(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .deepPurple,
                                                                    style: BorderStyle
                                                                        .solid),
                                                              ),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            setState(() {});
                                                          },
                                                          child: Text(
                                                            'Cego',
                                                            style: TextStyle(
                                                              color: !specialBlind!
                                                                  ? Colors
                                                                      .deepPurple
                                                                  : Colors
                                                                      .white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 10),
                                                        child: TextButton(
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty.all(
                                                                    specialBehavior!
                                                                        ? Colors
                                                                            .deepPurple
                                                                        : Colors
                                                                            .white),
                                                            textStyle:
                                                                MaterialStateProperty
                                                                    .all(
                                                              TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            shape: MaterialStateProperty
                                                                .all<
                                                                    RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                side: BorderSide(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .deepPurple,
                                                                    style: BorderStyle
                                                                        .solid),
                                                              ),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            setState(() {});
                                                          },
                                                          child: Text(
                                                            'Comportamento',
                                                            style: TextStyle(
                                                              color: !specialBehavior!
                                                                  ? Colors
                                                                      .deepPurple
                                                                  : Colors
                                                                      .white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  'Personalidade:',
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 15.0,
                                                ),
                                                child: Card(
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10),
                                                            child: TextButton(
                                                              style:
                                                                  ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty.all(personalityTender!
                                                                        ? Colors
                                                                            .deepPurple
                                                                        : Colors
                                                                            .white),
                                                                textStyle:
                                                                    MaterialStateProperty
                                                                        .all(
                                                                  TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                                shape: MaterialStateProperty
                                                                    .all<
                                                                        RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                    side: BorderSide(
                                                                        width:
                                                                            1,
                                                                        color: Colors
                                                                            .deepPurple,
                                                                        style: BorderStyle
                                                                            .solid),
                                                                  ),
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                setState(() {});
                                                              },
                                                              child: Text(
                                                                'Carinhoso',
                                                                style:
                                                                    TextStyle(
                                                                  color: !personalityTender!
                                                                      ? Colors
                                                                          .deepPurple
                                                                      : Colors
                                                                          .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            child: TextButton(
                                                              style:
                                                                  ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty.all(personalityPlayful!
                                                                        ? Colors
                                                                            .deepPurple
                                                                        : Colors
                                                                            .white),
                                                                textStyle:
                                                                    MaterialStateProperty
                                                                        .all(
                                                                  TextStyle(
                                                                      color: Colors
                                                                          .deepPurple),
                                                                ),
                                                                shape: MaterialStateProperty
                                                                    .all<
                                                                        RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                    side: BorderSide(
                                                                        width:
                                                                            1,
                                                                        color: Colors
                                                                            .deepPurple,
                                                                        style: BorderStyle
                                                                            .solid),
                                                                  ),
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                setState(() {});
                                                              },
                                                              child: Text(
                                                                'Brincalhão',
                                                                style:
                                                                    TextStyle(
                                                                  color: !personalityPlayful!
                                                                      ? Colors
                                                                          .deepPurple
                                                                      : Colors
                                                                          .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 10),
                                                            child: TextButton(
                                                              style:
                                                                  ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty.all(personalityLazy!
                                                                        ? Colors
                                                                            .deepPurple
                                                                        : Colors
                                                                            .white),
                                                                textStyle:
                                                                    MaterialStateProperty
                                                                        .all(
                                                                  TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                                shape: MaterialStateProperty
                                                                    .all<
                                                                        RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                    side: BorderSide(
                                                                        width:
                                                                            1,
                                                                        color: Colors
                                                                            .deepPurple,
                                                                        style: BorderStyle
                                                                            .solid),
                                                                  ),
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                setState(() {});
                                                              },
                                                              child: Text(
                                                                'Preguiçoso',
                                                                style:
                                                                    TextStyle(
                                                                  color: !personalityLazy!
                                                                      ? Colors
                                                                          .deepPurple
                                                                      : Colors
                                                                          .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10),
                                                            child: TextButton(
                                                              style:
                                                                  ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty.all(personalityPartner!
                                                                        ? Colors
                                                                            .deepPurple
                                                                        : Colors
                                                                            .white),
                                                                textStyle:
                                                                    MaterialStateProperty
                                                                        .all(
                                                                  TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                                shape: MaterialStateProperty
                                                                    .all<
                                                                        RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                    side: BorderSide(
                                                                        width:
                                                                            1,
                                                                        color: Colors
                                                                            .deepPurple,
                                                                        style: BorderStyle
                                                                            .solid),
                                                                  ),
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                setState(() {});
                                                              },
                                                              child: Text(
                                                                'Companheiro',
                                                                style:
                                                                    TextStyle(
                                                                  color: !personalityPartner!
                                                                      ? Colors
                                                                          .deepPurple
                                                                      : Colors
                                                                          .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            child: TextButton(
                                                              style:
                                                                  ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty.all(personalityQuiet!
                                                                        ? Colors
                                                                            .deepPurple
                                                                        : Colors
                                                                            .white),
                                                                textStyle:
                                                                    MaterialStateProperty
                                                                        .all(
                                                                  TextStyle(
                                                                      color: Colors
                                                                          .deepPurple),
                                                                ),
                                                                shape: MaterialStateProperty
                                                                    .all<
                                                                        RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                    side: BorderSide(
                                                                        width:
                                                                            1,
                                                                        color: Colors
                                                                            .deepPurple,
                                                                        style: BorderStyle
                                                                            .solid),
                                                                  ),
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                setState(() {});
                                                              },
                                                              child: Text(
                                                                'Tranquilo',
                                                                style:
                                                                    TextStyle(
                                                                  color: !personalityQuiet!
                                                                      ? Colors
                                                                          .deepPurple
                                                                      : Colors
                                                                          .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 10),
                                                            child: TextButton(
                                                              style:
                                                                  ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty.all(personalityCareful!
                                                                        ? Colors
                                                                            .deepPurple
                                                                        : Colors
                                                                            .white),
                                                                textStyle:
                                                                    MaterialStateProperty
                                                                        .all(
                                                                  TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                                shape: MaterialStateProperty
                                                                    .all<
                                                                        RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                    side: BorderSide(
                                                                        width:
                                                                            1,
                                                                        color: Colors
                                                                            .deepPurple,
                                                                        style: BorderStyle
                                                                            .solid),
                                                                  ),
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                setState(() {});
                                                              },
                                                              child: Text(
                                                                'Cuidadoso',
                                                                style:
                                                                    TextStyle(
                                                                  color: !personalityCareful!
                                                                      ? Colors
                                                                          .deepPurple
                                                                      : Colors
                                                                          .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10),
                                                            child: TextButton(
                                                              style:
                                                                  ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty.all(personalityClever!
                                                                        ? Colors
                                                                            .deepPurple
                                                                        : Colors
                                                                            .white),
                                                                textStyle:
                                                                    MaterialStateProperty
                                                                        .all(
                                                                  TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                                shape: MaterialStateProperty
                                                                    .all<
                                                                        RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                    side: BorderSide(
                                                                        width:
                                                                            1,
                                                                        color: Colors
                                                                            .deepPurple,
                                                                        style: BorderStyle
                                                                            .solid),
                                                                  ),
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                setState(() {});
                                                              },
                                                              child: Text(
                                                                'Esperto',
                                                                style:
                                                                    TextStyle(
                                                                  color: !personalityClever!
                                                                      ? Colors
                                                                          .deepPurple
                                                                      : Colors
                                                                          .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 150,
                                              ),
                                              Card(
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 15.0,
                                                          top: 15.0,
                                                          bottom: 15.0),
                                                      child: Text(
                                                        'Local:',
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 15.0),
                                                      child: Text(
                                                        state,
                                                        style: TextStyle(
                                                            fontSize: 18.0),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 5.0),
                                                      child: Text(
                                                        city,
                                                        style: TextStyle(
                                                            fontSize: 18.0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Card(
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 15.0,
                                                          top: 15.0,
                                                          bottom: 15.0),
                                                      child: Text(
                                                        'Nome Contato:',
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 15.0),
                                                      child: Text(
                                                        nameContact,
                                                        style: TextStyle(
                                                            fontSize: 18.0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Card(
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 15.0,
                                                          top: 15.0,
                                                          bottom: 15.0),
                                                      child: Text(
                                                        'Telefone (WhatsApp):',
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 15.0),
                                                      child: Text(
                                                        tel,
                                                        style: TextStyle(
                                                            fontSize: 18.0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Card(
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 15.0,
                                                          top: 15.0,
                                                          bottom: 15.0),
                                                      child: Text(
                                                        'ONG:',
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 15.0),
                                                      child: Text(
                                                        ong,
                                                        style: TextStyle(
                                                            fontSize: 18.0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
    );
  }
}
