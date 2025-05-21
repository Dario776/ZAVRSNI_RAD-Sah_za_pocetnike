import 'package:flutter/material.dart';

class TextSection extends StatelessWidget {
  final String _body;
  static const double _hPad = 16.0;

  const TextSection(this._body, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(
            _hPad,
            _hPad / 2,
            _hPad,
            _hPad / 2,
          ),
          child: Text(_body, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}
