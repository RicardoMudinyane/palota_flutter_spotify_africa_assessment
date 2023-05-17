import 'package:flutter/material.dart';
import 'package:flutter_spotify_africa_assessment/features/landing/presentation/animations/rive_assets.dart';
import 'package:flutter_spotify_africa_assessment/routes.dart';
import 'package:rive/rive.dart';

class LandingPage extends StatefulWidget {
  static const String _spotifyCategoryId = "afro";

  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late RiveAnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = OneShotAnimation(
      RiveAssets.palotaIntroAnimationName,
      onStop: () {
        Future.delayed(const Duration(seconds: 1)).then(
          (value) => _navigateToSpotifyCategoryPage(context),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RiveAnimation.asset(
        RiveAssets.palotaIntro,
        alignment: Alignment.center,
        fit: BoxFit.contain,
        controllers: [_controller],
      ),
    );
  }

  void _navigateToSpotifyCategoryPage(BuildContext context) {
    // replace because we don't want to navigate back to the landing screen
    Navigator.of(context).pushReplacementNamed(AppRoutes.spotifyCategory,
        arguments: LandingPage._spotifyCategoryId);
  }
}
