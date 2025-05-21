import 'package:flutter/material.dart';
import 'package:zavrsni/helper/helper.dart';
import 'package:zavrsni/settings/settings.dart';
import 'package:zavrsni/styles.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "UPUTE",
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
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildSectionHeader(context, 'Početak'),
                const SizedBox(height: 12),
                Text(
                  'Za početak kliknite na bijelu šahovsku figuru. Kada je figura odabrana na ploči će se žutim kružićima prikazati sva moguća prazna polja na koje se figura može pomaknuti. Klikom na moguću sljedeću poziciju pomičemo figuru i tu akciju nazivemo "potez". Nema ograničenja u broju poteza. Ako je mogući potez označen crvenom bojom, to znači da je polje zauzeto crnom figurom i da ju možemo "pojesti", tj. zauzeti njeno polje i ukloniti ju s ploče. Igrač može micati samo bijelu figuru.',
                  style: Styles.textDefault(context),
                ),
                const SizedBox(height: 24),
                buildSectionHeader(context, 'Cilj'),
                const SizedBox(height: 12),
                Text(
                  'Cilj je pomaknuti figuru na trenutno ciljno polje. Trenutno ciljno polje označeno je tamnoplavom bojom i rednim brojem 1, dok su buduća ciljna polja označena svijetloplavom bojom i odgovarajućim rednim brojem. Dolaskom bijele figure na tamnoplavo ciljno polje 1, automatski se ažurira sljedeće ciljno polje. Razina je završena kada su obiđena sva ciljna polja.\n\nTrenutno ciljno polje također je označeno šahovskim koordinatama (npr. "e4"). Koordinate su označene na rubovima šahovske ploče, a označavaju redak i stupac u kojem se cilj nalazi. Redak je označen brojem, a stupac slovom. Brojevi kreću od 1 do 8, a slova od a do h.',
                  style: Styles.textDefault(context),
                ),
                const SizedBox(height: 24),
                buildSectionHeader(context, 'Gumbi'),
                const SizedBox(height: 12),
                Text(
                  'Na raspolaganju se nalaze pomoćni gumbi "Resetiraj" i "Preskoči". Gumb "Resetiraj" iznova kreira trenutnu razinu i vraća figure na početne pozicije, koristan je ako nemamo više dostupnih poteza za učiniti. Gumb "Preskoči" u potpunosti preskače razinu i kreira sljedeću, koristan je ako zapnemo na razini.',
                  style: Styles.textDefault(context),
                ),
                const SizedBox(height: 24),
                buildSectionHeader(context, 'Postavke'),
                const SizedBox(height: 12),
                Text(
                  'U postavkama možete odabrati veličinu fonta, tamnu ili svijetlu temu, uključiti ili isključiti zvuk ili odabrati font "OpenDyslexic" koji je prilagođen osobama s disleksijom. Postoji i gumb "Resetiraj napredak i postavke" koji vraća sve razine figura na 1 i sve postavke na zadane vrijednosti.',
                  style: Styles.textDefault(context),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
