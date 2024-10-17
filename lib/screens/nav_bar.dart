import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_eatanong_flutter/providers/person_provider.dart'; // Import your PersonProvider

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Use Consumer to get access to the PersonProvider
          Consumer<PersonProvider>(
            builder: (context, personProvider, child) {
              // Check if there are any persons stored in Hive
              if (personProvider.persons.isNotEmpty) {
                final person = personProvider.persons.first; // Get the first person for simplicity

                return UserAccountsDrawerHeader(
                  accountName: Text("Hello, ${person.name}"),
                  accountEmail: Text(""),
                );
              } else {
                return UserAccountsDrawerHeader(
                  accountName: Text("No Person Data"),
                  accountEmail: Text("No Email Available"),
                );
              }
            },
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
            leading: Icon(Icons.fastfood),
            title: Text("Food Screen"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/food screen");
            },
          ),
          ListTile(
            leading: Icon(Icons.account_box_outlined),
            title: Text("User Profile"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/user profile");
            },
          ),
        ],
      ),
    );
  }
}
