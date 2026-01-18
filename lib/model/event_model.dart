class EventModel {
  final String id;
  final String communityId;
  final String createdBy;
  final String createdByName;
  final String title;
  final String description;
  final String venue;
  final String date; // ISO8601 format
  final String time; // Format: "HH:MM AM/PM"
  final bool isPaid;
  final String? paymentType; // 'fixed' or 'contribution'
  final int? amount; // Only for fixed payment
  final String createdAt;
  final String updatedAt;

  EventModel({
    required this.id,
    required this.communityId,
    required this.createdBy,
    required this.createdByName,
    required this.title,
    required this.description,
    required this.venue,
    required this.date,
    required this.time,
    required this.isPaid,
    this.paymentType,
    this.amount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EventModel.fromMap(Map<String, dynamic> map, String id) {
    return EventModel(
      id: id,
      communityId: map['communityId'] ?? '',
      createdBy: map['createdBy'] ?? '',
      createdByName: map['createdByName'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      venue: map['venue'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      isPaid: map['isPaid'] ?? false,
      paymentType: map['paymentType'],
      amount: map['amount'],
      createdAt: map['createdAt'] ?? '',
      updatedAt: map['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'communityId': communityId,
      'createdBy': createdBy,
      'createdByName': createdByName,
      'title': title,
      'description': description,
      'venue': venue,
      'date': date,
      'time': time,
      'isPaid': isPaid,
      'paymentType': paymentType,
      'amount': amount,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
