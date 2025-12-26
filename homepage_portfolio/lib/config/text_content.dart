import 'package:flutter/widgets.dart';

class TextContent {
  // Social Media Labels
  static const String githubLabel = 'GitHub';
  static const String linkedinLabel = 'LinkedIn';
  
  // Button Labels
  static const String sayHelloButton = 'Say Hello';
  
  // Footer Content
  static const String footerTagline = 'This page was proudly (and quickly) vibe-coded.';
  static const String sourceCodePrefix = 'You can check out the source code ';
  static const String sourceCodeLink = 'here';
  
  // Avatar Animation
  static const String avatarGreeting = 'Nice to see you! 👋';
  
  // Portfolio / Projects
  static const String tasksDoListName = 'Tasks-Do-List';
  static const TextSpan tasksDoListDescription = TextSpan(
    children: [
      TextSpan(style: TextStyle(fontWeight: FontWeight.w700), text: 'Chrome extension'),
      TextSpan(text: ' written in '),
      TextSpan(style: TextStyle(fontWeight: FontWeight.w700), text: 'TypeScript'),
      TextSpan(
        text:
            ', integrating Google Tasks API for a fast, lightweight to-do workflow.',
      ),
    ],
  );
  static const String kodiGeforceNowName = 'Kodi GeForce Now Addon';
  static const TextSpan kodiGeforceNowDescription = TextSpan(
    children: [
      TextSpan(style: TextStyle(fontWeight: FontWeight.w700), text: 'Kodi'),
      TextSpan(text: ' addon written in '),
      TextSpan(style: TextStyle(fontWeight: FontWeight.w700), text: 'Python'),
      TextSpan(text: ' for easily launching NVIDIA GeForce NOW.'),
    ],
  );
  static const String viewProjectCta = 'View Project';
} 