import 'package:flutter/material.dart';
import 'inbox.dart';

class Message {
  String text;
  bool isSender;

  Message({
    required this.text,
    this.isSender = true,
  });
}

class MessageScreen extends StatelessWidget {
  final Conversation conversation;

  const MessageScreen({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    // Fallback values on the chat screen too
    final displayName = conversation.name ?? 'Unknown User';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(displayName, style: const TextStyle(color: Colors.white, fontSize: 16)),
                Text(
                  conversation.status ?? 'Offline',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
      body: const SizedBox.expand(),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Send a message',
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            suffixIcon: const Icon(Icons.send, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}