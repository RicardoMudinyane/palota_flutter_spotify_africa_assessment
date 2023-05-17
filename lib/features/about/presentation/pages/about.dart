import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spotify_africa_assessment/colors.dart';
import 'package:flutter_spotify_africa_assessment/features/about/presentation/components/animated_gradient_hero.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class AboutPage extends StatefulWidget {
  static const String _website = "https://palota.co.za";
  static const String _email = "jobs@palota.co.za";
  static const String _spotifyTerms =
      "https://www.spotify.com/us/legal/end-user-agreement/";

  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 60), vsync: this);
    animation = Tween<double>(begin: 0, end: 2 * pi).animate(controller);
    controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: MediaQuery.of(context).size.width * 0.75,
            flexibleSpace: FlexibleSpaceBar(
              background: AnimatedGradientHero(
                animation: animation,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(
              bottom: 16,
              left: 32,
              right: 32,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate.fixed([
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                  ),
                  child: Text(
                    'This is a simple Flutter project prepared by Palota to be used for assessment purposes.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.normal, color: Colors.white60),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.cyan,
                        ),
                        onPressed: () =>
                            _openUrl(Uri.parse(AboutPage._website)),
                        child: const Text("Open Website"),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => _launchEmail(),
                        child: const Text("E-Mail Us"),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Music playlist and category data in this assessment belongs to Spotify and is used under Spotify's terms and conditions",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      TextButton(
                        onPressed: () =>
                            _openUrl(Uri.parse(AboutPage._spotifyTerms)),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          "Spotify Terms and Conditions",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )
                    ],
                  ),
                ),
                _buildVersionText(context),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersionText(BuildContext context) {
    return FutureBuilder(
      future: PackageInfo.fromPlatform(),
      builder: (BuildContext ctx, AsyncSnapshot<PackageInfo> snapshot) {
        if (snapshot.hasData) {
          final PackageInfo packageInfo = snapshot.data as PackageInfo;
          return Text(
            "v${packageInfo.version} (${packageInfo.buildNumber})",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.bold, color: Colors.grey),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Future<bool> _openUrl(Uri url) async {
    if (await url_launcher.canLaunchUrl(url)) {
      return url_launcher.launchUrl(url);
    } else {
      return false;
    }
  }

  Future<bool> _launchEmail() async {
    Uri emailLink = Uri.parse("mailto:${AboutPage._email}");
    if (await url_launcher.canLaunchUrl(emailLink)) {
      return url_launcher.canLaunchUrl(emailLink);
    } else {
      return false;
    }
  }
}
