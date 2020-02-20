import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/models/user_data.dart';
import 'package:flutter_instagram_clone/models/user_models.dart';
import 'package:flutter_instagram_clone/screens/profile_screen.dart';
import 'package:flutter_instagram_clone/services/database_service.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  Future<QuerySnapshot> _users;
   List<User> _user = [];
   
  @override
  void initState() {
    super.initState();
    _getAllUser();
  }

  _buildUserTile(User user){
    return ListTile(
      leading: CircleAvatar(
        radius: 20.0,
        backgroundImage: user.profileImageUrl.isEmpty
        ? AssetImage('assets/images/user_placeholder.png')
        : CachedNetworkImageProvider(user.profileImageUrl),
      ),
      title: Text(
        user.name,
      ),
      onTap: () => Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (_) => ProfileScreen(
            currentUserId:  Provider.of<UserData> (context).currentUserId,
            userId: user.id,
          ),
        ),
      ),
    );
  }

  _getAllUser() async {
    List<User> users = (await DatabaseService.getAllUsers()) as List<User>;
    setState(() {
      _user = users;
    });
  }

  _clearSearch(){
    WidgetsBinding.instance.addPostFrameCallback((_) => _searchController.clear());
    setState(() {
      _users = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 15.0),
            border: InputBorder.none,
            hintText: 'Search',
            prefixIcon: Icon(
              Icons.search,
              size: 30.0,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.clear,
              ),
              onPressed: _clearSearch,
            ),
            filled: true,
          ),
          onSubmitted: (input){
            print(input);
            if (input.isNotEmpty){
              setState(() {
              _users = DatabaseService.searchUsers(input);
            });
            }
          },
        ),
      ),
      body: _users == null 
      ? 
      // Center(
      //   child: Text(
      //     'Search for as user'
      //   ),
      // ) 
      RefreshIndicator(
        onRefresh: () => _getAllUser(),
        child :ListView.builder(
            itemCount: _user.length,
            itemBuilder: (BuildContext context, int index){
               return FutureBuilder(
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                User user = User.fromDoc(snapshot.data);
                print(user.name);
                print(user.email);
              return _buildUserTile(user);
              },
            );
          },
        ),

      )
      : FutureBuilder(
        future: _users,
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int index){
              User user = User.fromDoc(snapshot.data.documents[index]);
              return _buildUserTile(user);
            }
          );
        },
      ),
    );
  }
}