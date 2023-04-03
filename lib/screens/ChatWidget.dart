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
  await CommentProvider().addMessage(bearerToken, widget.eventDetails, message);
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
        if (snapshot.hasData) {
          final messages = snapshot.data!;
          return Scaffold(
            appBar: AppBar(title: Text('Chat')),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return ListTile(
                        subtitle: Text(message.text),
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Enter a message',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () => _sendMessage(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
