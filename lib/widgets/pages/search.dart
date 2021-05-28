import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:progressions/models/user.dart';
import 'package:progressions/widgets/common/progress.dart';
import 'package:progressions/widgets/jam/CreateJamScreen.dart';
import 'package:progressions/widgets/login/google_sign_in_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:progressions/widgets/common/bottom_navBar.dart';
import 'package:progressions/widgets/pages/user_profile.dart';

User? userO;

class Search extends StatefulWidget {
  const Search({Key? key, required User userOwner})
      : userOwner = userOwner,
        super(key: key);

  final User userOwner;

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late User userOwner;

  @override
  void initState() {
    userOwner = widget.userOwner;
    userO = userOwner;
    // getUsers();

    super.initState();
  }

  Future<QuerySnapshot>? searchResultsFuture;

  TextEditingController searchController = TextEditingController();

  handleSearch(String query) {
    if (query.isNotEmpty) {
      Future<QuerySnapshot> users =
          usersRef.where("username", isGreaterThanOrEqualTo: query).get();

      setState(() {
        searchResultsFuture = users;
      });
    }
  }

  clearSearch() {
    searchController.clear();
    setState(() {
      searchResultsFuture = null;
    });
  }

  AppBar buildSearchField() {
    return AppBar(
      title: TextFormField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: "Search for user..",
          filled: true,
          prefixIcon: Icon(
            Icons.account_box_outlined,
            size: 28.0,
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: clearSearch,
          ),
        ),
        onFieldSubmitted: handleSearch,
      ),
    );
  }

  buildNoContent() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
        child: Center(
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 100.0,
          ),
          SvgPicture.asset(
            'assets/search.svg',
            height: orientation == Orientation.landscape ? 250.0 : 150.0,
          ),
          Text(
            "Find Users",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.blueGrey,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w600,
              fontSize: 60.0,
            ),
          ),
        ],
      ),
    ));
  }

  buildSearchResults() {
    return FutureBuilder(
      future: searchResultsFuture,
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        List<UserResult> searchResults = [];
        snapshot.data!.docs.forEach((doc) {
          AppUser user = AppUser.fromDocument(doc);
          UserResult searchResult = UserResult(user);
          searchResults.add(searchResult);
        });
        return ListView(
          children: searchResults,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // bool keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: buildSearchField(),
      body:
          searchResultsFuture == null ? buildNoContent() : buildSearchResults(),
      bottomNavigationBar: bottomBar(context, isHome: false, user: userOwner),
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

class UserResult extends StatelessWidget {
  final AppUser user;

  UserResult(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey.shade900.withOpacity(0.9),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => showProfile(context, profileId: user.id, user: userO),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(user.photoUrl!),
              ),
              title: Text(
                user.username!,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                user.email!,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Divider(
            height: 2.0,
            color: Color(0xFFb71c1c),
          )
        ],
      ),
    );
  }
}

showProfile(BuildContext context, {required String profileId, User? user}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => UserProfile(
        user: user,
        profileId: profileId,
      ),
    ),
  );
}
