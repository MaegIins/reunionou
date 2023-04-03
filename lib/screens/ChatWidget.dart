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

  void _sendMessage(BuildContext context) async {
    final messageProvider =
        Provider.of<CommentProvider>(context, listen: false);
    final message = Message(
      text: _messageController.text.trim(),
    );
    try {
      await messageProvider.addMessage(message);
      _messageController.clear();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bearerToken = "Bearer " + Auth().token;
    return FutureBuilder<List<Message>>(
      future: CommentProvider().getComment(bearerToken, widget.eventDetails),
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
                        onPressed: () => _sendMessage(context),
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
