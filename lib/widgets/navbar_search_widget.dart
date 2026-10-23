import 'package:flutter/material.dart';
import 'package:flutter_iconly_plus/iconly.dart';

class NavbarSearchWidget extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: TextField(
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                fillColor: Color(0xff2A2A2A),
                filled: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 12,
                ),
                hintText: "Search Coffee",
                hintStyle: TextStyle(
                  color: Color(0xffA2A2A2),
                ),
                prefixIcon: Icon(
                  IconlyLight.search,
                  color: Colors.white,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          AspectRatio(
            aspectRatio: 1,
            child: IconButton.filled(
              style: IconButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(IconlyLight.filter),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
