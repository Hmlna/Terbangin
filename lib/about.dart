import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class About extends StatelessWidget {
  final String appName = "Terbangin";
  final String version = "1.0.0";
  final String buildNumber = "1";
  final String developer = "Developed by Terbangin Team";
  final String description =
      "Terbangin is a flight ticket booking application that makes it easy for you to search and book tickets quickly and conveniently.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: Color(0xFF006BFF),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SvgPicture.asset(
                    'assets/plane-yellow.svg',
                    height: 80,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    appName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white
                      ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    "Versi $version (Build $buildNumber)",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                    )
                  ),
                const SizedBox(height: 20),
                Text(
                  developer,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
