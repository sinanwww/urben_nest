import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:urben_nest/model/event_model.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final Function() onClick;
  final Function() onFavoriteToggle;
  final bool isFavorited;

  const EventCard({
    super.key,
    required this.event,
    required this.onClick,
    required this.onFavoriteToggle,
    required this.isFavorited,
  });

  String _formatDate(String isoDate) {
    final date = DateTime.parse(isoDate);
    return DateFormat('MMM d, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Header with Date Badge
            // Container(
            //   padding: const EdgeInsets.all(16),
            //   decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //       colors: [AppTheme.primary.withOpacity(0.8), AppTheme.primary],
            //       begin: Alignment.topLeft,
            //       end: Alignment.bottomRight,
            //     ),
            //     borderRadius: const BorderRadius.vertical(
            //       top: Radius.circular(12),
            //     ),
            //   ),
            //   child: Row(
            //     children: [
            //       // Date Badge
            //       Container(
            //         padding: const EdgeInsets.symmetric(
            //           horizontal: 12,
            //           vertical: 8,
            //         ),
            //         decoration: BoxDecoration(
            //           color: Colors.white,
            //           borderRadius: BorderRadius.circular(8),
            //         ),
            //         child: Column(
            //           children: [
            //             Text(
            //               DateTime.parse(event.date).day.toString(),
            //               style: TextStyle(
            //                 fontSize: 24,
            //                 fontWeight: FontWeight.bold,
            //                 color: AppTheme.primary,
            //               ),
            //             ),
            //             Text(
            //               _formatDate(event.date).split(' ')[0],
            //               style: TextStyle(
            //                 fontSize: 12,
            //                 color: AppTheme.primary,
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //       const SizedBox(width: 16),
            //       // Event Title
            //       Expanded(
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Text(
            //               event.title,
            //               style: const TextStyle(
            //                 fontSize: 18,
            //                 fontWeight: FontWeight.bold,
            //                 color: Colors.white,
            //               ),
            //               maxLines: 2,
            //               overflow: TextOverflow.ellipsis,
            //             ),
            //             const SizedBox(height: 4),
            //             Row(
            //               children: [
            //                 const Icon(
            //                   Icons.access_time,
            //                   size: 14,
            //                   color: Colors.white70,
            //                 ),
            //                 const SizedBox(width: 4),
            //                 Text(
            //                   event.time,
            //                   style: const TextStyle(
            //                     fontSize: 12,
            //                     color: Colors.white70,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ],
            //         ),
            //       ),
            //       // Paid Badge
            //       if (event.isPaid)
            //         Container(
            //           padding: const EdgeInsets.symmetric(
            //             horizontal: 8,
            //             vertical: 4,
            //           ),
            //           decoration: BoxDecoration(
            //             color: Colors.amber,
            //             borderRadius: BorderRadius.circular(12),
            //           ),
            //           child: Row(
            //             mainAxisSize: MainAxisSize.min,
            //             children: [
            //               const Icon(
            //                 Icons.currency_rupee,
            //                 size: 12,
            //                 color: Colors.white,
            //               ),
            //               if (event.paymentType == 'fixed' &&
            //                   event.amount != null)
            //                 Text(
            //                   event.amount.toString(),
            //                   style: const TextStyle(
            //                     fontSize: 12,
            //                     fontWeight: FontWeight.bold,
            //                     color: Colors.white,
            //                   ),
            //                 )
            //               else
            //                 const Text(
            //                   'PAID',
            //                   style: TextStyle(
            //                     fontSize: 10,
            //                     fontWeight: FontWeight.bold,
            //                     color: Colors.white,
            //                   ),
            //                 ),
            //             ],
            //           ),
            //         ),
            //       const SizedBox(width: 8),
            //     ],
            //   ),
            // ),
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                image: DecorationImage(
                  image: NetworkImage(
                    "https://images.unsplash.com/photo-1511485977113-f34c92461ad9?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ), // Event Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Description
                  Text(
                    event.title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  // Favorite Button
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onFavoriteToggle,
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          isFavorited ? Icons.favorite : Icons.favorite_border,
                          color: isFavorited ? Colors.red : Colors.grey,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
