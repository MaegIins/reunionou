import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Singleton/Auth.dart';
import '../models/Message.dart';
import '../models/event.dart';
import '../providers/commentProvider.dart';

class ChatWidget extends StatefulWidget {
  final event? eventDetails;
  const ChatWidget({Key? key, required this.eventDetails}) : super(key: key);

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final bearerToken = "Bearer " + Auth().token;
    final commentText = _messageController.text.trim();

    if (commentText.isEmpty) {
      final snackBar = SnackBar(
        content: Text('Please enter a message.'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      return;
    }

    final message = Message(text: commentText);
    await CommentProvider()
        .addMessage(bearerToken, widget.eventDetails, message);
    setState(() {});
  }

  Future<List<Message>> getComment() async {
    final bearerToken = "Bearer " + Auth().token;
    return CommentProvider().getComment(bearerToken, widget.eventDetails);
  }

  @override
Widget build(BuildContext context) {
  return FutureBuilder<List<Message>>(
    future: getComment(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (snapshot.hasData) {
        final messages = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            title: Text('Commentaires'),
            centerTitle: true,
            
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      elevation: 4,
                      child: ListTile(
                        title: Text(
                          message.text,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4),
                            Text(
                              message.username.toString(),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              message.date.toString().substring(0, 16),
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            SizedBox(height: 8),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Entrez un commentaire',
                          border: InputBorder.none,
                         
                          filled: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    FloatingActionButton(
                      
                      child: Icon(Icons.send),
                      onPressed: () => _sendMessage(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      } else if (snapshot.hasError) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Erreur'),
            centerTitle: true,
            backgroundColor: Colors.red[800],
          ),
          body: Center(
            child: Text(
              'Erreur : ${snapshot.error}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      } else {
        return Scaffold(
          appBar: AppBar(
            title: Text('Commentaires'),
            centerTitle: true,
            
          ),
          body: Center(
            child: Text(
              'Aucun commentaire trouvé',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
    },
  );
}
}
