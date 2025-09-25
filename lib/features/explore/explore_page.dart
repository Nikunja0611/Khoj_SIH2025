import 'package:flutter/material.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> with TickerProviderStateMixin {
  late AnimationController _ctrl;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(duration: Duration(milliseconds: 300), vsync: this);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() => setState(() {
    _open = !_open;
    _open ? _ctrl.forward() : _ctrl.reverse();
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1544735716-392fe2489ffa?w=800'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: _toggle,
                        child: AnimatedBuilder(
                          animation: _ctrl,
                          builder: (c, ch) => Transform.rotate(
                            angle: _ctrl.value * 0.5,
                            child: Icon(Icons.menu, color: Colors.white, size: 28),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Explore\nJharkhand', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white, height: 1.1)),
                        SizedBox(height: 12),
                        Text('Discover the culture of a land steeped in history', style: TextStyle(fontSize: 16, color: Colors.white70)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(30)),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search destinations...',
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                          suffixIcon: Icon(Icons.mic, color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF5E6D3),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                      ),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _title('Popular Destinations'),
                            SizedBox(height: 12),
                            TouristPlacesGrid(),
                            SizedBox(height: 24),
                            _title('Featured'),
                            SizedBox(height: 12),
                            FeaturedGrid(),
                            SizedBox(height: 24),
                            _title('Tourist Reviews'),
                            SizedBox(height: 12),
                            TouristReviewsSection(),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _ctrl,
            builder: (c, ch) => Transform.translate(
              offset: Offset((_ctrl.value - 1) * MediaQuery.of(context).size.width * 0.75, 0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.75,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(color: Color(0xFFF5E6D3), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: Offset(5, 0))]),
                child: SafeArea(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(onTap: _toggle, child: Padding(padding: EdgeInsets.all(16), child: Icon(Icons.close, size: 28))),
                      ),
                      ...[
                        [Icons.explore, 'Explore', true],
                        [Icons.shopping_bag, 'Marketplace', false],
                        [Icons.groups, 'Community', false],
                        [Icons.psychology, 'AI Saathi', false],
                        [Icons.person, 'Profile', false],
                      ].map((e) => _item(e[0] as IconData, e[1] as String, e[2] as bool)).toList(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_open) GestureDetector(onTap: _toggle, child: Container(color: Colors.black.withOpacity(0.5))),
        ],
      ),
    );
  }

  Widget _title(String t) => Text(t, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87));

  Widget _item(IconData i, String t, bool s) => Container(
    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    decoration: BoxDecoration(color: s ? Colors.brown.withOpacity(0.3) : Colors.transparent, borderRadius: BorderRadius.circular(12)),
    child: ListTile(
      leading: Icon(i, color: s ? Colors.brown : Colors.black54),
      title: Text(t, style: TextStyle(fontWeight: s ? FontWeight.bold : FontWeight.normal, color: s ? Colors.brown : Colors.black87)),
      onTap: () {},
    ),
  );
}

class FeaturedGrid extends StatelessWidget {
  final data = [
    [Icons.calendar_today, 'Itinerary Planner', 'Plan your trip', Color(0xFF6366F1), 'itinerary'],
    [Icons.shopping_bag, 'Marketplace', 'Shop local', Color(0xFF10B981), 'marketplace'],
    [Icons.psychology, 'AI Saathi', 'Smart assistant', Color(0xFF8B5CF6), 'itinerary'],
    [Icons.view_in_ar, 'AR Experiences', 'Immersive tours', Color(0xFFF59E0B), 'ar'],
  ];

