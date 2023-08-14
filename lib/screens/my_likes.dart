import 'package:adocao/screens/detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyLikes extends StatefulWidget {
  final String? userId;

  const MyLikes({Key? key, this.userId}) : super(key: key);

  @override
  _MyLikesState createState() => _MyLikesState();
}

class _MyLikesState extends State<MyLikes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Curtidas'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("likes")
                  .where('userId',
                      isEqualTo: widget
                          .userId) // retornando do banco de dados os likes que o usuario deu
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data.docs.length,
                    padding: const EdgeInsets.only(top: 0.0),
                    itemBuilder: (context, index) {
                      DocumentSnapshot? ds = snapshot.data.docs[index];
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                // ao clicar em um pet, abre a tela de detalhes do mesmo
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                      postId: ds!.get('postId'),
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(40.0),
                                    child: Container(
                                      child: Image.network(
                                        ds!.get('photoPet'), // foto do pet
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ds.get('namePet'), // nome do pet
                                        style: TextStyle(
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        ds.get('ong'), // ong do pet
                                        style: TextStyle(
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
