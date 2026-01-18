import 'package:flutter/material.dart';
import 'package:urben_nest/utls/widgets/concern_card.dart';
import 'package:urben_nest/utls/widgets/custom_filter_row.dart';
import 'package:urben_nest/utls/widgets/event_card.dart';

class ConcernPage extends StatelessWidget {
  ConcernPage({super.key});

  final ValueNotifier<String> _selectedConcern = ValueNotifier("All");

  @override
  Widget build(BuildContext context) {
    List<String> concerns = ["All", "Pending", "Resolved", "My Concerns"];
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomFilterRow(
              items: concerns,
              selectedItem: _selectedConcern,
            ),
          ),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 10,
            itemBuilder: (context, index) => ConcernCard(
              image: index.isEven
                  ? null
                  : "https://images.unsplash.com/photo-1511485977113-f34c92461ad9?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80",
              description:
                  "“Please join us for an elegant evening of holiday cheer. Let's raise a glass to the magic of the season with dinner, ",
              onClick: () {},
            ),
          ),
        ],
      ),
    );
  }
}
