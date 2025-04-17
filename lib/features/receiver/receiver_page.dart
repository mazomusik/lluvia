import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ReceiverPage extends StatelessWidget {
  const ReceiverPage({super.key});

  Future<ListResult> fetchAllScreenshots() {
    final storage = FirebaseStorage.instance;
    return storage.ref().child('screenshots').listAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modo Receptor')),
      body: FutureBuilder<ListResult>(
        future: fetchAllScreenshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data?.items ?? [];

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final ref = items[index];
              return ListTile(
                title: Text(ref.fullPath),
                onTap: () {
                  // TODO: Abrir imagen o nota
                },
              );
            },
          );
        },
      ),
    );
  }
}
