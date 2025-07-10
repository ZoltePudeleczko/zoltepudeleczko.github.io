import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zborowski_',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Colors.black,
          secondary: Colors.blueAccent,
        ),
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          titleMedium: TextStyle(
            fontSize: 20,
            color: Colors.black87,
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ),
      home: const PortfolioHomePage(),
    );
  }
}

class PortfolioHomePage extends StatelessWidget {
  const PortfolioHomePage({super.key});

  static const _name = 'Your Name';
  static const _title = '.NET Backend Developer';
  static const _description =
      'Passionate about building scalable backend systems. Minimalist. Professional.';

  static const _githubUrl = 'https://github.com/yourprofile';
  static const _youtubeUrl = 'https://youtube.com/yourprofile';
  static const _xUrl = 'https://x.com/yourprofile';
  static const _linkedinUrl = 'https://linkedin.com/in/yourprofile';

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_name, style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 12),
              Text(_title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 24),
              Text(
                _description,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.github),
                    tooltip: 'GitHub',
                    onPressed: () => _launchUrl(_githubUrl),
                  ),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.youtube),
                    tooltip: 'YouTube',
                    onPressed: () => _launchUrl(_youtubeUrl),
                  ),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.xTwitter),
                    tooltip: 'X',
                    onPressed: () => _launchUrl(_xUrl),
                  ),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.linkedin),
                    tooltip: 'LinkedIn',
                    onPressed: () => _launchUrl(_linkedinUrl),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                  elevation: 0,
                ),
                icon: const Icon(Icons.mail_outline, color: Colors.white),
                label: const Text('Say Hello'),
                onPressed: () => _launchUrl('mailto:szzborowski@gmail.com'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
