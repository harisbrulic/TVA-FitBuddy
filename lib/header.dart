import 'package:flutter/material.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;

  Header({required this.title, this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFFFED467),
      leading: showBackButton
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
