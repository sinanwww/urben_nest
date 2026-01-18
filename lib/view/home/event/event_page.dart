import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urben_nest/model/event_model.dart';
import 'package:urben_nest/utls/widgets/custom_filter_row.dart';
import 'package:urben_nest/utls/widgets/event_card.dart';
import 'package:urben_nest/view/home/event/event_detail_page.dart';
import 'package:urben_nest/view_model/event_view_model.dart';

class EventPage extends StatelessWidget {
  final String communityId;

  const EventPage({super.key, required this.communityId});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<String> selectedFilter = ValueNotifier("All");
    final List<String> filters = ["All", "Upcoming", "Past", "Favorites"];

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomFilterRow(
              items: filters,
              selectedItem: selectedFilter,
            ),
          ),
          Expanded(
            child: StreamBuilder<Set<String>>(
              stream: context.read<EventViewModel>().getUserFavoritesStream(),
              builder: (context, favoritesSnapshot) {
                final favorites = favoritesSnapshot.data ?? {};

                return StreamBuilder<List<EventModel>>(
                  stream: context
                      .read<EventViewModel>()
                      .getCommunityEventsStream(communityId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final allEvents = snapshot.data ?? [];

                    if (allEvents.isEmpty) {
                      return const Center(
                        child: Text(
                          'No events yet.\nCreate your first event!',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    }

                    return ValueListenableBuilder<String>(
                      valueListenable: selectedFilter,
                      builder: (context, filter, child) {
                        // Filter events based on selected filter
                        List<EventModel> filteredEvents = allEvents;

                        if (filter == "Upcoming") {
                          final now = DateTime.now();
                          filteredEvents = allEvents.where((event) {
                            final eventDate = DateTime.parse(event.date);
                            return eventDate.isAfter(now);
                          }).toList();
                        } else if (filter == "Past") {
                          final now = DateTime.now();
                          filteredEvents = allEvents.where((event) {
                            final eventDate = DateTime.parse(event.date);
                            return eventDate.isBefore(now);
                          }).toList();
                        } else if (filter == "Favorites") {
                          filteredEvents = allEvents.where((event) {
                            return favorites.contains(event.id);
                          }).toList();
                        }

                        if (filteredEvents.isEmpty) {
                          return Center(
                            child: Text(
                              'No $filter events',
                              style: const TextStyle(fontSize: 16),
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          itemCount: filteredEvents.length,
                          itemBuilder: (context, index) {
                            final event = filteredEvents[index];
                            final isFavorited = favorites.contains(event.id);
                            return EventCard(
                              event: event,
                              isFavorited: isFavorited,
                              onClick: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EventDetailPage(event: event),
                                  ),
                                );
                              },
                              onFavoriteToggle: () {
                                context.read<EventViewModel>().toggleFavorite(
                                  event.id,
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
