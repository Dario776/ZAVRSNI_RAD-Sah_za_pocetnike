import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zavrsni/components/piece.dart';
import 'package:zavrsni/game.dart';
import 'package:zavrsni/helper/helper.dart';
import 'package:zavrsni/levels/tile.dart';
import 'package:zavrsni/settings/settings.dart';
import 'package:zavrsni/settings_provider.dart';
import 'package:zavrsni/styles.dart';

class LevelSelectionPage extends StatelessWidget {
  const LevelSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ODABERI FIGURU',
          style: Styles.customColorText(
            context,
            Styles.navBarTitle(context),
            false,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
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
                buildSectionHeader(context, 'Dobrodošli'),
                const SizedBox(height: 12),
                Text(
                  'Dobrodošli u "Šah za početnike". Ova aplikacija je namijenjena početnicima koji žele naučiti pravila kretanja šahovskih figura.',
                  style: Styles.customColorText(
                    context,
                    Styles.textDefault(context),
                    false,
                  ),
                ),

                const SizedBox(height: 24),
                buildSectionHeader(context, 'Razine'),
                const SizedBox(height: 12),
                Text(
                  'Svaka figura ima svoje razine težina. One se kreću od najlakše do najteže. Izlaskom iz učenja figure, pamti se vaš napredak. Napredak se može resetirati u postavkama.',
                  style: Styles.customColorText(
                    context,
                    Styles.textDefault(context),
                    false,
                  ),
                ),

                const SizedBox(height: 24),
                buildSectionHeader(context, 'Početak'),
                const SizedBox(height: 12),
                Text(
                  'Za početak odaberite figuru koju želite naučiti kretati. Preporučeno je početi s pješakom, a zatim nastaviti s ostalim figurama. Prilikom učenja postoji na dnu gumb "Upute" ako vam je potrebna pomoć.',
                  style: Styles.customColorText(
                    context,
                    Styles.textDefault(context),
                    false,
                  ),
                ),

                const SizedBox(height: 24),
                GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    LessonTile(
                      title: 'Pješak',
                      lessonPage: Game(
                        boardObject: PawnBoard(ChessPieceType.pawn),
                        lessonTitle: 'Pješak',
                        lessonSubtitle: [
                          'Osnove',
                          'Promocija',
                          'En passant',
                          'U igri',
                        ],
                        lessonDescription: [
                          'Pješak je naizgled najjednostavnija figura u šahu, ali zapravo ima najviše pravila. Smije se kretati po samo JEDNO polje unaprijed, osim na svom prvom potezu kada se smije kretati JEDNO ili čak DVA polja unaprijed, ali samo ako su polja na koja se pomiče prazna. Pješak se može kretati i za JEDNO dijagonalno polje naprijed (ulijevo ili udesno) samo kada time uzima protivničku figuru. Ova pravila ćemo proći kroz razine, za one koje žele znati više postoje još 2 pravila.',
                          'Ako pješak dođe do zadnjeg polja ploče, tj. do reda najbližeg protivničkoj strani, mijenja se u bilo koju drugu figuru osim kralja i ta akcija naziva se "promocija pješaka".',
                          'Postoji i jedan poseban potez pješaka koji se naziva "en passant" što u prijevodu sa francuskog jezika znači "u prolazu" koji se može izvesti samo u određenim situacijama. Ako se pješak pomakne dva polja unaprijed i završi paralelno pored protivničkog pješaka, taj protivnički pješak može ga uzeti kao da je pomaknut samo jedno polje unaprijed.',
                          'Pješaci su najjači kada su u grupi, jer zajedno pokrivaju više polja i mogu se međusobno štititi. Iznimno su važni u završnicama igre, jer mogu postati jake figure kada se promoviranjem promijene u dame. Ima ih puno na ploči i najčešće su prve figure koje se pomiču u igri. Također su najčešće žrtvovane figure u igri, jer se često koriste za kontrolu centra i otvaranje prostora za druge figure.',
                        ],
                      ),
                      imagePath:
                          settingsProvider.isDarkMode
                              ? 'assets/images/black-pawn.png'
                              : 'assets/images/white-pawn.png',
                    ),
                    LessonTile(
                      title: 'Lovac',
                      lessonPage: Game(
                        boardObject: BishopBoard(ChessPieceType.bishop),
                        lessonTitle: 'Lovac',
                        lessonSubtitle: ['Dijagonale', 'U igri'],
                        lessonDescription: [
                          'Lovac je prilično lagana figura za naučiti. Smije se kretati koliko želi dijagonalno po ploči, ali samo po slobodnim poljima. Nailaskom na prvu protivničku figuru na bilo kojoj od 4 dijagonale, lovac ju može "pojesti". Kretanja samo po dijagonalama ploče znači da je ograničen na samo jednu boju polja. Ako je na bijelom polju, može se kretati samo po bijelim poljima i obrnuto.',
                          'Lovci su u šahu snažni kada su u paru, jer zajedno pokrivaju obje boje polja. Jaki su i kada je ploča otvorena, tj. kada je većina pješaka pomaknuta i nema prepreka između njih.',
                        ],
                      ),
                      imagePath:
                          settingsProvider.isDarkMode
                              ? 'assets/images/black-bishop.png'
                              : 'assets/images/white-bishop.png',
                    ),
                    LessonTile(
                      title: 'Skakač',
                      lessonPage: Game(
                        boardObject: KnightBoard(ChessPieceType.knight),
                        lessonTitle: 'Skakač',
                        lessonSubtitle: ['Skakanje', 'U igri'],
                        lessonDescription: [
                          'Skakač je jedinstvena šahovska figura, jer je jedina koja može preskakati druge figure. Sve ostale figure se kreću po slobodnim poljima, dok skakač može preskočiti sve figure koje se nalaze između njega i polja na koje se pomiče. Skakač se može kretati u obliku slova "L", tj. krećući se DVA polja u bilo kojem od 4 smjera te zatim na JEDNO polje ili ulijevo ili udesno.\n\nTo znači da ako se skakač nalazi u sredini ploče može skočiti na čak 8 različitih polja, a ako se nalazi u kutu može skočiti samo na 2 polja.',
                          'Skakač je najmoćniji kada je u sredini ploče, jer može pokriti više polja i imati više mogućnosti za napad. Vrlo je koristan u kombinaciji s drugim figurama, pogotovo kod napada protivničkog kralja s damom ili kod obrane vlastitog kralja. Voli zatvorene pozicije s puno pješaka, jer može lako preskočiti prepreke i doći do najoptimalnijih polja dok ostale figure ostaju u blokadi.',
                        ],
                      ),
                      imagePath:
                          settingsProvider.isDarkMode
                              ? 'assets/images/black-knight.png'
                              : 'assets/images/white-knight.png',
                    ),
                    LessonTile(
                      title: 'Top',
                      lessonPage: Game(
                        boardObject: RoyalBoard(ChessPieceType.rook),
                        lessonTitle: 'Top',
                        lessonSubtitle: ['Horizontalno i okomito', 'U igri'],
                        lessonDescription: [
                          'Top se može kretati u svim smjerovima osim po dijagonali. To znači da se može kretati lijevo, desno, naprijed i nazad koliko god želi, ali ne može skakati preko drugih figura. Ako naiđe na prvu protivničku figuru, može ju "pojesti" i zauzeti njeno polje. Mnogo je jači od lovca, jer se može kretati po cijeloj ploči i pokriva više polja. Također je jači od skakača, jer u prosjeku pokriva više polja i brže dolazi do željene pozicije.',
                          'Topovi su najjači kada su u otvorenim pozicijama, tj. kada su svi pješaci pomaknuti i nema prepreka između njih, slično kao i kod lovaca. Najbolji su kada su u paru jer se mogu međusobno štititi.',
                        ],
                      ),
                      imagePath:
                          settingsProvider.isDarkMode
                              ? 'assets/images/black-rook.png'
                              : 'assets/images/white-rook.png',
                    ),
                    LessonTile(
                      title: 'Kralj',
                      lessonPage: Game(
                        boardObject: RoyalBoard(ChessPieceType.king),
                        lessonTitle: 'Kralj',
                        lessonSubtitle: [
                          'Najvažnija figura',
                          'Rokada',
                          'U igri',
                        ],
                        lessonDescription: [
                          'Kralj je najvažnija figura u šahu, jer je cilj igre šaha matirati protivničkog kralja, tj. staviti ga u poziciju gdje je pod napadom i gdje protivnik niti jednim svojim mogućim potezom ne može spriječiti gubljenje svog kralja. Kralj se može kretati po samo JEDNO polje u bilo kojem smjeru, tj. lijevo, desno, naprijed, nazad i dijagonalno. Ne može se kretati na polje koje je pod napadom protivničke figure, jer bi time kralj upao u "šah", tj. mogućnost da ga protivnička figura pojede u sljedećem potezu. Ako naiđe na prvu protivničku figuru, može ju "pojesti" i zauzeti njeno polje. U okviru ovog učenja, jednostavnosti radi nećemo se baviti slučajevima kada je kralj u "šahu".',
                          'Kralj se može pomaknuti dva polja u jednom potezu samo ako se radi o posebnom potezu koji se zove "rokada" (rohada ili rošada). Rokada je potez koji se može izvesti samo kada su ispunjeni određeni uvjeti. Ako se figure kralja i topa koje sudjeluju u rokadi nisu nijednom pomakle tijekom igre i ako između njih nema drugih figura, kralj se pomiče dva polja prema topu, a top preskače kralja i stane do kralja s njegove druge strane s pretpostavkom da kralj nije u "šahu" i tijekom kretnje ne upadne u "šah". Postoji velika i mala rokada, velika se izvodi s topom dalje od kralja, a mala s onim bliže kralju. Ovaj potez se koristi za zaštitu kralja i aktivaciju topa.',
                          'Kralja je najbolje čuvati u sigurnoj poziciji, tj. iza svojih figura i daleko od protivničkih figura, najoptimalnije u rokadi. U završnicama igre, kralj postaje jedna od najbitnijih figura jer ne postoji više toliko opasnosti za njega, a od velike je pomoći za sigurnost i promociju pješaka.',
                        ],
                      ),
                      imagePath:
                          settingsProvider.isDarkMode
                              ? 'assets/images/black-king.png'
                              : 'assets/images/white-king.png',
                    ),
                    LessonTile(
                      title: 'Dama',
                      lessonPage: Game(
                        boardObject: RoyalBoard(ChessPieceType.queen),
                        lessonTitle: 'Dama',
                        lessonSubtitle: ['Kraljica igre', 'U igri'],
                        lessonDescription: [
                          'Dama je najjača figura u šahu, jer se može kretati u svim smjerovima i po cijeloj ploči. To znači da se može kretati lijevo, desno, naprijed, nazad i dijagonalno koliko god želi, ali ne može skakati preko drugih figura. Ako naiđe na prvu protivničku figuru, može ju "pojesti" i zauzeti njeno polje. Pokriva više polja od svih ostalih figura i može napasti više figura odjednom, što je čini iznimno moćnom i vrijednom štićenja.',
                          'Dame su snažne izdaleka ili iza protivničkih figura, gdje mogu nanijeti veliku štetu. Često se u napadima na kralja postavljaju na dijagonalama ili u ravnini s protivničkim kraljem, jer u kombinaciji s drugim figurama mogu stvoriti snažne napade. Dame su također korisne u završnicama igre kada je ploča otvorena, jer mogu lako napasti protivničke figure i pomoći u promociji pješaka.',
                        ],
                      ),
                      imagePath:
                          settingsProvider.isDarkMode
                              ? 'assets/images/black-queen.png'
                              : 'assets/images/white-queen.png',
                    ),
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
