import 'package:flutter/material.dart';
import 'request_form.dart';

const Color accentBlue = Color(0xFF00AEEF);
const Color accentPurple = Color(0xFF4B3F72);
const Color accentRed = Color(0xFFE53935);
const Color accentYellow = Color(0xFFF9D71C);
const Color accentGreen = Color(0xFF4CAF50);
const double sidebarWidth = 220;
const double cardRadius = 12;

class DashboardPage extends StatelessWidget {
  Widget _navItem(BuildContext c, IconData icon, String label, {bool active = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
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
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(cardRadius), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0,2))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.grey[800])),
          SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Text(number, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87))),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                child: Icon(icon, color: Colors.white, size: 20),
              )
            ],
          ),
          if (bottomText != null) ...[
            SizedBox(height: 8),
            Text(bottomText, style: TextStyle(color: bottomColor ?? accentBlue, fontSize: 12))
          ],
        ],
      ),
    );
  }

  Widget _notificationItem(Color stripe, Color bg, String text) {
    return Container(
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(width: 6, height: 56, decoration: BoxDecoration(color: stripe, borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)))),
          SizedBox(width: 12),
          Expanded(child: Text(text, style: TextStyle(color: Colors.grey[900]))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // no appBar; header is inside the main layout
      body: SafeArea(
        child: Row(
          children: [
            // Sidebar
            Container(
              width: sidebarWidth,
              color: Color(0xFFE8E6E6),
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo
                  Text('SCRS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  SizedBox(height: 18),
                  // Nav
                  _navItem(context, Icons.dashboard, 'Dashboard', active: true),
                  _navItem(context, Icons.description, 'Requests'),
                  _navItem(context, Icons.approval, 'Approvals'),
                  _navItem(context, Icons.pie_chart, 'Reports'),
                  _navItem(context, Icons.help_outline, 'Help'),
                  Spacer(),
                  // Logout
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentRed,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        padding: EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/');
                      },
                      child: Text('Logout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        // left side blank (per spec)
                        Expanded(child: SizedBox()),
                        // profile area
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(color: accentPurple.withOpacity(0.15), shape: BoxShape.circle),
                              child: Center(child: Icon(Icons.person, color: accentPurple)),
                            ),
                            SizedBox(width: 10),
                            Text('Samuel Mburu', style: TextStyle(color: Colors.black87)),
                            SizedBox(width: 6),
                          ],
                        )
                      ],
                    ),
                  ),

                  // Content
                  Expanded(
                    child: Container(
                      color: Color(0xFFF5F5F5),
                      padding: EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title & subtitle
                            Text('Dashboard', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
                            SizedBox(height: 6),
                            Text('Overview of your requests and approvals', style: TextStyle(color: Colors.grey[600])),
                            SizedBox(height: 18),

                            // Status cards row
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: _statusCard('Pending Requests', '12', Icons.access_time, Colors.grey)),
                                SizedBox(width: 12),
                                Expanded(child: _statusCard('Awaiting Approval', '8', Icons.check, accentBlue)),
                                SizedBox(width: 12),
                                Expanded(child: _statusCard('Rejected Requests', '3', Icons.close, accentRed)),
                                SizedBox(width: 12),
                                Expanded(child: _statusCard('Total Requests', '147', Icons.trending_up, accentYellow, bottomText: '+12% from last month', bottomColor: accentGreen)),
                              ],
                            ),

                            SizedBox(height: 18),

                            // Middle row: Requests Overview + Notifications
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Left: Requests Overview (large)
                                Expanded(
                                  flex: 65,
                                  child: Container(
                                    height: 300,
                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(cardRadius), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0,2))]),
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Requests Overview', style: TextStyle(color: kNavy, fontWeight: FontWeight.bold)),
                                        SizedBox(height: 12),
                                        Expanded(child: Center(child: Text('Chart area (placeholder)', style: TextStyle(color: Colors.grey[500])))),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                // Right: Notifications
                                Expanded(
                                  flex: 35,
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(cardRadius), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0,2))]),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Notifications', style: TextStyle(color: kNavy, fontWeight: FontWeight.bold)),
                                        SizedBox(height: 12),
                                        _notificationItem(accentRed, Colors.red[50]!, 'Notification 1: Laptop purchasing request this month'),
                                        _notificationItem(accentYellow, Colors.yellow[50]!, 'Notification 2: Policy update required'),
                                        _notificationItem(accentBlue, Colors.lightBlue[50]!, 'Notification 3: New approval assigned'),
                                        SizedBox(height: 8),
                                        OutlinedButton(
                                          onPressed: () {},
                                          child: Text('View All Notifications'),
                                          style: OutlinedButton.styleFrom(
                                            side: BorderSide(color: accentBlue),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 18),

                            // Bottom Row - Quick Actions
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(cardRadius), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0,2))]),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Quick Actions', style: TextStyle(color: kNavy, fontWeight: FontWeight.bold)),
                                        SizedBox(height: 12),
                                        GridView.count(
                                          crossAxisCount: 2,
                                          shrinkWrap: true,
                                          crossAxisSpacing: 12,
                                          mainAxisSpacing: 12,
                                          childAspectRatio: 3,
                                          physics: NeverScrollableScrollPhysics(),
                                          children: [
                                            _actionTile(context, accentPurple, Icons.add, 'New Request', onTap: () {
                                              Navigator.of(context).push(MaterialPageRoute(builder: (_) => PaymentRequestForm(), fullscreenDialog: true));
                                            }),
                                            _actionTile(context, accentBlue, Icons.search, 'Search'),
                                            _actionTile(context, accentGreen, Icons.file_download, 'Reports'),
                                            _actionTile(context, accentPurple, Icons.settings, 'Settings'),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Container(
                                    height: 180,
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(cardRadius), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0,2))]),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Quick Actions (Extra)', style: TextStyle(color: kNavy, fontWeight: FontWeight.bold)),
                                        SizedBox(height: 12),
                                        Expanded(child: Center(child: Text('Empty placeholder'))),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),

                            SizedBox(height: 24),
                          ],
                        ),
                      ),
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

  Widget _actionTile(BuildContext context, Color bg, IconData icon, String label, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey[200]!)),
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            SizedBox(width: 10),
            Flexible(child: Text(label)),
          ],
        ),
      ),
    );
  }
}
