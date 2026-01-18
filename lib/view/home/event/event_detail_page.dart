import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:urben_nest/model/event_model.dart';
import 'package:urben_nest/view_model/event_detail_view_model.dart';

class EventDetailPage extends StatelessWidget {
  final EventModel event;
  const EventDetailPage({super.key, required this.event});

  void _showContributionDialog(
    BuildContext context,
    EventDetailViewModel viewModel,
  ) {
    final TextEditingController amountController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Enter Contribution Amount"),
          content: TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              prefixText: "₹ ",
              hintText: "Enter amount",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text);
                if (amount != null && amount > 0) {
                  Navigator.pop(context);
                  viewModel.initiatePayment(amount: amount, title: event.title);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please enter a valid amount"),
                    ),
                  );
                }
              },
              child: const Text("Pay"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EventDetailViewModel(),
      child: Consumer<EventDetailViewModel>(
        builder: (context, viewModel, child) {
          // Handle side effects
          if (viewModel.successMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(viewModel.successMessage!),
                  backgroundColor: Colors.green,
                ),
              );
              viewModel.clearMessages();
            });
          }

          if (viewModel.errorMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(viewModel.errorMessage!),
                  backgroundColor: Colors.red,
                ),
              );
              viewModel.clearMessages();
            });
          }

          if (viewModel.externalWalletName != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "External Wallet: ${viewModel.externalWalletName}",
                  ),
                ),
              );
              viewModel.clearMessages();
            });
          }

          return Scaffold(
            appBar: AppBar(title: Text(event.title)),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 300,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(),
                      image: DecorationImage(
                        image: NetworkImage(
                          "https://images.unsplash.com/photo-1511485977113-f34c92461ad9?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(event.venue),
                        Text(event.description),
                        Text(
                          DateFormat.yMMMMd().format(
                            DateTime.parse(event.date),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: event.isPaid == true
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: viewModel.isPaymentSuccessful
                        ? ElevatedButton(
                            onPressed: null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.withOpacity(0.2),
                              disabledBackgroundColor: Colors.green.withOpacity(
                                0.2,
                              ),
                              disabledForegroundColor: Colors.green,
                            ),
                            child: const Text("Already Paid"),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              if (event.amount != null) {
                                // Fixed amount payment
                                viewModel.initiatePayment(
                                  amount: event.amount!.toDouble(),
                                  title: event.title,
                                );
                              } else {
                                // Contribution payment
                                _showContributionDialog(context, viewModel);
                              }
                            },
                            child: Text(
                              event.amount != null
                                  ? "Pay ${event.amount.toString()}"
                                  : "Contribution your on choice",
                            ),
                          ),
                  )
                : const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
