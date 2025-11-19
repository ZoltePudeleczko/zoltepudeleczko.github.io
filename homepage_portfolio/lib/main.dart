import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'config/app_config.dart';
import 'config/text_content.dart';
import 'config/text_styles.dart';

// Shared URL launcher utility
Future<void> launchUrlSafe(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

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
        textTheme: TextTheme(
          headlineLarge: AppTextStyles.headlineLarge,
          titleMedium: AppTextStyles.titleMedium,
          bodyMedium: AppTextStyles.bodyMedium,
        ),
      ),
      home: const PortfolioHomePage(),
    );
  }
}

class PortfolioHomePage extends StatelessWidget {
  const PortfolioHomePage({super.key});

  Widget _buildSocialButton(IconData icon, String tooltip, String url) {
    return IconButton(
      icon: FaIcon(icon),
      tooltip: tooltip,
      onPressed: () => launchUrlSafe(url),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AnimatedBackground(),
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConfig.horizontalPadding,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AnimatedAvatar(),
                      const SizedBox(height: AppConfig.spacingLarge),
                      const AnimatedNameRow(),
                      const SizedBox(height: AppConfig.spacingMedium),
                      Text(
                        AppConfig.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppConfig.spacingLarge),
                      const ResponsiveDescription(),
                      const SizedBox(height: AppConfig.spacingXLarge),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSocialButton(
                            FontAwesomeIcons.github,
                            TextContent.githubLabel,
                            AppConfig.githubUrl,
                          ),
                          _buildSocialButton(
                            FontAwesomeIcons.linkedin,
                            TextContent.linkedinLabel,
                            AppConfig.linkedinUrl,
                          ),
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
                            borderRadius: BorderRadius.circular(
                              AppConfig.buttonBorderRadius,
                            ),
                          ),
                          textStyle: AppTextStyles.buttonText,
                          elevation: 0,
                        ),
                        icon: const Icon(
                          Icons.mail_outline,
                          color: Colors.white,
                        ),
                        label: const Text(TextContent.sayHelloButton),
                        onPressed: () => launchUrlSafe(AppConfig.emailUrl),
                      ),
                      const SizedBox(height: AppConfig.spacingFooter),
                      const PortfolioSection(),
                      const SizedBox(height: AppConfig.spacingFooter),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
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
    Future.delayed(
      const Duration(milliseconds: AppConfig.animationDurationMs),
      () {
        if (mounted) {
          setState(() {
            _animationFinished = true;
          });
        }
      },
    );
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

        final totalWidth =
            firstTextPainter.width +
            AppConfig.spacingSmall +
            secondTextPainter.width;
        final shouldWrap = totalWidth > constraints.maxWidth;

        final nameWidget =
            _animationFinished
                ? Text(AppConfig.lastName, style: textStyle)
                : AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText(
                      AppConfig.lastName,
                      textStyle: textStyle,
                      speed: const Duration(
                        milliseconds: AppConfig.typingSpeedMs,
                      ),
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
                children: [nameWidget, BlinkingUnderscore(style: textStyle)],
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
    return Text(
      '${AppConfig.descriptionFirstPart} ${AppConfig.descriptionSecondPart}',
      style: Theme.of(context).textTheme.bodyMedium,
      textAlign: TextAlign.center,
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
      duration: const Duration(
        milliseconds: AppConfig.underscoreBlinkDurationMs,
      ),
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
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => launchUrlSafe(url),
        child: Text(text, style: AppTextStyles.footerText),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          TextContent.footerTagline,
          style: AppTextStyles.footerBodyText,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppConfig.spacingTiny),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              TextContent.sourceCodePrefix,
              style: AppTextStyles.footerBodyText,
            ),
            _buildLink(TextContent.sourceCodeLink, AppConfig.repoUrl),
          ],
        ),
      ],
    );
  }
}

class AnimatedAvatar extends StatefulWidget {
  const AnimatedAvatar({super.key});

  @override
  State<AnimatedAvatar> createState() => _AnimatedAvatarState();
}

class _AnimatedAvatarState extends State<AnimatedAvatar>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(
        milliseconds: AppConfig.avatarRotationDurationMs,
      ),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void _triggerAnimation() {
    if (_isAnimating) return;

    setState(() {
      _isAnimating = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(TextContent.avatarGreeting),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(20),
      ),
    );

    _triggerRotationAnimation();
  }

  void _triggerRotationAnimation() async {
    await _rotationController.forward();
    await _rotationController.reverse();
    setState(() => _isAnimating = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _triggerAnimation,
      child: AnimatedBuilder(
        animation: _rotationAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotationAnimation.value * 2 * math.pi,
            child: CircleAvatar(
              radius: AppConfig.avatarRadius,
              backgroundImage: AssetImage(AppConfig.avatarImagePath),
              backgroundColor: Colors.transparent,
            ),
          );
        },
      ),
    );
  }
}

class PortfolioSection extends StatefulWidget {
  const PortfolioSection({super.key});

  @override
  State<PortfolioSection> createState() => _PortfolioSectionState();
}

