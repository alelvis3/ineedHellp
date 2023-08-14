import 'dart:io';

import 'package:adocao/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AddPet extends StatefulWidget {
  final String? userId;
  const AddPet({Key? key, this.userId}) : super(key: key);

  @override
  _AddPetState createState() => _AddPetState();
}

List<String> _tabs = ['Info', 'Dados', 'Condição', 'Contato'];

String selected = 'ONG 1';
String selectedEstados = 'SP';

// máscara para o número de celular
var maskCell = MaskTextInputFormatter(
  mask: "(##) #####-####",
  filter: {
    "#": RegExp(r'[0-9]'),
  },
);

bool pressedStateCastrated = false;
bool pressedStateVaccinated = false;
bool pressedStateDewormed = false;
bool presseLikeChild = false;
bool pressedLikeOtherAnimals = false;
bool pressedLikeOld = false;
bool pressedSpecialPhysic = false;
bool pressedSpecialBlind = false;
bool pressedSpecialBehavior = false;
bool pressedPersonalityTender = false;
bool pressedPersonalityPlayful = false;
bool pressedPersonalityLazy = false;
bool pressedPersonalityPartner = false;
bool pressedPersonalityQuiet = false;
bool pressedPersonalityCareful = false;
bool pressedPersonalityClever = false;
bool pressedPortSmall = false;
bool pressedPortMedium = false;
bool pressedPortBigger = false;
bool pressedMasc = false;
bool pressedFem = false;
bool pressedHairSmall = false;
bool pressedHairMedium = false;
bool pressedHairBigger = false;
bool pressedColorBlack = false;
bool pressedColorWhite = false;
bool pressedColorGrey = false;
bool pressedColorStriped = false;
bool pressedColorCaramel = false;

List<PhotoItem> _items = [];
List<String> images = [];

File? sampleImagePost;

String? _url;

class _AddPetState extends State<AddPet> {
  TextEditingController namePetTextEditingController =
      new TextEditingController();

  TextEditingController descPetTextEditingController =
      new TextEditingController();

  TextEditingController cityPetTextEditingController =
      new TextEditingController();

  TextEditingController nameContactPetTextEditingController =
      new TextEditingController();

