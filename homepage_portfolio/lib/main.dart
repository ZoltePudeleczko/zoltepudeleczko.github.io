import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('darkMode') ?? false;
  runApp(PortfolioApp(initialDarkMode: isDarkMode));
}

class PortfolioApp extends StatefulWidget {
  final bool initialDarkMode;

  const PortfolioApp({super.key, required this.initialDarkMode});

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.initialDarkMode;
  }

  Future<void> _toggleDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    await prefs.setBool('darkMode', _isDarkMode);
  }

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
          headlineLarge: AppTextStyles.headlineLarge(false),
          titleMedium: AppTextStyles.titleMedium(false),
          bodyMedium: AppTextStyles.bodyMedium(false),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: Colors.white,
          secondary: Colors.blueAccent,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        textTheme: TextTheme(
          headlineLarge: AppTextStyles.headlineLarge(true),
          titleMedium: AppTextStyles.titleMedium(true),
          bodyMedium: AppTextStyles.bodyMedium(true),
        ),
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: PortfolioHomePage(
        onToggleDarkMode: _toggleDarkMode,
        isDarkMode: _isDarkMode,
      ),
    );
  }
}

class PortfolioHomePage extends StatelessWidget {
  final Future<void> Function() onToggleDarkMode;
  final bool isDarkMode;

  const PortfolioHomePage({
    super.key,
    required this.onToggleDarkMode,
    required this.isDarkMode,
  });