class _PortfolioSectionState extends State<PortfolioSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _arrowController;
  late final Animation<Offset> _arrowSlide;
  late final Animation<double> _arrowOpacity;
  final GlobalKey _carouselKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _arrowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    final curve = CurvedAnimation(
      parent: _arrowController,
      curve: Curves.easeInOut,
    );
    _arrowSlide = Tween<Offset>(
      begin: const Offset(0, -0.15),
      end: const Offset(0, 0.15),
    ).animate(curve);
    _arrowOpacity = Tween<double>(begin: 0.6, end: 1.0).animate(curve);
  }

  @override
  void dispose() {
    _arrowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projects = <_ProjectItem>[
      _ProjectItem(
        title: TextContent.tasksDoListName,
        url: AppConfig.tasksDoListUrl,
        previewAsset: AppConfig.tasksDoListPreviewAsset,
      ),
      _ProjectItem(
        title: TextContent.kodiGeforceNowName,
        url: AppConfig.kodiGeforceNowUrl,
        previewAsset: AppConfig.kodiGeforceNowPreviewAsset,
      ),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: AppConfig.spacingXLarge),
        const _Footer(),
        const SizedBox(height: AppConfig.spacingLarge),
        SizedBox(
          height: 56,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 280,
                height: 4,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.transparent,
                      Colors.black26,
                      Colors.transparent,
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ),
                ),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () async {
                  final contextToShow = _carouselKey.currentContext;
                  if (contextToShow != null) {
                    await Scrollable.ensureVisible(
                      contextToShow,
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: RepaintBoundary(
                    child: FadeTransition(
                      opacity: _arrowOpacity,
                      child: SlideTransition(
                        position: _arrowSlide,
                        child: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 30,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppConfig.spacingLarge),
        LayoutBuilder(
          key: _carouselKey,
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 800;
            if (isNarrow) {
              // Stack vertically on narrow screens
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: projects.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 720),
                      child: SizedBox(
                        height: 220,
                        child: _ProjectCard(
                          item: item,
                          onTap: () => launchUrlSafe(item.url),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            } else {
              // Display side by side on wide screens
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: projects.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        width: 400,
                        height: 220,
                        child: _ProjectCard(
                          item: item,
                          onTap: () => launchUrlSafe(item.url),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}

class _ProjectItem {
  final String title;
  final String url;
  final String? previewAsset; // asset path under `assets/`

  const _ProjectItem({
    required this.title,
    required this.url,
    this.previewAsset,
  });
}

class _ProjectCard extends StatelessWidget {
  final _ProjectItem item;
  final VoidCallback onTap;
  const _ProjectCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const double radius = 16;
    return Tooltip(
      message: item.title,
      waitDuration: const Duration(milliseconds: 200),
      child: Material(
        color: Colors.transparent,
        elevation: 2,
        borderRadius: BorderRadius.circular(radius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.white24,
          highlightColor: Colors.white10,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (item.previewAsset != null && item.previewAsset!.isNotEmpty)
                Image.asset(
                  item.previewAsset!,
                  fit: BoxFit.cover,
                  alignment: Alignment.centerLeft,
                  errorBuilder:
                      (context, error, stack) =>
                          Container(color: Colors.black12),
                )
              else
                Container(color: Colors.black12),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black26],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 24.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: onTap,
                    child: const Text(TextContent.viewProjectCta),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Animated Background with floating symbols
class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<FloatingSymbol> _symbols;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();

    // Initialize floating symbols
    _symbols = List.generate(20, (index) => _createSymbol());
  }

  FloatingSymbol _createSymbol() {
    const symbols = [
      '<>',
      '{}',
      '[]',
      '()',
      '//',
      '/*',
      '*/',
      '==',
      '!=',
      '++',
      '--',
      '=>',
      '&&',
      '||',
      '<<',
      '>>',
      'var',
      'new',
      'C#',
      '.NET',
      'if',
      'for',
      'try',
    ];
    return FloatingSymbol(
      symbol: symbols[_random.nextInt(symbols.length)],
      x: _random.nextDouble(),
      y: _random.nextDouble(),
      speed: 0.3 + _random.nextDouble() * 0.7, // 0.3 to 1.0
      size: 16.0 + _random.nextDouble() * 24.0, // 16 to 40
      opacity: 0.03 + _random.nextDouble() * 0.07, // 0.03 to 0.1
      rotation: _random.nextDouble() * 2 * math.pi,
      rotationSpeed: (_random.nextDouble() - 0.5) * 0.5,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: BackgroundPainter(
            symbols: _symbols,
            progress: _controller.value,
          ),
          child: Container(),
        );
      },
    );
  }
}

class FloatingSymbol {
  final String symbol;
  final double x;
  final double y;
  final double speed;
  final double size;
  final double opacity;
  final double rotation;
  final double rotationSpeed;

  FloatingSymbol({
    required this.symbol,
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.opacity,
    required this.rotation,
    required this.rotationSpeed,
  });
}

class BackgroundPainter extends CustomPainter {
  final List<FloatingSymbol> symbols;
  final double progress;

  BackgroundPainter({required this.symbols, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (var symbol in symbols) {
      // Calculate position with parallax effect
      final yOffset = (progress * symbol.speed) % 1.0;
      final currentY = ((symbol.y + yOffset) % 1.0) * size.height;
      final currentX = symbol.x * size.width;

      // Calculate rotation
      final currentRotation =
          symbol.rotation + (progress * symbol.rotationSpeed * 2 * math.pi);

      // Create text painter
      final textPainter = TextPainter(
        text: TextSpan(
          text: symbol.symbol,
          style: TextStyle(
            fontSize: symbol.size,
            color: Colors.black.withOpacity(symbol.opacity),
            fontWeight: FontWeight.w300,
            fontFamily: 'monospace',
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      // Save canvas state
      canvas.save();

      // Translate to position
      canvas.translate(currentX, currentY);

      // Rotate
      canvas.rotate(currentRotation);

      // Draw text centered
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );

      // Restore canvas state
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(BackgroundPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
