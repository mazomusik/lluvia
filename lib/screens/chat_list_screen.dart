// lib/screens/user_list_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lluvia/screens/chat_screen.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  Future<Map<String, dynamic>> _getLastMessageData(String otherUserId) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    final querySnapshot = await FirebaseFirestore.instance
        .collection('messages')
        .where('senderId', whereIn: [currentUser!.uid, otherUserId])
        .where('receiverId', whereIn: [currentUser.uid, otherUserId])
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final data = querySnapshot.docs.first.data();
      return {
        'lastMessage': data['text'] ?? '',
        'timestamp': data['timestamp'],
      };
    }

    return {'lastMessage': '', 'timestamp': null};
  }

  Future<int> _getUnreadCount(String otherUserId) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    final querySnapshot = await FirebaseFirestore.instance
        .collection('messages')
        .where('senderId', isEqualTo: otherUserId)
        .where('receiverId', isEqualTo: currentUser!.uid)
        .where('isRead', isEqualTo: false)
        .get();

    return querySnapshot.docs.length;
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Usuarios"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No hay usuarios disponibles."));
          }

          final users = snapshot.data!.docs
              .where((doc) => doc['uid'] != currentUser!.uid)
              .toList();

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];

              return FutureBuilder(
                future: Future.wait([
                  _getLastMessageData(user['uid']),
                  _getUnreadCount(user['uid']),
                ]),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (!snapshot.hasData) {
                    return const ListTile(title: Text("Cargando..."));
                  }

                  final lastMessageData = snapshot.data![0] as Map<String, dynamic>;
                  final unreadCount = snapshot.data![1] as int;

                  String formattedTime = '';
                  if (lastMessageData['timestamp'] != null) {
                    final timestamp = lastMessageData['timestamp'] as Timestamp;
                    formattedTime = DateFormat('hh:mm a').format(timestamp.toDate());
                  }

                  return ListTile(
                    title: Text(user['email']),
                    subtitle: Text(
                      lastMessageData['lastMessage'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          formattedTime,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        if (unreadCount > 0)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              unreadCount.toString(),
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            otherUserId: user['uid'],
                            otherUserEmail: user['email'],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
