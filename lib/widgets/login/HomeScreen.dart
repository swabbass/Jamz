import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progressions/widgets/jam/CreateJamScreen.dart';
import 'package:progressions/widgets/login/user_info_screen.dart';

import '../StyledTitleText.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User _user;
  @override
  void initState() {
    _user = widget._user;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF414141),
      appBar: AppBar(
        title: StyledText(
            "Jamz", TextStyle(fontWeight: FontWeight.w900, fontSize: 32)),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              icon: Image.asset('assets/user_64.png'),
              iconSize: 30.0,
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => UserInfoScreen(
                      user: _user,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // body: ListView(
      //   physics: AlwaysScrollableScrollPhysics(),

      // ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            SizedBox(
              width: 50.0,
            ),
            IconButton(
              icon: Icon(Icons.home),
              iconSize: 30.0,
              onPressed: () => print("Home pressed"),
            ),
            Spacer(),
            SizedBox(
              width: 15.0,
            ),
            IconButton(
              icon: Icon(Icons.favorite),
              iconSize: 30.0,
              onPressed: () => print("favorite pressed"),
            ),
            SizedBox(
              width: 50.0,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => CreateJamScreen()),
            );
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
