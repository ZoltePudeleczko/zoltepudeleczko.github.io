import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

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

  static const _title = 'Software Engineer';
  static const _description =
      'System design. Programming. Getting things done.';

  static const _githubUrl = 'https://github.com/ZoltePudeleczko';
  static const _youtubeUrl = 'https://youtube.com/@ZoltePudeleczko';
  static const _xUrl = 'https://x.com/ZoltePudeleczko';
  static const _linkedinUrl = 'https://linkedin.com/in/szymon-zborowski';

  static const _emailUrl = 'mailto:szzborowski@gmail.com';

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
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
              CircleAvatar(
                radius: 56,
                backgroundImage: AssetImage('assets/avatar.png'),
                backgroundColor: Colors.transparent,
              ),
              const SizedBox(height: 24),
              // Replace the old Row with the new widget
              const AnimatedNameRow(),
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
                onPressed: () => _launchUrl(_emailUrl),
              ),
              // Add footer spacing
              const SizedBox(height: 48),
              // Footer
              const _Footer(),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedNameRow extends StatefulWidget {
  const AnimatedNameRow({super.key});

  @override
  State<AnimatedNameRow> createState() => _AnimatedNameRowState();
}

class _AnimatedNameRowState extends State<AnimatedNameRow> {
  bool _animationFinished = false;

  @override
  void initState() {
    super.initState();
    // 9 letters * 180ms = 1620ms, add 300ms buffer
    Future.delayed(const Duration(milliseconds: 1920), () {
      if (mounted) {
        setState(() {
          _animationFinished = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          'Szymon Samuel',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(width: 8),
        if (!_animationFinished)
          AnimatedTextKit(
            repeatForever: false,
            animatedTexts: [
              TyperAnimatedText(
                'Zborowski',
                textStyle: Theme.of(context).textTheme.headlineLarge,
                speed: const Duration(milliseconds: 180),
              ),
            ],
            isRepeatingAnimation: false,
          )
        else
          Text(
            'Zborowski',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        BlinkingUnderscore(style: Theme.of(context).textTheme.headlineLarge),
      ],
    );
  }
}

class BlinkingUnderscore extends StatefulWidget {
  const BlinkingUnderscore({super.key, this.style});
  final TextStyle? style;

  @override
  State<BlinkingUnderscore> createState() => _BlinkingUnderscoreState();
}

class _BlinkingUnderscoreState extends State<BlinkingUnderscore>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _opacity = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _getUnderscoreWidth(context),
      child: FadeTransition(
        opacity: _opacity,
        child: Text('_', style: widget.style),
      ),
    );
  }

  double _getUnderscoreWidth(BuildContext context) {
    final style = widget.style ?? DefaultTextStyle.of(context).style;
    final painter = TextPainter(
      text: TextSpan(text: '_', style: style),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();
    return painter.width;
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  static const _repoUrl = 'https://github.com/ZoltePudeleczko/HomePageV2';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'This page was proudly (and quickly) vibe-coded.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'You can check out the source code ',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                  ),
              textAlign: TextAlign.center,
            ),
            GestureDetector(
              onTap: () async {
                const url = _repoUrl;
                final uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              child: Text(
                'here',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.blueAccent,
                      decoration: TextDecoration.underline,
                      fontSize: 14,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
