import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'config/app_config.dart';
import 'config/text_content.dart';
import 'config/text_styles.dart';

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
                  const AnimatedAvatar(),
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
                      _buildSocialButton(FontAwesomeIcons.github, TextContent.githubLabel, AppConfig.githubUrl),
                      _buildSocialButton(FontAwesomeIcons.linkedin, TextContent.linkedinLabel, AppConfig.linkedinUrl),
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
                      textStyle: AppTextStyles.buttonText,
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.mail_outline, color: Colors.white),
                    label: const Text(TextContent.sayHelloButton),
                    onPressed: () => _launchUrl(AppConfig.emailUrl),
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
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        child: Text(
          text,
          style: AppTextStyles.footerText,
        ),
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
            Text(TextContent.sourceCodePrefix, style: AppTextStyles.footerBodyText),
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
      duration: const Duration(milliseconds: AppConfig.avatarRotationDurationMs),
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
            angle: _rotationAnimation.value * 2 * 3.14159,
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
  late final PageController _pageController;
  late final AnimationController _arrowController;
  late final Animation<Offset> _arrowSlide;
  late final Animation<double> _arrowOpacity;
  final GlobalKey _carouselKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9, keepPage: true);
    _arrowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    final curve = CurvedAnimation(parent: _arrowController, curve: Curves.easeInOut);
    _arrowSlide = Tween<Offset>(begin: const Offset(0, -0.15), end: const Offset(0, 0.15)).animate(curve);
    _arrowOpacity = Tween<double>(begin: 0.6, end: 1.0).animate(curve);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _arrowController.dispose();
    super.dispose();
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final projects = <_ProjectItem>[
      _ProjectItem(
        title: TextContent.tasksDoListName,
        url: AppConfig.tasksDoListUrl,
        previewAsset: AppConfig.tasksDoListPreviewAsset,
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
        SizedBox(
          height: 220,
          key: _carouselKey,
          child: PageView.builder(
            controller: _pageController,
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final item = projects[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: _ProjectCard(
                      item: item,
                      onTap: () => _openUrl(item.url),
                    ),
                  ),
                ),
              );
            },
          ),
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
  const _ProjectCard({
    required this.item,
    required this.onTap,
  });

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
                  errorBuilder: (context, error, stack) => Container(color: Colors.black12),
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
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
