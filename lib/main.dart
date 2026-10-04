import 'package:flutter/material.dart';

void main() {
  runApp(const SoundroomApp());
}

class SoundroomApp extends StatelessWidget {
  const SoundroomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soundroom',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F5F0),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE95F3C),
          brightness: Brightness.light,
          surface: const Color(0xFFF7F5F0),
        ),
        fontFamily: 'Roboto',
      ),
      home: const SoundroomShell(),
    );
  }
}

class Track {
  const Track({
    required this.title,
    required this.artist,
    required this.genre,
    required this.art,
    required this.duration,
    this.isAi = true,
    this.isLocal = true,
  });

  final String title;
  final String artist;
  final String genre;
  final Color art;
  final String duration;
  final bool isAi;
  final bool isLocal;
}

const tracks = <Track>[
  Track(title: 'After the Rain', artist: 'Mira Sol', genre: 'R&B · slow burn', art: Color(0xFF334C58), duration: '2:48'),
  Track(title: 'No Small Thing', artist: 'Juno Grey', genre: 'Pop · new release', art: Color(0xFFE9A356), duration: '3:12'),
  Track(title: 'Hold the Light', artist: 'Northside Eli', genre: 'Alt R&B · late night', art: Color(0xFF8D5966), duration: '2:57'),
  Track(title: 'Soft Landing', artist: 'Mira Sol', genre: 'Pop · local pick', art: Color(0xFF657354), duration: '3:04'),
];

class SoundroomShell extends StatefulWidget {
  const SoundroomShell({super.key});

  @override
  State<SoundroomShell> createState() => _SoundroomShellState();
}

class _SoundroomShellState extends State<SoundroomShell> {
  int _tab = 0;
  Track _current = tracks.first;
  bool _playing = false;

  void _play(Track track) {
    final sameTrack = _current.title == track.title && _current.artist == track.artist;
    setState(() {
      _current = track;
      _playing = sameTrack ? !_playing : true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomePage(onPlay: _play),
      SearchPage(onPlay: _play),
      const UploadPage(),
      LibraryPage(onPlay: _play),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: IndexedStack(index: _tab, children: pages)),
            if (_tab != 2) _MiniPlayer(track: _current, playing: _playing, onTap: () => setState(() => _playing = !_playing)),
            _BottomNav(index: _tab, onChanged: (value) => setState(() => _tab = value)),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.onPlay});
  final ValueChanged<Track> onPlay;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
      children: [
        const _TopBar(),
        const SizedBox(height: 28),
        const Text('LOCAL MUSIC  /  COMMUNITY PICKS', style: TextStyle(color: Color(0xFF77756F), fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.35)),
        const SizedBox(height: 7),
        const Text('Your community.\nIn rotation.', style: TextStyle(color: Color(0xFF171918), fontSize: 34, height: 1.08, fontWeight: FontWeight.w800, letterSpacing: -1.3)),
        const SizedBox(height: 20),
        _FeaturedCard(track: tracks.first, onTap: () => onPlay(tracks.first)),
        const SizedBox(height: 28),
        const _SectionHeader(title: 'Fresh from here', action: 'See all'),
        const SizedBox(height: 13),
        SizedBox(
          height: 163,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) => _ArtistTile(index: index),
          ),
        ),
        const SizedBox(height: 27),
        const _SectionHeader(title: 'Picked for your ears', action: 'All tracks'),
        const SizedBox(height: 7),
        ...tracks.map((track) => _TrackRow(track: track, onTap: () => onPlay(track))),
        const SizedBox(height: 18),
        const _SponsorSlot(),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(width: 34, height: 34, decoration: BoxDecoration(color: const Color(0xFFE95F3C), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.graphic_eq_rounded, color: Colors.white, size: 21)),
          const SizedBox(width: 9),
          const Text('soundroom', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, letterSpacing: -0.7)),
          const Spacer(),
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded), tooltip: 'Notifications'),
          const CircleAvatar(radius: 17, backgroundColor: Color(0xFFE8D6C8), child: Icon(Icons.person_outline_rounded, color: Color(0xFF503C32), size: 19)),
        ],
      );
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({required this.track, required this.onTap});
  final Track track;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Container(
        height: 218,
        decoration: BoxDecoration(color: track.art, borderRadius: BorderRadius.circular(24)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned(right: -18, top: -33, child: _RecordArtwork(color: const Color(0xFFDAA383), size: 200)),
            Positioned(left: 19, top: 17, child: _Pill(label: 'LOCAL SPOTLIGHT', color: Colors.white.withValues(alpha: .18), foreground: Colors.white)),
            Positioned(left: 20, bottom: 20, right: 18, child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('The feeling of\nstarting over.', style: TextStyle(color: Colors.white, fontSize: 23, height: 1.1, fontWeight: FontWeight.w800, letterSpacing: -.6)),
                const SizedBox(height: 8),
                Text('${track.title}  ·  ${track.artist}', style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
              ])),
              IconButton.filled(onPressed: onTap, style: IconButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF1B2426), fixedSize: const Size(50, 50)), icon: const Icon(Icons.play_arrow_rounded, size: 30)),
            ])),
          ],
        ),
      );
}

