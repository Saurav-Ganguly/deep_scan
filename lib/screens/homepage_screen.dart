import 'package:flutter/material.dart';
import 'package:deep_scan/constants.dart';
import 'package:deep_scan/recent_searches/recent_searches_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:deep_scan/widgets/action_widget.dart';
import 'package:deep_scan/widgets/scan_widget.dart';

class HomepageScreen extends StatelessWidget {
  const HomepageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Searches',
            style: GoogleFonts.poppins(
              color: AppColors.textColor,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          RecentSearchesWidget(),
          const SizedBox(
            height: 8,
          ),
          Container(
            height: 150,
            padding: const EdgeInsets.all(5),
            // margin: const EdgeInsets.only(top: 50),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: Text(
                    'Your Section',
                    style: GoogleFonts.poppins(
                      color: AppColors.textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    MyAction(
                      icon: const Icon(
                        Icons.star,
                        color: Colors.white,
                      ),
                      text: 'Products',
                      onTap: () {},
                    ),
                    MyAction(
                      icon: const Icon(
                        Icons.star,
                        color: Colors.white,
                      ),
                      text: 'Recepies',
                      onTap: () {},
                    ),
                    MyAction(
                      icon: const Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      text: 'Profile',
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) => const ScanWidget(),
                  ),
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.myPurple,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Scan Product',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          'Food | Supplements | Cosmetics',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: const Color.fromARGB(255, 206, 205, 205),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 200,
            child: ScanWidget(),
          ),
        ],
      ),
    );
  }
}