  TextEditingController telTextEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: _tabs.length,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  pinned: true,
                  title: Text('Adicionar Pet'),
                  actions: [
                    Container(
                      padding: EdgeInsets.only(
                        top: 10.0,
                        bottom: 10.0,
                        right: 5.0,
                      ),
                      child: TextButton.icon(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.pink),
                        ),
                        onPressed: () async {
                          saveOnFirestore();
                          resetDataFields();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(
                                userId: widget.userId,
                              ),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Salvar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                  expandedHeight: 100.0,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 150,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15.0,
                                  ),
                                  child: Card(
                                    child: TextFormField(
                                      controller: namePetTextEditingController,
                                      decoration:
                                          InputDecoration(labelText: ' Nome'),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15.0,
                                  ),
                                  child: Card(
                                    child: TextFormField(
                                      controller: descPetTextEditingController,
                                      decoration: InputDecoration(
                                        labelText: ' Descrição do pet =)',
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        alignLabelWithHint: true,
                                      ),
                                      maxLength: 300,
                                      maxLines: 8,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      child: Container(
                                        margin: EdgeInsets.only(left: 15.0),
                                        color: Colors.grey[300],
                                        height: 170,
                                        width: 150,
                                        child: Center(
                                          child: Icon(
                                            Icons.add_circle,
                                            color: Colors.red,
                                            size: 44,
                                          ),
                                        ),
                                      ),
                                      onTap: () async {
                                        // abrir a galeria do dispositivo
                                        final _picker = ImagePicker();
                                        PickedFile? tempImage =
                                            await _picker.getImage(
                                                source: ImageSource.gallery);

                                        setState(() {
                                          sampleImagePost =
                                              File(tempImage!.path);
                                        });

                                        // salvar no Storage do Firebase no caminho images/

                                        final Reference postImageRef =
                                            FirebaseStorage.instance
                                                .ref()
                                                .child("images/");

                                        var timeKey = DateTime.now();

                                        final UploadTask uploadTask =
                                            postImageRef
                                                .child(
                                                    timeKey.toString() + ".jpg")
                                                .putFile(sampleImagePost!);

                                        var ImageUrl = await (await uploadTask
                                                .whenComplete(() => null))
                                            .ref
                                            .getDownloadURL();

                                        _url = ImageUrl.toString();

                                        // adicionado na lista de images para salvar no Firestore (banco de dados)
                                        images.add(_url!);

                                        // adicionado na lista de items para mostrar para o usuario as imagens adicionadas por ele
                                        _items.add(
                                          PhotoItem(
                                            sampleImagePost!,
                                            'name',
                                          ),
                                        );
                                      },
                                    ),
                                    Expanded(
                                      child: Container(
                                        color: Colors.grey[300],
                                        height: 170,
                                        width: 150,
                                        child: GridView.builder(
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisSpacing: 5,
                                            mainAxisSpacing: 0,
                                            childAspectRatio: 1,
                                            mainAxisExtent: 170,
                                            crossAxisCount: 2,
                                          ),
                                          itemCount: _items.length,
                                          physics:
                                              AlwaysScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return _items.isEmpty
                                                ? Container()
                                                : Container(
                                                    child: Image.file(
                                                      _items[index].image,
                                                      height: 170,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : name.contains('Dados')
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 170,
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 25.0,
                                      ),
                                      child: Text(
                                        'Porte',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 25.0,
                                      ),
                                      child: Card(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                              child: TextButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                    !pressedPortSmall
                                                        ? Colors.white
                                                        : Colors.deepPurple,
                                                  ),
                                                  textStyle:
                                                      MaterialStateProperty.all(
                                                    TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      side: BorderSide(
                                                          width: 1,
                                                          color:
                                                              Colors.deepPurple,
                                                          style: BorderStyle
                                                              .solid),
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    pressedPortSmall =
                                                        !pressedPortSmall;

                                                    pressedPortBigger = false;
                                                    pressedPortMedium = false;
                                                  });
                                                },
                                                child: Text(
                                                  'Pequeno',
                                                  style: TextStyle(
                                                    color: pressedPortSmall
                                                        ? Colors.white
                                                        : Colors.deepPurple,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                              child: TextButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                    !pressedPortMedium
                                                        ? Colors.white
                                                        : Colors.deepPurple,
                                                  ),
                                                  textStyle:
                                                      MaterialStateProperty.all(
                                                    TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      side: BorderSide(
                                                          width: 1,
                                                          color:
                                                              Colors.deepPurple,
                                                          style: BorderStyle
                                                              .solid),
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    pressedPortMedium =
                                                        !pressedPortMedium;
                                                    pressedPortBigger = false;
                                                    pressedPortSmall = false;
                                                  });
                                                },
                                                child: Text(
                                                  'Médio',
                                                  style: TextStyle(
                                                    color: pressedPortMedium
                                                        ? Colors.white
                                                        : Colors.deepPurple,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(
                                                left: 10.0,
                                                right: 10.0,
                                              ),
                                              child: TextButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                    !pressedPortBigger
                                                        ? Colors.white
                                                        : Colors.blue,
                                                  ),
                                                  textStyle:
                                                      MaterialStateProperty.all(
                                                    TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      side: BorderSide(
                                                          width: 1,
                                                          color: Colors.blue,
                                                          style: BorderStyle
                                                              .solid),
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    pressedPortBigger =
                                                        !pressedPortBigger;

                                                    pressedPortSmall = false;
                                                    pressedPortMedium = false;
                                                  });
                                                },
                                                child: Text(
                                                  'Grande',
                                                  style: TextStyle(
                                                    color: pressedPortBigger
                                                        ? Colors.white
                                                        : Colors.blue,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 25.0,
                                      ),
                                      child: Text(
                                        'Sexo',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 25.0,
                                      ),
                                      child: Card(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                              child: TextButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                    !pressedFem
                                                        ? Colors.white
                                                        : Colors.blue,
                                                  ),
                                                  textStyle:
                                                      MaterialStateProperty.all(
                                                    TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      side: BorderSide(
                                                          width: 1,
                                                          color: Colors.blue,
                                                          style: BorderStyle
                                                              .solid),
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    pressedFem = !pressedFem;
                                                    pressedMasc = false;
                                                  });
                                                },
                                                child: Text(
                                                  'Feminino',
                                                  style: TextStyle(
                                                    color: pressedFem
                                                        ? Colors.white
                                                        : Colors.blue,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                              child: TextButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                    !pressedMasc
                                                        ? Colors.white
                                                        : Colors.blue,
                                                  ),
                                                  textStyle:
                                                      MaterialStateProperty.all(
                                                    TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      side: BorderSide(
                                                          width: 1,
                                                          color: Colors.blue,
                                                          style: BorderStyle
                                                              .solid),
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    pressedMasc = !pressedMasc;
                                                    pressedFem = false;
                                                  });
                                                },
                                                child: Text(
                                                  'Masculino',
                                                  style: TextStyle(
                                                    color: pressedMasc
                                                        ? Colors.white
                                                        : Colors.blue,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 25.0,
                                      ),
                                      child: Text(
                                        'Pelo',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 25.0,
                                      ),
                                      child: Card(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                              child: TextButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                    !pressedHairSmall
                                                        ? Colors.white
                                                        : Colors.blue,
                                                  ),
                                                  textStyle:
                                                      MaterialStateProperty.all(
                                                    TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      side: BorderSide(
                                                          width: 1,
                                                          color: Colors.blue,
                                                          style: BorderStyle
                                                              .solid),
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    pressedHairSmall =
                                                        !pressedHairSmall;
                                                    pressedHairBigger = false;
                                                    pressedHairMedium = false;
                                                  });
                                                },
                                                child: Text(
                                                  'Pequeno',
                                                  style: TextStyle(
                                                    color: pressedHairSmall
                                                        ? Colors.white
                                                        : Colors.blue,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                              child: TextButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                    !pressedHairMedium
                                                        ? Colors.white
                                                        : Colors.blue,
                                                  ),
                                                  textStyle:
                                                      MaterialStateProperty.all(
                                                    TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      side: BorderSide(
                                                          width: 1,
                                                          color: Colors.blue,
                                                          style: BorderStyle
                                                              .solid),
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    pressedHairMedium =
                                                        !pressedHairMedium;
                                                    pressedHairBigger = false;
                                                    pressedHairSmall = false;
                                                  });
                                                },
                                                child: Text(
                                                  'Médio',
                                                  style: TextStyle(
                                                    color: pressedHairMedium
                                                        ? Colors.white
                                                        : Colors.blue,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(
                                                left: 10.0,
                                                right: 10.0,
                                              ),
                                              child: TextButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                    !pressedHairBigger
                                                        ? Colors.white
                                                        : Colors.blue,
                                                  ),
                                                  textStyle:
                                                      MaterialStateProperty.all(
                                                    TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      side: BorderSide(
                                                          width: 1,
                                                          color: Colors.blue,
                                                          style: BorderStyle
                                                              .solid),
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    pressedHairBigger =
                                                        !pressedHairBigger;
                                                    pressedHairSmall = false;
                                                    pressedHairMedium = false;
                                                  });
                                                },
                                                child: Text(
                                                  'Grande',
                                                  style: TextStyle(
                                                    color: pressedHairBigger
                                                        ? Colors.white
                                                        : Colors.blue,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 25.0,
                                      ),
                                      child: Text(
                                        'Cor',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 25.0,
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
                                                      EdgeInsets.only(left: 10),
                                                  child: TextButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(
                                                        !pressedColorBlack
                                                            ? Colors.white
                                                            : Colors.blue,
                                                      ),
                                                      textStyle:
                                                          MaterialStateProperty
                                                              .all(
                                                        TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      shape: MaterialStateProperty
                                                          .all<
                                                              RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          side: BorderSide(
                                                              width: 1,
                                                              color:
                                                                  Colors.blue,
                                                              style: BorderStyle
                                                                  .solid),
                                                        ),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        pressedColorBlack =
                                                            !pressedColorBlack;

                                                        pressedColorCaramel =
                                                            false;
                                                        pressedColorGrey =
                                                            false;
                                                        pressedColorStriped =
                                                            false;
                                                        pressedColorWhite =
                                                            false;
                                                      });
                                                    },
                                                    child: Text(
                                                      'Preto',
                                                      style: TextStyle(
                                                        color: pressedColorBlack
                                                            ? Colors.white
                                                            : Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      EdgeInsets.only(left: 10),
                                                  child: TextButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(
                                                        !pressedColorWhite
                                                            ? Colors.white
                                                            : Colors.blue,
                                                      ),
                                                      textStyle:
                                                          MaterialStateProperty
                                                              .all(
                                                        TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      shape: MaterialStateProperty
                                                          .all<
                                                              RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          side: BorderSide(
                                                              width: 1,
                                                              color:
                                                                  Colors.blue,
                                                              style: BorderStyle
                                                                  .solid),
                                                        ),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        pressedColorWhite =
                                                            !pressedColorWhite;

                                                        pressedColorCaramel =
                                                            false;
                                                        pressedColorGrey =
                                                            false;
                                                        pressedColorStriped =
                                                            false;
                                                        pressedColorBlack =
                                                            false;
                                                      });
                                                    },
                                                    child: Text(
                                                      'Branco',
                                                      style: TextStyle(
                                                        color: pressedColorWhite
                                                            ? Colors.white
                                                            : Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                    left: 10.0,
                                                    right: 10.0,
                                                  ),
                                                  child: TextButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(
                                                        !pressedColorStriped
                                                            ? Colors.white
                                                            : Colors.blue,
                                                      ),
                                                      textStyle:
                                                          MaterialStateProperty
                                                              .all(
                                                        TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      shape: MaterialStateProperty
                                                          .all<
                                                              RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          side: BorderSide(
                                                              width: 1,
                                                              color:
                                                                  Colors.blue,
                                                              style: BorderStyle
                                                                  .solid),
                                                        ),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        pressedColorStriped =
                                                            !pressedColorStriped;

                                                        pressedColorCaramel =
                                                            false;
                                                        pressedColorGrey =
                                                            false;
                                                        pressedColorBlack =
                                                            false;
                                                        pressedColorWhite =
                                                            false;
                                                      });
                                                    },
                                                    child: Text(
                                                      'Listrado',
                                                      style: TextStyle(
                                                        color:
                                                            pressedColorStriped
                                                                ? Colors.white
                                                                : Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.only(
                                                    left: 10.0,
                                                    right: 10.0,
                                                  ),
                                                  child: TextButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(
                                                        !pressedColorGrey
                                                            ? Colors.white
                                                            : Colors.blue,
                                                      ),
                                                      textStyle:
                                                          MaterialStateProperty
                                                              .all(
                                                        TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      shape: MaterialStateProperty
                                                          .all<
                                                              RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          side: BorderSide(
                                                              width: 1,
                                                              color:
                                                                  Colors.blue,
                                                              style: BorderStyle
                                                                  .solid),
                                                        ),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        pressedColorGrey =
                                                            !pressedColorGrey;

                                                        pressedColorCaramel =
                                                            false;
                                                        pressedColorBlack =
                                                            false;
                                                        pressedColorStriped =
                                                            false;
                                                        pressedColorWhite =
                                                            false;
                                                      });
                                                    },
                                                    child: Text(
                                                      'Cinza',
                                                      style: TextStyle(
                                                        color: pressedColorGrey
                                                            ? Colors.white
                                                            : Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                    left: 10.0,
                                                    right: 10.0,
                                                  ),
                                                  child: TextButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(
                                                        !pressedColorCaramel
                                                            ? Colors.white
                                                            : Colors.blue,
                                                      ),
                                                      textStyle:
                                                          MaterialStateProperty
                                                              .all(
                                                        TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      shape: MaterialStateProperty
                                                          .all<
                                                              RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          side: BorderSide(
                                                              width: 1,
                                                              color:
                                                                  Colors.blue,
                                                              style: BorderStyle
                                                                  .solid),
                                                        ),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        pressedColorCaramel =
                                                            !pressedColorCaramel;

                                                        pressedColorBlack =
                                                            false;
                                                        pressedColorGrey =
                                                            false;
                                                        pressedColorStriped =
                                                            false;
                                                        pressedColorWhite =
                                                            false;
                                                      });
                                                    },
                                                    child: Text(
                                                      'Caramelo',
                                                      style: TextStyle(
                                                        color:
                                                            pressedColorCaramel
                                                                ? Colors.white
                                                                : Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
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
                                                      EdgeInsets.only(left: 10),
                                                  child: TextButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty.all(
                                                              pressedStateCastrated
                                                                  ? Colors.blue
                                                                  : Colors
                                                                      .white),
                                                      textStyle:
                                                          MaterialStateProperty
                                                              .all(
                                                        TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      shape: MaterialStateProperty
                                                          .all<
                                                              RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          side: BorderSide(
                                                              width: 1,
                                                              color:
                                                                  Colors.blue,
                                                              style: BorderStyle
                                                                  .solid),
                                                        ),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        pressedStateCastrated =
                                                            !pressedStateCastrated;
                                                      });
                                                    },
                                                    child: Text(
                                                      'Castrado',
                                                      style: TextStyle(
                                                          color:
                                                              pressedStateCastrated
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .blue),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  child: TextButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(
                                                        !pressedStateVaccinated
                                                            ? Colors.white
                                                            : Colors.blue,
                                                      ),
                                                      textStyle:
                                                          MaterialStateProperty
                                                              .all(
                                                        TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      shape: MaterialStateProperty
                                                          .all<
                                                              RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          side: BorderSide(
                                                              width: 1,
                                                              color:
                                                                  Colors.blue,
                                                              style: BorderStyle
                                                                  .solid),
                                                        ),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        pressedStateVaccinated =
                                                            !pressedStateVaccinated;
                                                      });
                                                    },
                                                    child: Text(
                                                      'Vacinado',
                                                      style: TextStyle(
                                                        color:
                                                            pressedStateVaccinated
                                                                ? Colors.white
                                                                : Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      right: 10),
                                                  child: TextButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty.all(
                                                              pressedStateDewormed
                                                                  ? Colors.blue
                                                                  : Colors
                                                                      .white),
                                                      textStyle:
                                                          MaterialStateProperty
                                                              .all(
                                                        TextStyle(
                                                            color:
                                                                pressedStateDewormed
                                                                    ? Colors
                                                                        .blue
                                                                    : Colors
                                                                        .white),
                                                      ),
                                                      shape: MaterialStateProperty
                                                          .all<
                                                              RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          side: BorderSide(
                                                              width: 1,
                                                              color:
                                                                  Colors.blue,
                                                              style: BorderStyle
                                                                  .solid),
                                                        ),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        pressedStateDewormed =
                                                            !pressedStateDewormed;
                                                      });
                                                    },
                                                    child: Text(
                                                      'Desverminado',
                                                      style: TextStyle(
                                                        color:
                                                            pressedStateDewormed
                                                                ? Colors.white
                                                                : Colors.blue,
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
                                                      EdgeInsets.only(left: 10),
                                                  child: TextButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(
                                                        !presseLikeChild
                                                            ? Colors.white
                                                            : Colors.blue,
                                                      ),
                                                      textStyle:
                                                          MaterialStateProperty
                                                              .all(
                                                        TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      shape: MaterialStateProperty
                                                          .all<
                                                              RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          side: BorderSide(
                                                              width: 1,
                                                              color:
                                                                  Colors.blue,
                                                              style: BorderStyle
                                                                  .solid),
                                                        ),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        presseLikeChild =
                                                            !presseLikeChild;
                                                      });
                                                    },
                                                    child: Text(
                                                      'Crianças',
                                                      style: TextStyle(
                                                        color: presseLikeChild
                                                            ? Colors.white
                                                            : Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  child: TextButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(
                                                        !pressedLikeOtherAnimals
                                                            ? Colors.white
                                                            : Colors.blue,
                                                      ),
                                                      textStyle:
                                                          MaterialStateProperty
                                                              .all(
                                                        TextStyle(
                                                            color: Colors.blue),
                                                      ),
                                                      shape: MaterialStateProperty
                                                          .all<
                                                              RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          side: BorderSide(
                                                              width: 1,
                                                              color:
                                                                  Colors.blue,
                                                              style: BorderStyle
                                                                  .solid),
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
                                                      'Outros animais',
                                                      style: TextStyle(
                                                        color:
                                                            pressedLikeOtherAnimals
                                                                ? Colors.white
                                                                : Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      right: 10),
                                                  child: TextButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(
                                                        !pressedLikeOld
                                                            ? Colors.white
                                                            : Colors.blue,
                                                      ),
                                                      textStyle:
                                                          MaterialStateProperty
                                                              .all(
                                                        TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      shape: MaterialStateProperty
                                                          .all<
                                                              RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          side: BorderSide(
                                                              width: 1,
                                                              color:
                                                                  Colors.blue,
                                                              style: BorderStyle
                                                                  .solid),
                                                        ),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        pressedLikeOld =
                                                            !pressedLikeOld;
                                                      });
                                                    },
                                                    child: Text(
                                                      'Idosos',
                                                      style: TextStyle(
                                                        color: pressedLikeOld
                                                            ? Colors.white
                                                            : Colors.blue,
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
                                                      EdgeInsets.only(left: 10),
                                                  child: TextButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(
                                                        !pressedSpecialPhysic
                                                            ? Colors.white
                                                            : Colors.blue,
                                                      ),
                                                      textStyle:
                                                          MaterialStateProperty
                                                              .all(
                                                        TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      shape: MaterialStateProperty
                                                          .all<
                                                              RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          side: BorderSide(
                                                              width: 1,
                                                              color:
                                                                  Colors.blue,
                                                              style: BorderStyle
                                                                  .solid),
                                                        ),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        pressedSpecialPhysic =
                                                            !pressedSpecialPhysic;
                                                      });
                                                    },
                                                    child: Text(
                                                      'Problema Físico',
                                                      style: TextStyle(
                                                        color:
                                                            pressedSpecialPhysic
                                                                ? Colors.white
                                                                : Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  child: TextButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(
                                                        !pressedSpecialBlind
                                                            ? Colors.white
                                                            : Colors.blue,
                                                      ),
                                                      textStyle:
                                                          MaterialStateProperty
                                                              .all(
                                                        TextStyle(
                                                            color: Colors.blue),
                                                      ),
                                                      shape: MaterialStateProperty
                                                          .all<
                                                              RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          side: BorderSide(
                                                              width: 1,
                                                              color:
                                                                  Colors.blue,
                                                              style: BorderStyle
                                                                  .solid),
                                                        ),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        pressedSpecialBlind =
                                                            !pressedSpecialBlind;
                                                      });
                                                    },
                                                    child: Text(
                                                      'Cego',
                                                      style: TextStyle(
                                                        color:
                                                            pressedSpecialBlind
                                                                ? Colors.white
                                                                : Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      right: 10),
                                                  child: TextButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty.all(
                                                              !pressedSpecialBehavior
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .blue),
                                                      textStyle:
                                                          MaterialStateProperty
                                                              .all(
                                                        TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      shape: MaterialStateProperty
                                                          .all<
                                                              RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          side: BorderSide(
                                                              width: 1,
                                                              color:
                                                                  Colors.blue,
                                                              style: BorderStyle
                                                                  .solid),
                                                        ),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        pressedSpecialBehavior =
                                                            !pressedSpecialBehavior;
                                                      });
                                                    },
                                                    child: Text(
                                                      'Comportamento',
                                                      style: TextStyle(
                                                          color:
                                                              pressedSpecialBehavior
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .blue),
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
                                                      padding: EdgeInsets.only(
                                                          left: 10),
                                                      child: TextButton(
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty.all(
                                                                  !pressedPersonalityTender
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .blue),
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
                                                                      .blue,
                                                                  style:
                                                                      BorderStyle
                                                                          .solid),
                                                            ),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            pressedPersonalityTender =
                                                                !pressedPersonalityTender;
                                                          });
                                                        },
                                                        child: Text(
                                                          'Carinhoso',
                                                          style: TextStyle(
                                                            color:
                                                                pressedPersonalityTender
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .blue,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      child: TextButton(
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(
                                                            !pressedPersonalityPlayful
                                                                ? Colors.white
                                                                : Colors.blue,
                                                          ),
                                                          textStyle:
                                                              MaterialStateProperty
                                                                  .all(
                                                            TextStyle(
                                                                color: Colors
                                                                    .blue),
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
                                                                      .blue,
                                                                  style:
                                                                      BorderStyle
                                                                          .solid),
                                                            ),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            pressedPersonalityPlayful =
                                                                !pressedPersonalityPlayful;
                                                          });
                                                        },
                                                        child: Text(
                                                          'Brincalhão',
                                                          style: TextStyle(
                                                            color:
                                                                pressedPersonalityPlayful
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .blue,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          right: 10),
                                                      child: TextButton(
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(
                                                            !pressedPersonalityLazy
                                                                ? Colors.white
                                                                : Colors.blue,
                                                          ),
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
                                                                      .blue,
                                                                  style:
                                                                      BorderStyle
                                                                          .solid),
                                                            ),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            pressedPersonalityLazy =
                                                                !pressedPersonalityLazy;
                                                          });
                                                        },
                                                        child: Text(
                                                          'Preguiçoso',
                                                          style: TextStyle(
                                                            color:
                                                                pressedPersonalityLazy
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .blue,
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
                                                      padding: EdgeInsets.only(
                                                          left: 10),
                                                      child: TextButton(
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(
                                                            !pressedPersonalityPartner
                                                                ? Colors.white
                                                                : Colors.blue,
                                                          ),
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
                                                                      .blue,
                                                                  style:
                                                                      BorderStyle
                                                                          .solid),
                                                            ),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            pressedPersonalityPartner =
                                                                !pressedPersonalityPartner;
                                                          });
                                                        },
                                                        child: Text(
                                                          'Companheiro',
                                                          style: TextStyle(
                                                            color:
                                                                pressedPersonalityPartner
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .blue,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      child: TextButton(
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(
                                                            !pressedPersonalityQuiet
                                                                ? Colors.white
                                                                : Colors.blue,
                                                          ),
                                                          textStyle:
                                                              MaterialStateProperty
                                                                  .all(
                                                            TextStyle(
                                                                color: Colors
                                                                    .blue),
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
                                                                      .blue,
                                                                  style:
                                                                      BorderStyle
                                                                          .solid),
                                                            ),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            pressedPersonalityQuiet =
                                                                !pressedPersonalityQuiet;
                                                          });
                                                        },
                                                        child: Text(
                                                          'Tranquilo',
                                                          style: TextStyle(
                                                            color:
                                                                pressedPersonalityQuiet
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .blue,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          right: 10),
                                                      child: TextButton(
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(
                                                            !pressedPersonalityCareful
                                                                ? Colors.white
                                                                : Colors.blue,
                                                          ),
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
                                                                      .blue,
                                                                  style:
                                                                      BorderStyle
                                                                          .solid),
                                                            ),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            pressedPersonalityCareful =
                                                                !pressedPersonalityCareful;
                                                          });
                                                        },
                                                        child: Text(
                                                          'Cuidadoso',
                                                          style: TextStyle(
                                                            color:
                                                                pressedPersonalityCareful
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .blue,
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
                                                      padding: EdgeInsets.only(
                                                          left: 10),
                                                      child: TextButton(
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(
                                                            !pressedPersonalityClever
                                                                ? Colors.white
                                                                : Colors.blue,
                                                          ),
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
                                                                      .blue,
                                                                  style:
                                                                      BorderStyle
                                                                          .solid),
                                                            ),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            pressedPersonalityClever =
                                                                !pressedPersonalityClever;
                                                          });
                                                        },
                                                        child: Text(
                                                          'Esperto',
                                                          style: TextStyle(
                                                            color:
                                                                pressedPersonalityClever
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .blue,
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
                                                    bottom: 15.0,
                                                    right: 20.0),
                                                child: Text(
                                                  'Local:',
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              DropdownButton<String>(
                                                value: selectedEstados,
                                                items: <String>[
                                                  "AC",
                                                  "AL",
                                                  "AP",
                                                  "AM",
                                                  "BA",
                                                  "CE",
                                                  "DF",
                                                  "ES",
                                                  "GO",
                                                  "MA",
                                                  "MT",
                                                  "MS",
                                                  "MG",
                                                  "PA",
                                                  "PB",
                                                  "PR",
                                                  "PE",
                                                  "PI",
                                                  "RJ",
                                                  "RN",
                                                  "RS",
                                                  "RO",
                                                  "RR",
                                                  "SC",
                                                  "SP",
                                                  "SE",
                                                  "TO"
                                                ].map((String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    selectedEstados = value!;
                                                  });
                                                },
                                              ),
                                              SizedBox(
                                                width: 20.0,
                                              ),
                                              Expanded(
                                                child: TextFormField(
                                                  controller:
                                                      cityPetTextEditingController,
                                                  decoration: InputDecoration(
                                                    labelText: 'Cidade',
                                                    border: InputBorder.none,
                                                    focusedBorder:
                                                        InputBorder.none,
                                                    enabledBorder:
                                                        InputBorder.none,
                                                    errorBorder:
                                                        InputBorder.none,
                                                    disabledBorder:
                                                        InputBorder.none,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Card(
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                left: 15.0,
                                                top: 5.0,
                                                bottom: 5.0),
                                            child: TextFormField(
                                              controller:
                                                  nameContactPetTextEditingController,
                                              decoration: InputDecoration(
                                                labelText: 'Nome contato',
                                                labelStyle: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Card(
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                left: 15.0,
                                                top: 5.0,
                                                bottom: 5.0),
                                            child: TextFormField(
                                              controller:
                                                  telTextEditingController,
                                              decoration: InputDecoration(
                                                labelText:
                                                    'Telefone (WhatsApp)',
                                                labelStyle: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              inputFormatters: [
                                                maskCell,
                                              ],
                                            ),
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
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),

                                              /// TODO: Aguardando nome das ONGs
                                              DropdownButton<String>(
                                                value: selected,
                                                items: <String>[
                                                  'ONG 1',
                                                  'ONG 2',
                                                  'ONG 3',
                                                  'ONG 4',
                                                  'ONG 5',
                                                  'ONG 6',
                                                  'ONG 7',
                                                  'ONG 8',
                                                ].map((String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    selected = value!;
                                                  });
                                                },
                                              )
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

  // retorna o valor escolhido pelo usuário para salvar no Firestore
  String getColorPet() {
    String choosed = '';
    if (pressedColorBlack) {
      choosed = 'Preto';
    } else if (pressedColorCaramel) {
      choosed = 'Caramelo';
    } else if (pressedColorGrey) {
      choosed = 'Cinza';
    } else if (pressedColorStriped) {
      choosed = 'Listrado';
    } else if (pressedColorWhite) {
      choosed = 'Branco';
    }
    return choosed;
  }

  String getPortPet() {
    String choosed = '';

    if (pressedPortBigger) {
      choosed = 'Grande';
    } else if (pressedPortMedium) {
      choosed = 'Médio';
    } else if (pressedPortSmall) {
      choosed = 'Pequeno';
    }

    return choosed;
  }

  // retorna o valor escolhido pelo usuário para salvar no Firestore
  String getPetSex() {
    String choosed = '';

    if (pressedMasc) {
      choosed = 'Masculino';
    } else {
      choosed = 'Feminino';
    }
    return choosed;
  }

  // retorna o valor escolhido pelo usuário para salvar no Firestore
  String getPetHair() {
    String choosed = '';

    if (pressedHairBigger) {
      choosed = 'Grande';
    } else if (pressedHairMedium) {
      choosed = 'Médio';
    } else if (pressedHairSmall) {
      choosed = 'Pequeno';
    }

    return choosed;
  }

  // salva as informações no Firestore
  void saveOnFirestore() {
    final docRef = FirebaseFirestore.instance
        .collection('posts'); // collection no Firestore

    DocumentReference docReferance = docRef.doc();
    String postId = docReferance.id; // pega o id do documento no banco de dados

    FirebaseFirestore.instance.collection('pets').doc().set({
      'city': cityPetTextEditingController.text,
      'description': descPetTextEditingController.text,
      'firstImage': images[0],
      'images': images,
      'likeChild': presseLikeChild,
      'likeOld': pressedLikeOld,
      'likeOtherAnimals': pressedLikeOtherAnimals,
      'nameContact': nameContactPetTextEditingController.text,
      'namePet': namePetTextEditingController.text,
      'ong': selected,
      'personalityCareful': pressedPersonalityCareful,
      'personalityClever': pressedPersonalityClever,
      'personalityLazy': pressedPersonalityLazy,
      'personalityPartner': pressedPersonalityPartner,
      'personalityPlayful': pressedPersonalityPlayful,
      'personalityQuiet': pressedPersonalityQuiet,
      'personalityTender': pressedPersonalityTender,
      'petColor': getColorPet(),
      'petHair': getPetHair(),
      'petSex': getPetSex(),
      'port': getPortPet(),
      'postId': postId,
      'specialBehavior': pressedSpecialBehavior,
      'specialBlind': pressedSpecialBlind,
      'specialPhysic': pressedSpecialPhysic,
      'state': selectedEstados,
      'stateCastrated': pressedStateCastrated,
      'stateDewormed': pressedStateDewormed,
      'stateVaccinated': pressedStateVaccinated,
      'tel': telTextEditingController.text,
      'userId': widget.userId,
    });
  }

  // ao salvar reseta os valores preenchidos pelo usuário
  void resetDataFields() {
    pressedStateCastrated = false;
    pressedStateVaccinated = false;
    pressedStateDewormed = false;
    presseLikeChild = false;
    pressedLikeOtherAnimals = false;
    pressedLikeOld = false;
    pressedSpecialPhysic = false;
    pressedSpecialBlind = false;
    pressedSpecialBehavior = false;
    pressedPersonalityTender = false;
    pressedPersonalityPlayful = false;
    pressedPersonalityLazy = false;
    pressedPersonalityPartner = false;
    pressedPersonalityQuiet = false;
    pressedPersonalityCareful = false;
    pressedPersonalityClever = false;
    pressedPortSmall = false;
    pressedPortMedium = false;
    pressedPortBigger = false;
    pressedMasc = false;
    pressedFem = false;
    pressedHairSmall = false;
    pressedHairMedium = false;
    pressedHairBigger = false;
    pressedColorBlack = false;
    pressedColorWhite = false;
    pressedColorGrey = false;
    pressedColorStriped = false;
    pressedColorCaramel = false;
    _items = [];
    images = [];

    sampleImagePost = null;

    _url = '';

    selected = 'ONG 1';
    selectedEstados = 'SP';

    namePetTextEditingController.clear();

    descPetTextEditingController.clear();

    cityPetTextEditingController.clear();

    nameContactPetTextEditingController.clear();

    telTextEditingController.clear();

    setState(() {});
  }
}

class PhotoItem {
  final File image;
  final String name;
  PhotoItem(this.image, this.name);
}