class _ArtistTile extends StatelessWidget {
  const _ArtistTile({required this.index});
  final int index;
  static const names = ['Mira Sol', 'Juno Grey', 'Northside Eli'];
  static const notes = ['Bedroom R&B', 'Bright pop', 'After-hours'];
  static const colors = [Color(0xFF9A5A58), Color(0xFF657354), Color(0xFF344F58)];

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 132,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: Container(width: 132, decoration: BoxDecoration(color: colors[index], borderRadius: BorderRadius.circular(18)), child: Stack(children: [
            Positioned(right: -17, bottom: -20, child: _RecordArtwork(color: Colors.white.withValues(alpha: .25), size: 110)),
            Positioned(left: 12, top: 12, child: Icon([Icons.nights_stay_rounded, Icons.wb_sunny_outlined, Icons.headphones_rounded][index], color: Colors.white, size: 24)),
          ]))),
          const SizedBox(height: 8),
          Text(names[index], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          Text(notes[index], style: const TextStyle(color: Color(0xFF77756F), fontSize: 11)),
        ]),
      );
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.action});
  final String title;
  final String action;
  @override
  Widget build(BuildContext context) => Row(children: [Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -.4)), const Spacer(), Text(action, style: const TextStyle(color: Color(0xFFAD4F35), fontSize: 12, fontWeight: FontWeight.w700))]);
}

class _TrackRow extends StatelessWidget {
  const _TrackRow({required this.track, required this.onTap});
  final Track track;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(children: [
          _RecordArtwork(color: track.art, size: 52),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(track.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)), const SizedBox(height: 3), Text('${track.artist}  ·  ${track.genre}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF77756F), fontSize: 11))])),
          if (track.isAi) const _Pill(label: 'AI', color: Color(0xFFEDE6DC), foreground: Color(0xFF665B50)),
          const SizedBox(width: 5),
          IconButton(onPressed: onTap, icon: const Icon(Icons.play_circle_outline_rounded, size: 27), tooltip: 'Play ${track.title}'),
        ]),
      );
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.onPlay});
  final ValueChanged<Track> onPlay;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String query = '';
  @override
  Widget build(BuildContext context) {
    final found = tracks.where((t) => '${t.title} ${t.artist} ${t.genre}'.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView(padding: const EdgeInsets.fromLTRB(20, 18, 20, 24), children: [
      const Text('Find your next\nfavourite.', style: TextStyle(fontSize: 31, fontWeight: FontWeight.w800, height: 1.1, letterSpacing: -1)),
      const SizedBox(height: 20),
      TextField(onChanged: (value) => setState(() => query = value), decoration: InputDecoration(hintText: 'Songs, artists, moods', prefixIcon: const Icon(Icons.search_rounded), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none))),
      const SizedBox(height: 24),
      _SectionHeader(title: query.isEmpty ? 'Popular nearby' : 'Search results', action: '${found.length} tracks'),
      const SizedBox(height: 10),
      if (found.isEmpty) const Padding(padding: EdgeInsets.symmetric(vertical: 36), child: Center(child: Text('No tracks found yet. Try another search.'))),
      ...found.map((track) => _TrackRow(track: track, onTap: () => widget.onPlay(track))),
    ]);
  }
}

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  bool aiMade = true;
  bool confirmsRights = false;
  final title = TextEditingController();
  final artist = TextEditingController();

  @override
  void dispose() {
    title.dispose();
    artist.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.fromLTRB(20, 18, 20, 30), children: [
        const Text('Put your sound\non the map.', style: TextStyle(fontSize: 31, fontWeight: FontWeight.w800, height: 1.08, letterSpacing: -1)),
        const SizedBox(height: 9),
        const Text('Share a track with listeners in your community.', style: TextStyle(color: Color(0xFF77756F), fontSize: 14)),
        const SizedBox(height: 22),
        Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: const Color(0xFFFFE9DF), borderRadius: BorderRadius.circular(22)), child: Column(children: [const Icon(Icons.audio_file_outlined, size: 35, color: Color(0xFFB65337)), const SizedBox(height: 8), const Text('Your audio file', style: TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 4), const Text('MP3 or WAV · up to 20 MB', style: TextStyle(color: Color(0xFF77756F), fontSize: 12)), const SizedBox(height: 12), OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.upload_file_rounded), label: const Text('Choose a track'))])),
        const SizedBox(height: 18),
        _InputField(controller: title, label: 'Track title', hint: 'Give your song a name'),
        const SizedBox(height: 12),
        _InputField(controller: artist, label: 'Artist name', hint: 'Your name or stage name'),
        const SizedBox(height: 16),
        const Text('Was AI used to make this track?', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        SwitchListTile(contentPadding: EdgeInsets.zero, title: Text(aiMade ? 'Yes, AI was part of the process' : 'No AI used'), value: aiMade, onChanged: (v) => setState(() => aiMade = v)),
        CheckboxListTile(contentPadding: EdgeInsets.zero, value: confirmsRights, onChanged: (v) => setState(() => confirmsRights = v ?? false), title: const Text('I have permission to upload and share this recording and its music.', style: TextStyle(fontSize: 13))),
        const SizedBox(height: 10),
        FilledButton(onPressed: confirmsRights ? () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Prototype only: a real submission would wait for review.'))) : null, style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52), backgroundColor: const Color(0xFFE95F3C)), child: const Text('Send for review')),
        const SizedBox(height: 9),
        const Text('Tracks are reviewed before they appear to listeners.', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF77756F), fontSize: 12)),
      ]);
}

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key, required this.onPlay});
  final ValueChanged<Track> onPlay;

  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.fromLTRB(20, 18, 20, 24), children: [
        const Text('Your library', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, letterSpacing: -1)),
        const SizedBox(height: 6),
        const Text('Saved music, ready when you are.', style: TextStyle(color: Color(0xFF77756F))),
        const SizedBox(height: 23),
        Container(padding: const EdgeInsets.all(17), decoration: BoxDecoration(color: const Color(0xFF1D3336), borderRadius: BorderRadius.circular(20)), child: const Row(children: [Icon(Icons.favorite_rounded, color: Color(0xFFFF9E76)), SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Liked tracks', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)), Text('Your personal collection', style: TextStyle(color: Colors.white70, fontSize: 12))])), Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 16)])),
        const SizedBox(height: 24),
        const _SectionHeader(title: 'Recently played', action: '4 tracks'),
        const SizedBox(height: 8),
        ...tracks.map((track) => _TrackRow(track: track, onTap: () => onPlay(track))),
      ]);
}