  @override
  Widget build(BuildContext context) => GridView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 1.1),
    itemCount: data.length,
    itemBuilder: (c, i) {
      final d = data[i];
      return GestureDetector(
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Navigate to ${d[4]}'), duration: Duration(seconds: 1))),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [d[3] as Color, (d[3] as Color).withOpacity(0.7)]),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: (d[3] as Color).withOpacity(0.4), blurRadius: 12, offset: Offset(0, 6))],
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                  child: Icon(d[0] as IconData, color: Colors.white, size: 32),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(d[1] as String, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 4),
                    Text(d[2] as String, style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class TouristReviewsSection extends StatelessWidget {
  final reviews = [
    ['Amit Kumar', 'Amazing waterfalls and serene environment. Hundru Falls is a must visit for nature lovers!', 'Hundru Falls', 'A'],
    ['Sneha Patel', 'Spiritual vibes and beautiful temple architecture. Deoghar exceeded my expectations.', 'Deoghar', 'S'],
    ['Raj Malhotra', 'The sunrise at Netarhat is absolutely breathtaking! Worth the early morning wake up.', 'Netarhat', 'R'],
  ];

  @override
  Widget build(BuildContext context) => Column(
    children: [
      SizedBox(
        height: 160,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: reviews.length,
          itemBuilder: (c, i) {
            final r = reviews[i];
            return Container(
              width: 300,
              margin: EdgeInsets.only(right: 12),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: Offset(0, 4))]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(radius: 20, backgroundColor: Colors.brown.shade400, child: Text(r[3], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r[0], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            Text(r[2], style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                      Row(children: List.generate(5, (i) => Icon(Icons.star, size: 14, color: Colors.amber.shade600))),
                    ],
                  ),
                  SizedBox(height: 12),
                  Expanded(child: Text(r[1], style: TextStyle(fontSize: 13, color: Colors.black87, height: 1.4), maxLines: 3, overflow: TextOverflow.ellipsis)),
                ],
              ),
            );
          },
        ),
      ),
      SizedBox(height: 12),
      GestureDetector(
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Navigating to Community page...'), duration: Duration(seconds: 1))),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          decoration: BoxDecoration(color: Colors.brown.shade400, borderRadius: BorderRadius.circular(25), boxShadow: [BoxShadow(color: Colors.brown.shade400.withOpacity(0.3), blurRadius: 8, offset: Offset(0, 4))]),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('View More Reviews', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward, color: Colors.white, size: 18),
            ],
          ),
        ),
      ),
    ],
  );
}

class TouristPlacesGrid extends StatelessWidget {
  final places = [
    ['Netarhat', 'Known as the "Queen of Chotanagpur," famous for panoramic sunrise and sunset views, lush green hills, and serene environment.', 'October to March', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400'],
    ['Hundru Falls', 'A spectacular 98-meter waterfall on the Subarnarekha River, surrounded by rocky terrain and forested hills.', 'July to October', 'https://images.unsplash.com/photo-1439066615861-d1af74d74000?w=400'],
    ['Deoghar', 'Famous for the Baidyanath Jyotirlinga temple, a spiritual and cultural hub with scenic ghats and local markets.', 'October to March', 'https://images.unsplash.com/photo-1582510003544-4d00b7f74220?w=400'],
    ['Patratu Valley', 'Offers breathtaking views, winding roads, and a reservoir. Popular for road trips and nature photography.', 'September to February', 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400'],
  ];

  @override
  Widget build(BuildContext context) => GridView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.0),
    itemCount: places.length,
    itemBuilder: (c, i) {
      final p = places[i];
      return GestureDetector(
        onTap: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (c) => PlaceDetailSheet(name: p[0], desc: p[1], time: p[2], img: p[3]),
        ),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: Offset(0, 4))]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Image.network(p[3], fit: BoxFit.cover, width: double.infinity, height: double.infinity,
                  loadingBuilder: (c, ch, p) => p == null ? ch : Container(color: Colors.grey.shade300, child: Center(child: CircularProgressIndicator())),
                  errorBuilder: (c, e, s) => Container(color: Colors.grey.shade300, child: Icon(Icons.image, size: 50, color: Colors.grey)),
                ),
                Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.7)]))),
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(p[0], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class PlaceDetailSheet extends StatelessWidget {
  final String name, desc, time, img;
  const PlaceDetailSheet({required this.name, required this.desc, required this.time, required this.img});

  @override
  Widget build(BuildContext context) => DraggableScrollableSheet(
    initialChildSize: 0.7,
    minChildSize: 0.5,
    maxChildSize: 0.9,
    builder: (c, sc) => Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
      child: SingleChildScrollView(
        controller: sc,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12),
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(img, height: 200, width: double.infinity, fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(height: 200, color: Colors.grey.shade300, child: Icon(Icons.image, size: 60, color: Colors.grey)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(name, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                      Row(children: List.generate(5, (i) => Icon(Icons.star, color: Colors.amber, size: 20))),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(desc, style: TextStyle(fontSize: 15, height: 1.5, color: Colors.black87)),
                  SizedBox(height: 16),
                  Text('Best Time to Visit', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.brown, size: 18),
                      SizedBox(width: 8),
                      Text(time, style: TextStyle(fontSize: 15, color: Colors.black87)),
                    ],
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('3D Preview Coming Soon!'), duration: Duration(seconds: 1))),
                          icon: Icon(Icons.view_in_ar),
                          label: Text('3D Preview'),
                          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF8B5CF6), foregroundColor: Colors.white, padding: EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added to Itinerary!'), duration: Duration(seconds: 1))),
                          icon: Icon(Icons.add),
                          label: Text('Add to Trip'),
                          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF6366F1), foregroundColor: Colors.white, padding: EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}