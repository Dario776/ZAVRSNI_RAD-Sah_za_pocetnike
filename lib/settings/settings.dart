import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zavrsni/styles.dart';
import 'package:zavrsni/settings/settings_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _showResetMessage = false;

  void _resetPreferences(SettingsProvider provider) async {
    await provider.ResetAllPrefs();

    setState(() => _showResetMessage = true);

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _showResetMessage = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final isDarkMode = settings.isDarkMode;

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
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SettingsToggleRow(
                    label: 'Zvuk',
                    isDarkMode: isDarkMode,
                    value: settings.isSound,
                    iconPath: 'volume',
                    onChanged: settings.toggleSound,
                  ),
                  const Divider(),
                  _SettingsToggleRow(
                    label: 'Tamni način',
                    isDarkMode: isDarkMode,
                    value: isDarkMode,
                    iconPath: 'dark-mode',
                    onChanged: settings.toggleTheme,
                  ),
                  const Divider(),
                  _SettingsToggleRow(
                    label: 'Font OpenDyslexic',
                    isDarkMode: isDarkMode,
                    value: settings.isOpenDyslexic,
                    iconPath: 'open-dyslexic',
                    onChanged: settings.toggleFontName,
                  ),
                  const Divider(),
                  _SettingsToggleRow(
                    label: 'Veliki font',
                    isDarkMode: isDarkMode,
                    value: settings.isBiggerFontSize,
                    iconPath: 'font-size',
                    onChanged: settings.toggleFontSize,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _resetPreferences(settings),
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

class _SettingsToggleRow extends StatelessWidget {
  final String label;
  final bool value;
  final bool isDarkMode;
  final String iconPath;
  final ValueChanged<bool> onChanged;

  const _SettingsToggleRow({
    required this.label,
    required this.value,
    required this.isDarkMode,
    required this.iconPath,
    required this.onChanged,
  });

  String get _iconAsset =>
      'assets/images/$iconPath${isDarkMode ? '-white' : ''}.png';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(_iconAsset, width: 24, height: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}
