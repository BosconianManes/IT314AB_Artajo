import 'package:flutter/material.dart';
import 'inbox.dart';
import 'message.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Social',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const SocialScreen(),
    );
  }
}

class Player {
  String name;
  String status;
  bool isOnline;
  bool isPlaying;

  Player({
    required this.name,
    required this.status,
    required this.isOnline,
    required this.isPlaying,
  });
}

List<Player> players = [
  Player(
    name: 'MissYouLikeKrazy',
    status: 'Online - VALORANT',
    isOnline: true,
    isPlaying: true,
  ),
  Player(
    name: 'bread',
    status: 'Playing - VALORANT',
    isOnline: true,
    isPlaying: true,
  ),
  Player(
    name: 'The14th',
    status: 'Playing - VALORANT',
    isOnline: true,
    isPlaying: true,
  ),
  Player(
    name: 'Carlvendish',
    status: 'Away - Riot Mobile',
    isOnline: false,
    isPlaying: false,
  ),
  Player(
    name: 'D1yah',
    status: 'Away - Riot Mobile',
    isOnline: false,
    isPlaying: false,
  ),
];

Widget buildRow(BuildContext context, Player player, bool isRedIcon) {
  IconData iconToUse = Icons.phone_iphone;
  if (player.isPlaying == true) {
    iconToUse = Icons.monitor;
  }

  Color statusColor = Colors.grey;
  if (player.isOnline == true) {
    statusColor = Colors.grey;
  }

  Color iconColor = Colors.white;
  if (isRedIcon == true) {
    iconColor = Colors.red;
  }

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MessageScreen(
            conversation: Conversation(
              name: player.name,
              status: player.status,
              isOnline: player.isOnline,
            ),
          ),
        ),
      );
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: iconColor),
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
                    color: player.isOnline ? Colors.green : Colors.grey,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.name,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(iconToUse, color: Colors.grey, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      player.status,
                      style: TextStyle(color: statusColor, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class SocialScreen extends StatelessWidget {
  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Social', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: Colors.grey),
                SizedBox(width: 10),
                Text('Search', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text('Friends', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InboxScreen(),
                      ),
                    );
                  },
                  child: const Text('Messages', style: TextStyle(color: Colors.grey)),
                ),
                const SizedBox(width: 20),
                const Text('Requests', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(height: 2, color: Colors.red),
          const SizedBox(height: 20),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('VALORANT 3', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 10),

          for (int i = 0; i < 3; i++)
            buildRow(context, players[i], true),

          const SizedBox(height: 20),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Online  4', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 10),

          for (int i = 3; i < 5; i++)
            buildRow(context, players[i], false),
        ],
      ),
    );
  }
}