import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class StudentSkeleton extends StatelessWidget {
  const StudentSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10, // Number of shimmer items
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            height:
                70.0, // Adjusted height to accommodate leading icon and text
            child: Row(
              children: [
                // Leading icon placeholder
                Container(
                  width: 50.0, // Width of the leading icon
                  height: 50.0, // Height of the leading icon
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16.0), // Space between icon and text
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title placeholder
                      Container(
                        height: 16.0, // Height of the title
                        color: Colors.white,
                      ),
                      const SizedBox(
                          height: 4.0), // Space between title and subtitle
                      // Subtitle placeholder
                      Container(
                        height: 14.0, // Height of the subtitle
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
