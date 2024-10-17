import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text("Hello, Ivan"),
            accountEmail: const Text("icastro@example.com"),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () {
              Navigator.pushNamed(context, "/home");
            },
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text("Person Screen"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/person screen");
            },
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text("Food Screen"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/food screen");
            },
          ),
        ],
      ),
    );
  }
}