import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pcs_14/pages/chat_page.dart';
import 'package:pcs_14/services/auth_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // sign user out 
  void signOut() {
    // get auth service
    final authService = Provider.of<AuthService>(context, listen: false);

    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Главная'),
        actions: [
          // sign out button
          IconButton(onPressed: signOut, icon: const Icon(Icons.logout))
        ],
      ),
      body: _builtUserList(),
    );
  }

  // build a list of users except for the the current logged in user
  Widget _builtUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Ошибка');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Загрузка...');
        }

        return ListView(
          children: snapshot.data!.docs
            .map<Widget>((doc) => _builtUserListItem(doc))
            .toList(),
        );
      },
    );
  }

  // build individual user list items
  Widget _builtUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    // display all users except current user
    if (_auth.currentUser!.email != data ['email']) {
      return ListTile(
        title: Text(data['email']),
        onTap: () {
          // pass clicked user's UID to the chat page
          Navigator.push (
            context, 
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverUserEmail: data['email'],
                receiverUserID: data['uid'],
              ),
            ),
          );
        },
      );
    } else {
      // return empty container 
      return Container();
    }
  }
}
