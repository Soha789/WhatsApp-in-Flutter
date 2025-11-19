import 'package:flutter/material.dart';

void main() {
  runApp(const WhatsAppCloneApp());
}

/// Root app – handles theme + login state
class WhatsAppCloneApp extends StatefulWidget {
  const WhatsAppCloneApp({super.key});

  @override
  State<WhatsAppCloneApp> createState() => _WhatsAppCloneAppState();
}

class _WhatsAppCloneAppState extends State<WhatsAppCloneApp> {
  bool _isDark = false;
  bool _loggedIn = false;
  String _userName = 'You';

  void _onLogin(String name) {
    setState(() {
      _loggedIn = true;
      _userName = name.isEmpty ? 'You' : name;
    });
  }

  void _onLogout() {
    setState(() {
      _loggedIn = false;
    });
  }

  void _toggleTheme(bool value) {
    setState(() {
      _isDark = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter WhatsApp Clone',
      debugShowCheckedModeBanner: false,
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF0F2F5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF075E54),
          foregroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121B22),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF202C33),
          foregroundColor: Colors.white,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF075E54),
          brightness: Brightness.dark,
        ),
      ),
      home: _loggedIn
          ? HomeScreen(
              userName: _userName,
              isDark: _isDark,
              onToggleTheme: _toggleTheme,
              onLogout: _onLogout,
            )
          : LoginScreen(onLogin: _onLogin),
    );
  }
}

/// Simple login screen (no backend – demo only)
class LoginScreen extends StatefulWidget {
  final void Function(String name) onLogin;
  const LoginScreen({super.key, required this.onLogin});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    widget.onLogin(_nameController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF075E54),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.chat_bubble_rounded,
                      size: 64,
                      color: Color(0xFF075E54),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Flutter Chat',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'WhatsApp style messaging app (demo)',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Your Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone (dummy)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF075E54),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Note: This is a local demo.\nNo real authentication yet.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Home with bottom navigation: Chats, Status, Calls, Settings
class HomeScreen extends StatefulWidget {
  final String userName;
  final bool isDark;
  final void Function(bool) onToggleTheme;
  final VoidCallback onLogout;

  const HomeScreen({
    super.key,
    required this.userName,
    required this.isDark,
    required this.onToggleTheme,
    required this.onLogout,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  late List<Chat> _chats;

  @override
  void initState() {
    super.initState();
    _chats = demoChats; // copy reference to demo data
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      ChatsTab(
        chats: _chats,
        currentUserName: widget.userName,
      ),
      const StatusTab(),
      const CallsTab(),
      SettingsTab(
        userName: widget.userName,
        isDark: widget.isDark,
        onToggleTheme: widget.onToggleTheme,
        onLogout: widget.onLogout,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Chat'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.search),
          )
        ],
      ),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF075E54),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.circle_outlined),
            label: 'Status',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: 'Calls',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

/// CHATS TAB – list of conversations
class ChatsTab extends StatelessWidget {
  final List<Chat> chats;
  final String currentUserName;

  const ChatsTab({
    super.key,
    required this.chats,
    required this.currentUserName,
  });

