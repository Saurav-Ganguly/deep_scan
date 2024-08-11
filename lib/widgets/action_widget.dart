import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:deep_scan/constants.dart';

class MyAction extends StatelessWidget {
  const MyAction({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });
  final Icon icon;
  final String text;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 90,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.myPurple,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 5,
                offset: const Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(
                height: 3,
              ),
              Text(
                text,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: const Color.fromARGB(255, 206, 205, 205),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