  Widget _buildSocialButton(
      IconData icon, String tooltip, String url, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return IconButton(
      icon: FaIcon(icon),
      tooltip: tooltip,
      color: isDark ? Colors.white70 : Colors.black87,
      onPressed: () => launchUrlSafe(url),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBackground(isDarkMode: isDark),
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
                            context,
                          ),
                          _buildSocialButton(
                            FontAwesomeIcons.linkedin,
                            TextContent.linkedinLabel,
                            AppConfig.linkedinUrl,
                            context,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConfig.spacingXLarge),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? Colors.white : Colors.black,
                          foregroundColor: isDark ? Colors.black : Colors.white,
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
                        icon: Icon(
                          Icons.mail_outline,
                          color: isDark ? Colors.black : Colors.white,
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
          Positioned(
            top: 16,
            right: 16,
            child: _DarkModeToggle(
              isDarkMode: isDarkMode,
              onToggle: onToggleDarkMode,
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

class _DarkModeToggle extends StatelessWidget {
  final bool isDarkMode;
  final Future<void> Function() onToggle;

  const _DarkModeToggle({
    required this.isDarkMode,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withValues(alpha: 0.2)
              : Colors.black.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              Icons.light_mode,
              color: !isDarkMode
                  ? Colors.orange
                  : Theme.of(context).iconTheme.color?.withValues(alpha: 0.5),
            ),
            onPressed: !isDarkMode ? null : () => onToggle(),
            tooltip: 'Light mode',
          ),
          Switch(
            value: isDarkMode,
            onChanged: (_) => onToggle(),
          ),
          IconButton(
            icon: Icon(
              Icons.dark_mode,
              color: isDarkMode
                  ? Colors.blueAccent
                  : Theme.of(context).iconTheme.color?.withValues(alpha: 0.5),
            ),
            onPressed: isDarkMode ? null : () => onToggle(),
            tooltip: 'Dark mode',
          ),
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          TextContent.footerTagline,
          style: AppTextStyles.footerBodyText(isDark),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppConfig.spacingTiny),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              TextContent.sourceCodePrefix,
              style: AppTextStyles.footerBodyText(isDark),
            ),
            _buildLink(TextContent.sourceCodeLink, AppConfig.repoUrl, isDark),
          ],
        ),
      ],
    );
  }

  Widget _buildLink(String text, String url, bool isDark) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => launchUrlSafe(url),
        child: Text(text, style: AppTextStyles.footerText(isDark)),
      ),
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

    final isDark = Theme.of(context).brightness == Brightness.dark;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(TextContent.avatarGreeting),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? Colors.white24 : Colors.black87,
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
        description: TextContent.tasksDoListDescription,
        url: AppConfig.tasksDoListUrl,
        previewAsset: AppConfig.tasksDoListPreviewAsset,
      ),
      _ProjectItem(
        title: TextContent.kodiGeforceNowName,
        description: TextContent.kodiGeforceNowDescription,
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
              Builder(
                builder: (context) {
                  final isDark = Theme.of(context).brightness == Brightness.dark;
                  return Container(
                    width: 280,
                    height: 4,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.transparent,
                          isDark ? Colors.white24 : Colors.black26,
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  );
                },
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
                        child: Builder(
                          builder: (context) {
                            final isDark = Theme.of(context).brightness == Brightness.dark;
                            return Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 30,
                              color: isDark ? Colors.white38 : Colors.black45,
                            );
                          },
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
                      child: _ProjectCard(
                        item: item,
                        onTap: () => launchUrlSafe(item.url),
                        alwaysShowDescription: true,
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
                        child: _ProjectCard(
                          item: item,
                          onTap: () => launchUrlSafe(item.url),
                          alwaysShowDescription: false,
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
  final InlineSpan description;
  final String url;
  final String? previewAsset; // asset path under `assets/`

  const _ProjectItem({
    required this.title,
    required this.description,
    required this.url,
    this.previewAsset,
  });
}

class _ProjectCard extends StatefulWidget {
  final _ProjectItem item;
  final VoidCallback onTap;
  final bool alwaysShowDescription;
  const _ProjectCard({
    required this.item,
    required this.onTap,
    required this.alwaysShowDescription,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const double radius = 16;
    final showCaption = widget.alwaysShowDescription || _isHovered;
    const double imageHeight = 220;
    const double descriptionGap = 12;
    final highlightButton = !widget.alwaysShowDescription && _isHovered;

    Widget buildCaption() {
      final bg = Theme.of(context).scaffoldBackgroundColor.withValues(
        alpha: isDark ? 0.85 : 0.92,
      );
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: DefaultTextStyle(
          style: TextStyle(
            fontSize: 13,
            height: 1.2,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.15,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text.rich(
                widget.item.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
    }

    return MouseRegion(
      opaque: true,
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        if (widget.alwaysShowDescription) return;
        setState(() => _isHovered = true);
      },
      onHover: (_) {
        if (widget.alwaysShowDescription) return;
        if (_isHovered) return;
        setState(() => _isHovered = true);
      },
      onExit: (_) {
        if (widget.alwaysShowDescription) return;
        setState(() => _isHovered = false);
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: imageHeight,
              child: Material(
                color: Colors.transparent,
                elevation: 2,
                borderRadius: BorderRadius.circular(radius),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (widget.item.previewAsset != null &&
                        widget.item.previewAsset!.isNotEmpty)
                      Image.asset(
                        widget.item.previewAsset!,
                        fit: BoxFit.cover,
                        alignment: Alignment.centerLeft,
                        errorBuilder: (context, error, stack) => Container(
                          color: isDark ? Colors.white12 : Colors.black12,
                        ),
                      )
                    else
                      Container(
                        color: isDark ? Colors.white12 : Colors.black12,
                      ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            isDark ? Colors.black54 : Colors.black26,
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 24.0),
                        child: IgnorePointer(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 140),
                            curve: Curves.easeOut,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: highlightButton
                                  ? (isDark
                                      ? Colors.white.withValues(alpha: 0.92)
                                      : Colors.black.withValues(alpha: 0.85))
                                  : (isDark ? Colors.white : Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              TextContent.viewProjectCta,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.black : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: descriptionGap),
            AnimatedOpacity(
              opacity: showCaption ? 1 : 0,
              duration: const Duration(milliseconds: 140),
              curve: Curves.easeOut,
              child: IgnorePointer(
                ignoring: !showCaption,
                child: buildCaption(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Animated Background with floating symbols
class AnimatedBackground extends StatefulWidget {
  final bool isDarkMode;

  const AnimatedBackground({super.key, required this.isDarkMode});

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
            isDarkMode: widget.isDarkMode,
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
  final bool isDarkMode;

  BackgroundPainter({
    required this.symbols,
    required this.progress,
    required this.isDarkMode,
  });

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
            color: isDarkMode
                ? Colors.white.withValues(alpha: symbol.opacity)
                : Colors.black.withValues(alpha: symbol.opacity),
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
    return oldDelegate.progress != progress ||
        oldDelegate.isDarkMode != isDarkMode;
  }
}

