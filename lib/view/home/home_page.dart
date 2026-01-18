import 'package:flutter/material.dart';
import 'package:urben_nest/utls/app_theme.dart';
import 'package:urben_nest/view/home/drawer_widget.dart';
import 'package:urben_nest/view/home/event/event_page.dart';

class HomePage extends StatelessWidget {
  final String? communityId; // Optional for backward compatibility

  const HomePage({super.key, this.communityId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hi-5 Homes'),
          actions: [
            IconButton(
              icon: const Icon(Icons.qr_code_scanner),
              onPressed: () {},
            ),
            IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
          ],
          bottom: const TabBar(
            indicatorColor: AppTheme.primary,
            indicatorPadding: EdgeInsets.zero,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(text: 'Event'),
              Tab(text: 'Poll'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            EventPage(communityId: communityId ?? ''),
            Center(child: Text('Poll Page')),
          ],
        ),
        drawer: DrawerWidget(communityId: communityId),
      ),
    );
  }
}
