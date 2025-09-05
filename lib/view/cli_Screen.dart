import 'package:flutter/material.dart';

/// Drop this widget anywhere. It renders inside a Container (no Scaffold).
class ResponsivePassengerScreen extends StatelessWidget {
  const ResponsivePassengerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF7F9FC),
      padding: const EdgeInsets.all(16),
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: LayoutBuilder(
          builder: (context, c) {
            final w = c.maxWidth;

            // Breakpoints
            final isDesktop = w >= 1200;
            final isTablet = w >= 820 && w < 1200;
            final isMobile = w < 820;

            final leftWidth  = isDesktop ? 280.0 : (isTablet ? 260.0 : 220.0);
            final rightWidth = isDesktop ? 360.0 : (isTablet ? 320.0 : 300.0);

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [BoxShadow(blurRadius: 20, color: Color(0x14000000))],
              ),
              clipBehavior: Clip.antiAlias,
              child: isMobile
                  ? _MobileLayout(leftWidth: leftWidth, rightWidth: rightWidth)
                  : _WideLayout(leftWidth: leftWidth, rightWidth: rightWidth),
            );
          },
        ),
      ),
    );
  }
}

/// --------- Wide (Web/Tablet landscape) ----------
class _WideLayout extends StatelessWidget {
  const _WideLayout({required this.leftWidth, required this.rightWidth});

  final double leftWidth;
  final double rightWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // LEFT SIDEBAR
        SizedBox(width: leftWidth, child: _LeftSidebar()),
        // CENTER
        Expanded(child: _CenterArea()),
        // VERTICAL DIVIDER
        Container(width: 2, color: const Color(0xFFE1E7F0)),
        // RIGHT SIDEBAR
        SizedBox(width: rightWidth, child: _RightSidebar()),
      ],
    );
  }
}

/// --------- Mobile (Stacked) ----------
class _MobileLayout extends StatelessWidget {
  const _MobileLayout({required this.leftWidth, required this.rightWidth});

  final double leftWidth;
  final double rightWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(width: double.infinity, child: _LeftSidebar()),
        const Divider(height: 2, thickness: 2, color: Color(0xFFE1E7F0)),
        _CenterArea(),
        const Divider(height: 2, thickness: 2, color: Color(0xFFE1E7F0)),
        SizedBox(width: double.infinity, child: _RightSidebar()),
      ],
    );
  }
}

/// --------- LEFT SIDEBAR ----------
class _LeftSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF5C7EA6), // slate-blue similar to screenshot
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top brand row
          Row(
            children: [
              const Icon(Icons.local_taxi, color: Colors.yellow, size: 28),
              const SizedBox(width: 8),
              Text(
                "SEA CARZ",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
              const Spacer(),
              const Icon(Icons.close, color: Colors.white70),
            ],
          ),
          const SizedBox(height: 28),

          // Profile Card
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF6C8CB0),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 36, color: Color(0xFF5C7EA6)),
                ),
                const SizedBox(height: 12),
                Text(
                  "Mr Mareevan",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  "04:08 PM",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.white70, letterSpacing: .2),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Table headers for recent rides (left column labels)
          Row(
            children: [
              Text("Date / Time",
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 12),

          // Tiny preview thumb (placeholder)
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Container(
              height: 26,
              width: 26,
              color: Colors.white24,
              child: const Icon(Icons.image, size: 18, color: Colors.white70),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

/// --------- CENTER AREA ----------
/// --------- CENTER AREA ----------
class _CenterArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final subtle = const Color(0xFF6B7C8F);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header Title
          Text(
            "Passenger",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: subtle,
              fontWeight: FontWeight.w700,
              letterSpacing: .2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "07795116925",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          // Status
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Status: ",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.black54)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9F5FF),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFF94C8FF)),
                ),
                child: const Text(
                  "In Use",
                  style: TextStyle(
                    color: Color(0xFF2376D9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Search
          SizedBox(
            height: 44,
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                filled: true,
                fillColor: const Color(0xFFF2F5F9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),

          // Recent Rides header row
          Row(
            children: [
              Text(
                "Recent Rides",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: subtle, fontWeight: FontWeight.w700),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Table header
          Container(
            height: 34,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAFE),
              border: Border.all(color: const Color(0xFFE3E9F2)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                _th("Destination", flex: 3),
                _th("Pick-up", flex: 2),
                _th("Via", flex: 2),
                _th("Fares", flex: 1),
                _th("Action", flex: 2, alignEnd: true),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Ride list
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE3E9F2)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: 5, // 👈 yahan aap apna data count dal sakte ho
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  return Row(
                    children: [
                      Expanded(flex: 3, child: Text("London City $i")),
                      Expanded(flex: 2, child: Text("Pickup $i")),
                      Expanded(flex: 2, child: Text("Via Point $i")),
                      Expanded(flex: 1, child: Text("£${10 + i}")),
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                // TODO: edit callback
                              },
                              child: const Text("Edit"),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                // TODO: select callback
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                textStyle: const TextStyle(fontSize: 13),
                              ),
                              child: const Text("Select"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          // Bottom action row
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3ECF8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.directions_car),
              const SizedBox(width: 8),
              Text(
                "New Booking",
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.add, size: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _th(String text, {int flex = 1, bool alignEnd = false}) {
    final child = Text(
      text,
      style: const TextStyle(
        color: Color(0xFF748399),
        fontWeight: FontWeight.w700,
      ),
      textAlign: alignEnd ? TextAlign.right : TextAlign.left,
    );
    return Expanded(flex: flex, child: child);
  }
}


/// --------- RIGHT SIDEBAR ----------
class _RightSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final subtle = const Color(0xFF6B7C8F);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Favorite Rides header
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFFF4F6FA),
                child: Icon(Icons.person, color: Color(0xFF6B7C8F)),
              ),
              const SizedBox(width: 12),
              Text(
                "Favorite Rides",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: subtle, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 24),

          // Ride History section
          Text(
            "Ride History",
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: subtle, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          _kv("Used", "0", valueColor: Colors.green.shade600),
          const SizedBox(height: 8),
          _kv("Cancelled", "0", valueColor: Colors.red.shade600),
          const SizedBox(height: 8),
          _kv("Balance Amount", "0"),
          const Spacer(),

          // Bottom border accent (to mirror screenshot spacing)
          Container(
            height: 2,
            margin: const EdgeInsets.only(bottom: 0),
            decoration: BoxDecoration(
              color: const Color(0xFFE1E7F0),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _kv(String k, String v, {Color? valueColor}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            k,
            style:
            const TextStyle(color: Color(0xFF6B7C8F), fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          v,
          style: TextStyle(
            color: valueColor ?? Colors.black87,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
