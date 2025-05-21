import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zavrsni/styles.dart';
import 'package:zavrsni/settings_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  bool _showResetMessage = false;

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    bool isDarkMode = settingsProvider.isDarkMode;
    bool isOpenDyslexic = settingsProvider.isOpenDyslexic;
    bool isSound = settingsProvider.isSound;
    bool isBiggerFontSize = settingsProvider.isBiggerFontSize;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'POSTAVKE',
          style: Styles.customColorText(
            context,
            Styles.navBarTitle(context),
            false,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      isDarkMode
                          ? Image.asset(
                            'assets/images/volume-white.png',
                            width: 24,
                            height: 24,
                          )
                          : Image.asset(
                            'assets/images/volume.png',
                            width: 24,
                            height: 24,
                          ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Zvuk',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      Switch(
                        value: isSound,
                        onChanged: (bool value) {
                          settingsProvider.toggleSound(value);
                        },
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      isDarkMode
                          ? Image.asset(
                            'assets/images/dark-mode-white.png',
                            width: 24,
                            height: 24,
                          )
                          : Image.asset(
                            'assets/images/dark-mode.png',
                            width: 24,
                            height: 24,
                          ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Tamni način',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      Switch(
                        value: isDarkMode,
                        onChanged: (bool value) {
                          settingsProvider.toggleTheme(value);
                        },
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      isDarkMode
                          ? Image.asset(
                            'assets/images/open-dyslexic-white.png',
                            width: 24,
                            height: 24,
                          )
                          : Image.asset(
                            'assets/images/open-dyslexic.png',
                            width: 24,
                            height: 24,
                          ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Font OpenDyslexic',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      Switch(
                        value: isOpenDyslexic,
                        onChanged: (bool value) {
                          settingsProvider.toggleFontName(value);
                        },
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      isDarkMode
                          ? Image.asset(
                            'assets/images/font-size-white.png',
                            width: 24,
                            height: 24,
                          )
                          : Image.asset(
                            'assets/images/font-size.png',
                            width: 24,
                            height: 24,
                          ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Veliki font',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      Switch(
                        value: isBiggerFontSize,
                        onChanged: (bool value) {
                          settingsProvider.toggleFontSize(value);
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await settingsProvider.ResetAllPrefs();

                      setState(() {
                        _showResetMessage = true;
                      });

                      Future.delayed(const Duration(seconds: 2), () {
                        if (mounted) {
                          setState(() {
                            _showResetMessage = false;
                          });
                        }
                      });
                    },
                    child: Text(
                      'Resetiraj napredak i postavke',
                      style: Styles.customColorText(
                        context,
                        Styles.textDefault(context),
                        true,
                      ).copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (_showResetMessage)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Uspješno resetirano!',
                        textAlign: TextAlign.center,
                        style: Styles.customColorText(
                          context,
                          Styles.headerLarge(context),
                          false,
                        ).copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
