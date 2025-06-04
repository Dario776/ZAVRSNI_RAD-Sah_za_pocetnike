import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zavrsni/levels/levels.dart';
import 'package:zavrsni/settings/settings.dart';
import 'package:zavrsni/settings/settings_provider.dart';
import 'package:zavrsni/styles.dart';
import 'package:zavrsni/helper/helper.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "INFORMACIJE",
          style: Styles.customColorText(
            context,
            Styles.navBarTitle(context),
            false,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildSectionHeader(context, '"Šah za početnike"'),
                const SizedBox(height: 12),
                Text(
                  'Ova edukativna aplikacija pomaže korisnicima da nauče kretanje šahovskih figura.',
                  style: Styles.textDefault(context),
                ),
                const SizedBox(height: 24),
                buildSectionHeader(context, 'O aplikaciji'),
                const SizedBox(height: 12),
                Text(
                  'Aplikacija je razvijena u sklopu završnog rada na Fakultetu elektrotehnike i računarstva '
                  'Sveučilišta u Zagrebu, ak. god. 2024./2025.',
                  style: Styles.textDefault(context),
                ),
                const SizedBox(height: 24),
                buildSectionHeader(context, 'Implementacija'),
                const SizedBox(height: 12),
                Text('Dario Sučevac', style: Styles.textDefault(context)),
                const SizedBox(height: 24),
                buildSectionHeader(context, 'Mentorstvo'),
                const SizedBox(height: 12),
                Text(
                  'prof. dr. sc. Željka Car',
                  style: Styles.textDefault(context),
                ),
                const SizedBox(height: 24),
                buildSectionHeader(context, 'Atribucije'),
                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• Fontovi:', style: Styles.textDefault(context)),

                    Padding(
                      padding: const EdgeInsets.only(left: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          attributedLine(
                            context,
                            '- OpenSans: ',
                            '\nhttps://fonts.google.com/',
                          ),
                          attributedLine(
                            context,
                            '- OpenDyslexic: ',
                            '\nhttps://opendyslexic.org/',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text('• Slike:', style: Styles.textDefault(context)),

                    Padding(
                      padding: const EdgeInsets.only(left: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          attributedLine(
                            context,
                            '- Šahovske figure: ',
                            '\nhttps://greenchess.net/',
                          ),
                          attributedLine(
                            context,
                            '- Ikone u postavkama: ',
                            '\nhttps://www.flaticon.com/',
                          ),
                          attributedLine(
                            context,
                            '- Logo: ',
                            '\nhttps://www.freepik.com/',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text('• Zvukovi:', style: Styles.textDefault(context)),

                    Padding(
                      padding: const EdgeInsets.only(left: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          attributedLine(
                            context,
                            '- Kretnja figure - button 17.wav by bubaproducer: ',
                            '\nhttps://freesound.org/s/107135/',
                          ),
                          attributedLine(
                            context,
                            '- Nedozvoljen potez - Error by Kastenfrosch: ',
                            '\nhttps://freesound.org/s/521973/',
                          ),
                          attributedLine(
                            context,
                            '- Reset razine - tile shuffle.wav by element4rt: ',
                            '\nhttps://freesound.org/s/454848/',
                          ),
                          attributedLine(
                            context,
                            '- Sljedeća razina - magic_game_win_success.wav by MLaudio: ',
                            '\nhttps://freesound.org/s/615099/',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final appBarHeight = AppBar().preferredSize.height;

    return Scaffold(
      appBar: AppBar(
        leading: LayoutBuilder(
          builder: (context, constraints) {
            return IconButton(
              iconSize: constraints.maxWidth > 1000 ? 60 : 48,
              icon: const Icon(Icons.info),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InfoPage()),
                );
              },
            );
          },
        ),
        actions: [
          LayoutBuilder(
            builder: (context, constraints) {
              return IconButton(
                iconSize: constraints.maxWidth > 1000 ? 48 : 36,
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    (constraints.maxHeight - appBarHeight) < 100
                        ? 0
                        : constraints.maxHeight - appBarHeight,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 40),
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'ŠAH ZA\nPOČETNIKE',
                          textAlign: TextAlign.center,
                          style: Theme.of(
                            context,
                          ).textTheme.displayLarge?.copyWith(height: 1.5),
                        ),
                      ),
                      Image(
                        image:
                            settingsProvider.isDarkMode
                                ? const AssetImage(
                                  'assets/images/logo_white.png',
                                )
                                : const AssetImage(
                                  'assets/images/logo_black.png',
                                ),
                        fit: BoxFit.cover,
                        height: 200,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LevelSelectionPage(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 32.0,
                          ),
                          child: Text(
                            'KRENI!',
                            style: Styles.customColorText(
                              context,
                              Styles.textDefault(context).copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                              true,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