class _MiniPlayer extends StatelessWidget {
  const _MiniPlayer({required this.track, required this.playing, required this.onTap});
  final Track track;
  final bool playing;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Container(margin: const EdgeInsets.fromLTRB(12, 0, 12, 8), padding: const EdgeInsets.fromLTRB(10, 7, 9, 7), decoration: BoxDecoration(color: const Color(0xFF203538), borderRadius: BorderRadius.circular(16)), child: Row(children: [_RecordArtwork(color: track.art, size: 36), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(track.title, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)), Text(track.artist, style: const TextStyle(color: Colors.white70, fontSize: 10))])), IconButton(onPressed: onTap, icon: Icon(playing ? Icons.pause_rounded : Icons.play_arrow_rounded, color: Colors.white), tooltip: playing ? 'Pause' : 'Play')]));
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.index, required this.onChanged});
  final int index;
  final ValueChanged<int> onChanged;
  static const items = [
    (Icons.home_rounded, 'Home'),
    (Icons.search_rounded, 'Search'),
    (Icons.add_circle_outline_rounded, 'Upload'),
    (Icons.library_music_outlined, 'Library'),
  ];
  @override
  Widget build(BuildContext context) => NavigationBar(height: 67, selectedIndex: index, onDestinationSelected: onChanged, backgroundColor: const Color(0xFFF7F5F0), indicatorColor: const Color(0xFFFBE2D8), destinations: [for (final item in items) NavigationDestination(icon: Icon(item.$1), label: item.$2)]);
}

class _RecordArtwork extends StatelessWidget {
  const _RecordArtwork({required this.color, required this.size});
  final Color color;
  final double size;
  @override
  Widget build(BuildContext context) => Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, color: color, border: Border.all(color: Colors.white.withValues(alpha: .55), width: size > 90 ? 2 : 1)), child: Center(child: Container(width: size * .25, height: size * .25, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: .72)))));
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.color, required this.foreground});
  final String label;
  final Color color;
  final Color foreground;
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(30)), child: Text(label, style: TextStyle(color: foreground, fontSize: 9, letterSpacing: .8, fontWeight: FontWeight.w800)));
}

class _SponsorSlot extends StatelessWidget {
  const _SponsorSlot();
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFFEAE7DF), borderRadius: BorderRadius.circular(16)), child: const Row(children: [Icon(Icons.campaign_outlined, color: Color(0xFF6E6A61)), SizedBox(width: 10), Expanded(child: Text('Community sponsor space', style: TextStyle(color: Color(0xFF625F58), fontSize: 12, fontWeight: FontWeight.w600))), Text('SPONSORED', style: TextStyle(color: Color(0xFF77756F), fontSize: 8, letterSpacing: .8, fontWeight: FontWeight.w700))]));
}

class _InputField extends StatelessWidget {
  const _InputField({required this.controller, required this.label, required this.hint});
  final TextEditingController controller;
  final String label;
  final String hint;
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)), const SizedBox(height: 7), TextField(controller: controller, decoration: InputDecoration(hintText: hint, filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none)))]);
}
