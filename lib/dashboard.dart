import 'package:flutter/material.dart';
import 'request_form.dart';

const Color accentBlue = Color(0xFF00AEEF);
const Color accentPurple = Color(0xFF4B3F72);
const Color accentRed = Color(0xFFE53935);
const Color accentYellow = Color(0xFFF9D71C);
const Color accentGreen = Color(0xFF4CAF50);
const Color kNavy = Color(0xFF001F3F);
const double sidebarWidth = 220;
const double cardRadius = 12;
const double statusCardHeight = 120; // Fixed height for status/summary cards

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  Widget _navItem(BuildContext c, IconData icon, String label, {bool active = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: active
          ? BoxDecoration(color: Colors.grey[600], borderRadius: BorderRadius.circular(8))
          : null,
      child: ListTile(
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: active ? accentPurple : Colors.grey[400],
          child: Icon(icon, size: 16, color: Colors.white),
        ),
        title: Text(label, style: TextStyle(color: active ? Colors.white : Colors.black, fontWeight: active ? FontWeight.bold : FontWeight.normal)),
        dense: true,
        horizontalTitleGap: 8,
        onTap: () {},
      ),
    );
  }

  Widget _statusCard(String title, String number, IconData icon, Color iconBg, {String? bottomText, Color? bottomColor}) {
    // Wrap the card in a sized box to force consistent height across all cards
    return SizedBox(
      height: statusCardHeight,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(cardRadius),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0,2))]),
        // use spaceBetween so children compress when vertical space is tight
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: Colors.grey[800])),
            // slightly reduce fixed gap and make number scale down when needed
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // scale down the large number if the parent height is constrained
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(number, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                  child: Icon(icon, color: Colors.white, size: 20),
                )
              ],
            ),
            if (bottomText != null) ...[
              const SizedBox(height: 6),
              Text(bottomText, style: TextStyle(color: bottomColor ?? accentBlue, fontSize: 12))
            ],
          ],
        ),
      ),
    );
  }

  Widget _notificationItem(Color stripe, Color bg, String text) {
    return Container(
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(width: 6, height: 56, decoration: BoxDecoration(color: stripe, borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)))),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: TextStyle(color: Colors.grey[900]))),
        ],
      ),
    );
  }

  Widget _actionTile(BuildContext context, Color bg, IconData icon, String label, {VoidCallback? onTap, double? height}) {
    // Reduced tile height by default; allow caller to override for exact sizing
    final tileHeight = height ?? 48;
    return SizedBox(
      height: tileHeight,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey[200]!)),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
                child: Icon(icon, color: Colors.white, size: 16), // smaller icon
              ),
              const SizedBox(width: 8),
              // single-line label to save vertical space
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // New: small tabbed panel for Pending Approvals / Recent Activity
  Widget _extraPanel() {
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Overview', style: TextStyle(color: kNavy, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(cardRadius), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0,2))]),
            child: Column(
              children: [
                const TabBar(
                  indicatorColor: kNavy,
                  labelColor: kNavy,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(text: 'Pending'),
                    Tab(text: 'Activity'),
                  ],
                ),
                SizedBox(
                  height: 160, // compact height so it fits in the layout
                  child: TabBarView(
                    children: [
                      // Pending Approvals list (compact)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            ListTile(
                              dense: true,
                              title: const Text('PRF-2024-0159 - Laptop', style: TextStyle(fontSize: 14)),
                              subtitle: const Text('John Davis • KES 120,000', style: TextStyle(fontSize: 12)),
                              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                                IconButton(icon: const Icon(Icons.close, color: Colors.redAccent, size: 18), onPressed: () {}),
                                IconButton(icon: const Icon(Icons.check, color: Colors.green, size: 18), onPressed: () {}),
                              ]),
                            ),
                            const Divider(height: 6),
                            ListTile(
                              dense: true,
                              title: const Text('PRF-2024-0157 - Stationery', style: TextStyle(fontSize: 14)),
                              subtitle: const Text('Mary Kimani • KES 4,500', style: TextStyle(fontSize: 12)),
                              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                                IconButton(icon: const Icon(Icons.close, color: Colors.redAccent, size: 18), onPressed: () {}),
                                IconButton(icon: const Icon(Icons.check, color: Colors.green, size: 18), onPressed: () {}),
                              ]),
                            ),
                          ],
                        ),
                      ),
                      // Recent Activity timeline
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: const [
                            ListTile(dense: true, leading: Icon(Icons.history, size: 18), title: Text('Samuel approved PRF-2024-0154', style: TextStyle(fontSize: 13)), subtitle: Text('2h ago', style: TextStyle(fontSize: 11))),
                            ListTile(dense: true, leading: Icon(Icons.upload_file, size: 18), title: Text('New request PRF-2024-0159 created', style: TextStyle(fontSize: 13)), subtitle: Text('4h ago', style: TextStyle(fontSize: 11))),
                            ListTile(dense: true, leading: Icon(Icons.comment, size: 18), title: Text('Comment added on PRF-2024-0156', style: TextStyle(fontSize: 13)), subtitle: Text('Yesterday', style: TextStyle(fontSize: 11))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            // Sidebar
            Container(
              width: sidebarWidth,
              color: const Color(0xFFE8E6E6),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('SCRS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 18),
                  _navItem(context, Icons.dashboard, 'Dashboard', active: true),
                  _navItem(context, Icons.description, 'Requests'),
                  _navItem(context, Icons.approval, 'Approvals'),
                  _navItem(context, Icons.pie_chart, 'Reports'),
                  _navItem(context, Icons.help_outline, 'Help'),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentRed,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/');
                      },
                      child: const Text('Logout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),

            // Main area
            Expanded(
              child: Column(
                children: [
                  // Top header
                  Container(
                    height: 64,
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        const Expanded(child: SizedBox()),
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(color: accentPurple.withOpacity(0.15), shape: BoxShape.circle),
                              child: const Center(child: Icon(Icons.person, color: accentPurple)),
                            ),
                            const SizedBox(width: 10),
                            const Text('Samuel Mburu', style: TextStyle(color: Colors.black87)),
                            const SizedBox(width: 6),
                          ],
                        )
                      ],
                    ),
                  ),
                  // Content
                  Expanded(
                    child: Container(
                      color: const Color(0xFFF5F5F5),
                      padding: const EdgeInsets.all(20),
                      // Use LayoutBuilder to allocate space without global scrolling
                      child: LayoutBuilder(builder: (context, constraints) {
                        final availHeight = constraints.maxHeight;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title block (fixed-ish height)
                            SizedBox(
                              height: 72,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Dashboard', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
                                  const SizedBox(height: 6),
                                  Text('Overview of your requests and approvals', style: TextStyle(color: Colors.grey[600])),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),
                            // Status cards row (fixed height)
                            SizedBox(
                              height: statusCardHeight,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: _statusCard('Pending Requests', '12', Icons.access_time, Colors.grey)),
                                  const SizedBox(width: 12),
                                  Expanded(child: _statusCard('Awaiting Approval', '8', Icons.check, accentBlue)),
                                  const SizedBox(width: 12),
                                  Expanded(child: _statusCard('Approved Requests', '20', Icons.check_circle, accentGreen)),
                                  const SizedBox(width: 12),
                                  Expanded(child: _statusCard('Rejected Requests', '3', Icons.close, accentRed)),
                                  const SizedBox(width: 12),
                                  Expanded(child: _statusCard('Total Requests', '147', Icons.trending_up, accentYellow, bottomText: '+12% from last month', bottomColor: accentGreen)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),
                            // Middle row: Requests Overview + Notifications (fills available space)
                            Expanded(
                              flex: 6,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    flex: 65,
                                    child: Container(
                                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(cardRadius), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0,2))]),
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: const [
                                          Text('Requests Overview', style: TextStyle(color: kNavy, fontWeight: FontWeight.bold)),
                                          SizedBox(height: 12),
                                          Expanded(child: Center(child: Text('Chart area (placeholder)', style: TextStyle(color: Colors.grey)))),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    flex: 35,
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(cardRadius), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0,2))]),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Notifications', style: TextStyle(color: kNavy, fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 12),
                                          // ListView is constrained by Expanded so it scrolls internally only
                                          Expanded(
                                            child: ListView(
                                              padding: EdgeInsets.zero,
                                              children: [
                                                _notificationItem(accentRed, Colors.red[50]!, 'Notification 1: Laptop purchasing request this month'),
                                                _notificationItem(accentYellow, Colors.yellow[50]!, 'Notification 2: Policy update required'),
                                                _notificationItem(accentBlue, Colors.lightBlue[50]!, 'Notification 3: New approval assigned'),
                                                _notificationItem(accentBlue, Colors.lightBlue[50]!, 'Notification 4: Travel advance pending'),
                                                _notificationItem(accentYellow, Colors.yellow[50]!, 'Notification 5: Expense policy change'),
                                                _notificationItem(accentRed, Colors.red[50]!, 'Notification 6: Vendor invoice overdue'),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          SizedBox(
                                            width: double.infinity,
                                            child: OutlinedButton(
                                              onPressed: () {},
                                              style: OutlinedButton.styleFrom(
                                                side: BorderSide(color: accentBlue),
                                              ),
                                              child: const Text('View All Notifications'),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),
                            // Bottom Row - Quick Actions (fills remaining space)
                            Expanded(
                              flex: 4,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(cardRadius), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0,2))]),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Quick Actions', style: TextStyle(color: kNavy, fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 12),
                                          Expanded(
                                            child: LayoutBuilder(builder: (ctx, box) {
                                              // compute tile size so 2 columns fit exactly within the container with spacing
                                              const cols = 2;
                                              const spacing = 12.0;
                                              const runSpacing = 12.0;
                                              final itemCount = 4;
                                              final rows = (itemCount / cols).ceil();
                                              final tileWidth = (box.maxWidth - (cols - 1) * spacing) / cols;
                                              final totalRunSpacing = (rows - 1) * runSpacing;
                                              final tileHeight = (box.maxHeight - totalRunSpacing) / rows;
                                              return Wrap(
                                                spacing: spacing,
                                                runSpacing: runSpacing,
                                                children: [
                                                  SizedBox(width: tileWidth, height: tileHeight, child: _actionTile(context, accentPurple, Icons.add, 'New Request', onTap: () {
                                                    Navigator.pushNamed(context, '/new_request');
                                                  }, height: tileHeight)),
                                                  SizedBox(width: tileWidth, height: tileHeight, child: _actionTile(context, accentBlue, Icons.search, 'Search', height: tileHeight)),
                                                  SizedBox(width: tileWidth, height: tileHeight, child: _actionTile(context, accentGreen, Icons.file_download, 'Reports', height: tileHeight)),
                                                  SizedBox(width: tileWidth, height: tileHeight, child: _actionTile(context, accentPurple, Icons.settings, 'Settings', height: tileHeight)),
                                                ],
                                              );
                                            }),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(cardRadius), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0,2))]),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: const [
                                          Text('Quick Actions (Extra)', style: TextStyle(color: kNavy, fontWeight: FontWeight.bold)),
                                          SizedBox(height: 12),
                                          Expanded(child: Center(child: Text('Empty placeholder'))),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        );
                      }),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
