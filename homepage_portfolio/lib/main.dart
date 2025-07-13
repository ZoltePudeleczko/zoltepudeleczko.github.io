import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'config/app_config.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '${AppConfig.lastName}_',
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

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
  }

  Widget _buildSocialButton(IconData icon, String tooltip, String url) {
    return IconButton(
      icon: FaIcon(icon),
      tooltip: tooltip,
      onPressed: () => _launchUrl(url),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConfig.horizontalPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: AppConfig.avatarRadius,
                    backgroundImage: AssetImage('assets/avatar.png'),
                    backgroundColor: Colors.transparent,
                  ),
                  const SizedBox(height: AppConfig.spacingLarge),
                  const AnimatedNameRow(),
                  const SizedBox(height: AppConfig.spacingMedium),
                  Text(AppConfig.title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: AppConfig.spacingLarge),
                  const ResponsiveDescription(),
                  const SizedBox(height: AppConfig.spacingXLarge),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton(FontAwesomeIcons.github, 'GitHub', AppConfig.githubUrl),
                      _buildSocialButton(FontAwesomeIcons.linkedin, 'LinkedIn', AppConfig.linkedinUrl),
                    ],
                  ),
                  const SizedBox(height: AppConfig.spacingXLarge),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConfig.buttonHorizontalPadding,
                        vertical: AppConfig.buttonVerticalPadding,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppConfig.buttonBorderRadius),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.mail_outline, color: Colors.white),
                    label: const Text('Say Hello'),
                    onPressed: () => _launchUrl(AppConfig.emailUrl),
                  ),
                  const SizedBox(height: AppConfig.spacingFooter),
                  const _Footer(),
                ],
              ),
            ),
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
    Future.delayed(const Duration(milliseconds: AppConfig.animationDurationMs), () {
      if (mounted) {
        setState(() {
          _animationFinished = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textStyle = Theme.of(context).textTheme.headlineLarge;
        
        final firstTextPainter = TextPainter(
          text: TextSpan(text: AppConfig.firstName, style: textStyle),
          textDirection: TextDirection.ltr,
          textScaler: MediaQuery.textScalerOf(context),
        )..layout();
        
        final secondTextPainter = TextPainter(
          text: TextSpan(text: '${AppConfig.lastName}_', style: textStyle),
          textDirection: TextDirection.ltr,
          textScaler: MediaQuery.textScalerOf(context),
        )..layout();
        
        final totalWidth = firstTextPainter.width + AppConfig.spacingSmall + secondTextPainter.width;
        final shouldWrap = totalWidth > constraints.maxWidth;
        
        final nameWidget = _animationFinished
            ? Text(AppConfig.lastName, style: textStyle)
            : AnimatedTextKit(
                repeatForever: false,
                animatedTexts: [
                  TyperAnimatedText(
                    AppConfig.lastName,
                    textStyle: textStyle,
                    speed: const Duration(milliseconds: AppConfig.typingSpeedMs),
                  ),
                ],
                isRepeatingAnimation: false,
              );
        
        if (shouldWrap) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppConfig.firstName, style: textStyle),
              const SizedBox(height: AppConfig.spacingSmall),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  nameWidget,
                  BlinkingUnderscore(style: textStyle),
                ],
              ),
            ],
          );
        } else {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppConfig.firstName, style: textStyle),
              const SizedBox(width: AppConfig.spacingSmall),
              nameWidget,
              BlinkingUnderscore(style: textStyle),
            ],
          );
        }
      },
    );
  }
}

class ResponsiveDescription extends StatelessWidget {
  const ResponsiveDescription({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: textStyle,
        children: [
          TextSpan(text: AppConfig.descriptionFirstPart),
          const TextSpan(text: ' '),
          TextSpan(text: AppConfig.descriptionSecondPart),
        ],
      ),
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
      duration: const Duration(milliseconds: AppConfig.underscoreBlinkDurationMs),
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
    return FadeTransition(
      opacity: _opacity,
      child: Text('_', style: widget.style),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  Widget _buildLink(String text, String url) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.blueAccent,
          decoration: TextDecoration.underline,
          fontSize: 14,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'This page was proudly (and quickly) vibe-coded.',
          style: textStyle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppConfig.spacingTiny),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('You can check out the source code ', style: textStyle),
            _buildLink('here', AppConfig.repoUrl),
          ],
        ),
      ],
    );
  }
}
