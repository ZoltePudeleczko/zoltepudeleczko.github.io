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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
              // Replace the old Row with the new widget
              const AnimatedNameRow(),
              const SizedBox(height: AppConfig.spacingMedium),
              Text(AppConfig.title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppConfig.spacingLarge),
              const ResponsiveDescription(),
              const SizedBox(height: AppConfig.spacingXLarge),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.github),
                    tooltip: 'GitHub',
                    onPressed: () => _launchUrl(AppConfig.githubUrl),
                  ),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.youtube),
                    tooltip: 'YouTube',
                    onPressed: () => _launchUrl(AppConfig.youtubeUrl),
                  ),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.xTwitter),
                    tooltip: 'X',
                    onPressed: () => _launchUrl(AppConfig.xUrl),
                  ),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.linkedin),
                    tooltip: 'LinkedIn',
                    onPressed: () => _launchUrl(AppConfig.linkedinUrl),
                  ),
                ],
              ),
              const SizedBox(height: AppConfig.spacingXLarge),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppConfig.buttonHorizontalPadding, vertical: AppConfig.buttonVerticalPadding),
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
              // Add footer spacing
              const SizedBox(height: AppConfig.spacingFooter),
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
  bool _shouldWrap = false;
  double _lastScreenWidth = 0;

  @override
  void initState() {
    super.initState();
    // Calculate if the text will wrap
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateWrap();
    });
    
    Future.delayed(const Duration(milliseconds: AppConfig.animationDurationMs), () {
      if (mounted) {
        setState(() {
          _animationFinished = true;
        });
      }
    });
  }

  void _calculateWrap() {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Only recalculate if screen width actually changed
    if (screenWidth == _lastScreenWidth) return;
    _lastScreenWidth = screenWidth;
    
    // Account for padding (24px on each side) and some extra margin for safety
    final availableWidth = screenWidth - 80;
    final textStyle = Theme.of(context).textTheme.headlineLarge;
    
    // Calculate width of first name
    final firstTextPainter = TextPainter(
      text: TextSpan(text: AppConfig.firstName, style: textStyle),
      textDirection: TextDirection.ltr,
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();
    
    // Calculate width of last name with underscore
    final secondTextPainter = TextPainter(
      text: TextSpan(text: '${AppConfig.lastName}_', style: textStyle),
      textDirection: TextDirection.ltr,
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();
    
    // Add 8px spacing between texts
    final totalWidth = firstTextPainter.width + 8 + secondTextPainter.width;
    
    setState(() {
      _shouldWrap = totalWidth > availableWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check if screen size changed and recalculate if needed
    final currentScreenWidth = MediaQuery.of(context).size.width;
    if (currentScreenWidth != _lastScreenWidth) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _calculateWrap();
        }
      });
    }
    
    if (_shouldWrap) {
      // If wrapping is needed, use Column instead of Wrap
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppConfig.firstName,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: AppConfig.spacingSmall),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!_animationFinished)
                AnimatedTextKit(
                  repeatForever: false,
                  animatedTexts: [
                    TyperAnimatedText(
                      AppConfig.lastName,
                      textStyle: Theme.of(context).textTheme.headlineLarge,
                      speed: const Duration(milliseconds: AppConfig.typingSpeedMs),
                    ),
                  ],
                  isRepeatingAnimation: false,
                )
              else
                Text(
                  AppConfig.lastName,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              BlinkingUnderscore(style: Theme.of(context).textTheme.headlineLarge),
            ],
          ),
        ],
      );
    } else {
      // If no wrapping needed, use the original Wrap layout
      return Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            AppConfig.firstName,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(width: AppConfig.spacingSmall),
          if (!_animationFinished)
            AnimatedTextKit(
              repeatForever: false,
              animatedTexts: [
                TyperAnimatedText(
                  AppConfig.lastName,
                  textStyle: Theme.of(context).textTheme.headlineLarge,
                  speed: const Duration(milliseconds: AppConfig.typingSpeedMs),
                ),
              ],
              isRepeatingAnimation: false,
            )
          else
            Text(
              AppConfig.lastName,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          BlinkingUnderscore(style: Theme.of(context).textTheme.headlineLarge),
        ],
      );
    }
  }
}

class ResponsiveDescription extends StatelessWidget {
  const ResponsiveDescription({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    return LayoutBuilder(
      builder: (context, constraints) {
        // Measure widths
        final textScaler = MediaQuery.textScalerOf(context);
        final firstPainter = TextPainter(
          text: TextSpan(text: '${AppConfig.descriptionFirstPart} ', style: textStyle),
          textDirection: TextDirection.ltr,
          textScaler: textScaler,
        )..layout();
        final secondPainter = TextPainter(
          text: TextSpan(text: AppConfig.descriptionSecondPart, style: textStyle),
          textDirection: TextDirection.ltr,
          textScaler: textScaler,
        )..layout();
        final totalWidth = firstPainter.width + secondPainter.width;
        if (totalWidth <= constraints.maxWidth) {
          // Both fit on one line
          return Text(
            '${AppConfig.descriptionFirstPart} ${AppConfig.descriptionSecondPart}',
            style: textStyle,
            textAlign: TextAlign.center,
          );
        } else if (secondPainter.width <= constraints.maxWidth) {
          // Only second part fits on its own line
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(AppConfig.descriptionFirstPart, style: textStyle, textAlign: TextAlign.center),
              Text(AppConfig.descriptionSecondPart, style: textStyle, textAlign: TextAlign.center),
            ],
          );
        } else {
          // Second part is too long for one line, let it wrap naturally
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(AppConfig.descriptionFirstPart, style: textStyle, textAlign: TextAlign.center),
              Text(AppConfig.descriptionSecondPart, style: textStyle, textAlign: TextAlign.center, softWrap: true),
            ],
          );
        }
      },
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
        const SizedBox(height: AppConfig.spacingTiny),
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
                final uri = Uri.parse( AppConfig.repoUrl);
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
