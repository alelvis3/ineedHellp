import 'package:flutter/material.dart';

class BottomPrincipalScreen extends StatefulWidget {
  const BottomPrincipalScreen({Key? key}) : super(key: key);

  @override
  _BottomPrincipalScreenState createState() => _BottomPrincipalScreenState();
}

class _BottomPrincipalScreenState extends State<BottomPrincipalScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(
            top: 30.0,
            left: 10.0,
            right: 10.0,
          ),
          height: 40.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Container(
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    textStyle: MaterialStateProperty.all(
                      TextStyle(color: Colors.white),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Adicionar animais',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    textStyle: MaterialStateProperty.all(
                      TextStyle(color: Colors.white),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Adicionar pessoas',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Container(
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    textStyle: MaterialStateProperty.all(
                      TextStyle(color: Colors.white),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Adicionar ONGs',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            top: 35.0,
            left: 10.0,
            right: 10.0,
          ),
          alignment: Alignment.centerLeft,
          child: Text(
            'Lista de animais',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
        ),
      ],
    );
  }
}