  @override
  Widget build(BuildContext context) {
    if (chats.isEmpty) {
      return const Center(
        child: Text('No chats yet. Start a new conversation!'),
      );
    }

    return ListView.separated(
      itemCount: chats.length,
      separatorBuilder: (_, __) => const Divider(height: 0),
      itemBuilder: (context, index) {
        final chat = chats[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: chat.avatarColor,
            child: Text(
              chat.name.substring(0, 1),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          title: Text(
            chat.name,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            chat.lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                chat.lastTimeLabel,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
              if (chat.unreadCount > 0)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF25D366),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    chat.unreadCount.toString(),
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatPage(
                  chat: chat,
                  currentUserName: currentUserName,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/// STATUS TAB – placeholder
class StatusTab extends StatelessWidget {
  const StatusTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Status / Story feature (optional)\n\n'
          'Yahan aap baad mein image + text status add kar sakte ho\n'
          'jo 24 hours ke baad disappear ho jaye – WhatsApp jaisa.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

/// CALLS TAB – placeholder
class CallsTab extends StatelessWidget {
  const CallsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Voice & video calls (optional)\n\n'
          'Future mein yahan Agora / Zego / WebRTC use karke\n'
          'real voice/video calling add kar sakte ho.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

/// SETTINGS TAB – dark mode + logout
class SettingsTab extends StatelessWidget {
  final String userName;
  final bool isDark;
  final void Function(bool) onToggleTheme;
  final VoidCallback onLogout;

  const SettingsTab({
    super.key,
    required this.userName,
    required this.isDark,
    required this.onToggleTheme,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 12),
        ListTile(
          leading: const CircleAvatar(
            child: Icon(Icons.person),
          ),
          title: Text(userName),
          subtitle: const Text('Tap to edit (demo only)'),
        ),
        const Divider(),
        SwitchListTile(
          title: const Text('Dark Mode'),
          subtitle: const Text('Toggle light/dark theme'),
          value: isDark,
          onChanged: onToggleTheme,
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.color_lens_outlined),
          title: const Text('Chat Wallpaper (UI only)'),
          subtitle: const Text('Future: allow users to pick wallpaper'),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Wallpaper picker not implemented (demo).'),
              ),
            );
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text(
            'Logout',
            style: TextStyle(color: Colors.red),
          ),
          onTap: onLogout,
        ),
      ],
    );
  }
}

/// CHAT PAGE – actual conversation
class ChatPage extends StatefulWidget {
  final Chat chat;
  final String currentUserName;

  const ChatPage({
    super.key,
    required this.chat,
    required this.currentUserName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isMe: true,
      time: DateTime.now(),
      type: MessageType.text,
    );

    setState(() {
      widget.chat.messages.add(message);
      widget.chat.lastMessage = text;
      widget.chat.unreadCount = 0;
      widget.chat.lastTime = message.time;
    });

    _controller.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 80,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollToBottom();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _formatTime(DateTime time) {
    final h = time.hour;
    final m = time.minute.toString().padLeft(2, '0');
    final isPm = h >= 12;
    final hour12 = h == 0 ? 12 : (h > 12 ? h - 12 : h);
    return '$hour12:$m ${isPm ? 'PM' : 'AM'}';
  }

  @override
  Widget build(BuildContext context) {
    final messages = widget.chat.messages;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 90,
        leading: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            CircleAvatar(
              backgroundColor: widget.chat.avatarColor,
              child: Text(
                widget.chat.name.substring(0, 1),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        title: Text(widget.chat.name),
        actions: const [
          Icon(Icons.videocam),
          SizedBox(width: 16),
          Icon(Icons.call),
          SizedBox(width: 16),
          Icon(Icons.more_vert),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isMe = msg.isMe;
                final alignment =
                    isMe ? Alignment.centerRight : Alignment.centerLeft;
                final bubbleColor = isMe
                    ? const Color(0xFF005C4B)
                    : Theme.of(context).cardColor;
                final textColor = isMe
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyMedium?.color;

                return Align(
                  alignment: alignment,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: bubbleColor,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(12),
                            topRight: const Radius.circular(12),
                            bottomLeft:
                                Radius.circular(isMe ? 12 : 0), // tail style
                            bottomRight:
                                Radius.circular(isMe ? 0 : 12), // tail style
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              msg.text,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _formatTime(msg.time),
                              style: TextStyle(
                                color: (isMe
                                        ? Colors.white70
                                        : Colors.grey.shade500)
                                    .withOpacity(0.9),
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            color: Theme.of(context).scaffoldBackgroundColor,
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.emoji_emotions_outlined),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.attach_file),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _controller,
                        minLines: 1,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText: 'Type a message',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  CircleAvatar(
                    backgroundColor: const Color(0xFF075E54),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// DATA MODELS + DEMO DATA

enum MessageType { text, image, audio, video, file }

class Message {
  final String id;
  final String text;
  final bool isMe;
  final DateTime time;
  final MessageType type;

  Message({
    required this.id,
    required this.text,
    required this.isMe,
    required this.time,
    required this.type,
  });
}

class Chat {
  final String id;
  final String name;
  final Color avatarColor;
  List<Message> messages;
  String lastMessage;
  DateTime lastTime;
  int unreadCount;

  Chat({
    required this.id,
    required this.name,
    required this.avatarColor,
    required this.messages,
    required this.lastMessage,
    required this.lastTime,
    this.unreadCount = 0,
  });

  String get lastTimeLabel {
    final now = DateTime.now();
    if (now.difference(lastTime).inDays == 0) {
      final h = lastTime.hour.toString().padLeft(2, '0');
      final m = lastTime.minute.toString().padLeft(2, '0');
      return '$h:$m';
    }
    return '${lastTime.day}/${lastTime.month}';
  }
}

final List<Chat> demoChats = [
  Chat(
    id: '1',
    name: 'Best Friend',
    avatarColor: Colors.blueAccent,
    lastMessage: 'See you soon! 💚',
    lastTime: DateTime.now().subtract(const Duration(minutes: 5)),
    unreadCount: 2,
    messages: [
      Message(
        id: 'm1',
        text: 'Hey, how is your Flutter project going?',
        isMe: false,
        time: DateTime.now().subtract(const Duration(minutes: 25)),
        type: MessageType.text,
      ),
      Message(
        id: 'm2',
        text: 'I am making a WhatsApp-style app 😎',
        isMe: true,
        time: DateTime.now().subtract(const Duration(minutes: 20)),
        type: MessageType.text,
      ),
      Message(
        id: 'm3',
        text: 'Wow, send me screenshots when it is done!',
        isMe: false,
        time: DateTime.now().subtract(const Duration(minutes: 5)),
        type: MessageType.text,
      ),
      Message(
        id: 'm4',
        text: 'See you soon! 💚',
        isMe: false,
        time: DateTime.now().subtract(const Duration(minutes: 4)),
        type: MessageType.text,
      ),
    ],
  ),
  Chat(
    id: '2',
    name: 'Family Group',
    avatarColor: Colors.purple,
    lastMessage: 'Dinner at 8 PM.',
    lastTime: DateTime.now().subtract(const Duration(hours: 2)),
    unreadCount: 0,
    messages: [
      Message(
        id: 'f1',
        text: 'Don’t forget tomorrow’s plan!',
        isMe: false,
        time: DateTime.now().subtract(const Duration(hours: 3)),
        type: MessageType.text,
      ),
      Message(
        id: 'f2',
        text: 'Okay, got it 👍',
        isMe: true,
        time: DateTime.now().subtract(const Duration(hours: 2, minutes: 45)),
        type: MessageType.text,
      ),
      Message(
        id: 'f3',
        text: 'Dinner at 8 PM.',
        isMe: false,
        time: DateTime.now().subtract(const Duration(hours: 2)),
        type: MessageType.text,
      ),
    ],
  ),
  Chat(
    id: '3',
    name: 'Project Team',
    avatarColor: Colors.orange,
    lastMessage: 'Push your code to GitHub.',
    lastTime: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
    unreadCount: 0,
    messages: [
      Message(
        id: 'p1',
        text: 'We have to submit the project this week.',
        isMe: false,
        time: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
        type: MessageType.text,
      ),
      Message(
        id: 'p2',
        text: 'I am working on the chat screen UI.',
        isMe: true,
        time: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
        type: MessageType.text,
      ),
      Message(
        id: 'p3',
        text: 'Nice, push your code to GitHub.',
        isMe: false,
        time: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
        type: MessageType.text,
      ),
    ],
  ),
];
