import 'package:flutter/material.dart';
import 'message.dart';

// Data & Fallbacks: fields are nullable so we can demonstrate fallback values
class Conversation {
  String? name;
  String? status;
  bool isOnline;
  bool isUnread;

  Conversation({
    this.name,
    this.status,
    this.isOnline = false,
    this.isUnread = false,
  });
}

List<Conversation> conversations = [
  Conversation(
    name: 'Carlvendish',
    status: 'Away - Riot Mobile',
    isOnline: false,
    isUnread: false,
  ),
  Conversation(
    name: 'bread',
    status: 'Playing - VALORANT',
    isOnline: true,
    isUnread: false,
  ),
  Conversation(
    // no name on purpose -> fallback value kicks in
    status: 'Away - Riot Mobile',
    isOnline: false,
    isUnread: false,
  ),
];

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  // mark as read
  void _markAsRead(int index) {
    setState(() {
      conversations[index].isUnread = false;
    });
  }

  // delete
  void _deleteConversation(int index) {
    setState(() {
      conversations.removeAt(index);
    });
  }

  Widget _buildRow(int index) {
    final convo = conversations[index];

    // Fallback value for missing data
    final displayName = convo.name ?? 'Unknown User';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Stack(
            children: [
              const CircleAvatar(
                radius: 26,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white),
              ),
              // online/offline status dot
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: convo.isOnline ? Colors.green : Colors.grey,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: GestureDetector(
              // tap on a user -> go to chatroom
              onTap: () {
                _markAsRead(index);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MessageScreen(conversation: convo),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        displayName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight:
                          convo.isUnread ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (convo.isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    convo.status ?? 'Offline',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _deleteConversation(index),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Messages', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (context, index) => _buildRow(index),
      ),
    );
  }
}