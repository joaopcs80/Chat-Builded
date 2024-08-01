import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Chat_Screen.dart';

class RoomSelectionScreen extends StatefulWidget {
  @override
  _RoomSelectionScreenState createState() => _RoomSelectionScreenState();
}

class _RoomSelectionScreenState extends State<RoomSelectionScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roomController = TextEditingController();
  final CollectionReference _roomsCollection = FirebaseFirestore.instance.collection('rooms');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Escolha uma Sala'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Nome'),
                ),
                TextField(
                  controller: _roomController,
                  decoration: InputDecoration(labelText: 'Nova Sala'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_nameController.text.isNotEmpty && _roomController.text.isNotEmpty) {
                      await _createRoomIfNotExists(_roomController.text);
                      _roomController.clear();
                    }
                  },
                  child: Text('Criar Nova Sala'),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _roomsCollection.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var rooms = snapshot.data!.docs;

                if (rooms.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.meeting_room, size: 80, color: Colors.grey),
                        Text('Nenhuma sala disponível', style: TextStyle(fontSize: 18, color: Colors.grey)),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    var room = rooms[index];
                    return ListTile(
                      title: Text(room.id),
                      onTap: () {
                        if (_nameController.text.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                name: _nameController.text,
                                room: room.id,
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Por favor, insira seu nome antes de entrar em uma sala.')),
                          );
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createRoomIfNotExists(String roomName) async {
    final roomDoc = _roomsCollection.doc(roomName);
    final roomSnapshot = await roomDoc.get();

    if (!roomSnapshot.exists) {
      await roomDoc.set({'createdAt': FieldValue.serverTimestamp()});
    }
  }
}