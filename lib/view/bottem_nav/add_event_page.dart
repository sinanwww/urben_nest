import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:urben_nest/utls/app_theme.dart';
import 'package:urben_nest/view_model/add_event_view_model.dart';
import 'package:urben_nest/view_model/event_view_model.dart';
import 'package:urben_nest/utls/widgets/input_field.dart';

class AddEventPage extends StatelessWidget {
  final String communityId;

  const AddEventPage({super.key, required this.communityId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddEventViewModel(),
      child: _AddEventPageContent(communityId: communityId),
    );
  }
}

class _AddEventPageContent extends StatefulWidget {
  final String communityId;

  const _AddEventPageContent({required this.communityId});

  @override
  State<_AddEventPageContent> createState() => _AddEventPageContentState();
}

class _AddEventPageContentState extends State<_AddEventPageContent> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _venueController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _venueController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
    BuildContext context,
    AddEventViewModel viewModel,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: viewModel.selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      viewModel.setSelectedDate(picked);
    }
  }

  Future<void> _selectTime(
    BuildContext context,
    AddEventViewModel viewModel,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: viewModel.selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      viewModel.setSelectedTime(picked);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Future<void> _createEvent(
    BuildContext context,
    AddEventViewModel viewModel,
  ) async {
    try {
      final eventViewModel = Provider.of<EventViewModel>(
        context,
        listen: false,
      );

      final success = await eventViewModel.createEvent(
        communityId: widget.communityId,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        venue: _venueController.text.trim(),
        date: viewModel.selectedDate!,
        time: _formatTime(viewModel.selectedTime!),
        isPaid: viewModel.isPaid,
        paymentType: viewModel.isPaid ? viewModel.paymentType : null,
        amount: viewModel.isPaid && viewModel.paymentType == 'fixed'
            ? int.tryParse(_amountController.text.trim())
            : null,
      );

      if (!context.mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Event created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              eventViewModel.errorMessage ?? 'Failed to create event',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddEventViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('Add Event'), elevation: 0),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Title Field
                const SizedBox(height: 8),
                InputField(
                  controller: _titleController,
                  labelText: 'Title',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter event title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Description Field
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Description',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter event description';
                    }
                    return null;
                  },
                ),

                // Venue Field
                InputField(
                  controller: _venueController,
                  labelText: 'Venue',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter venue';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Date and Time Row
                Row(
                  children: [
                    // Date Field
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () => _selectDate(context, viewModel),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color: AppTheme.primary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      viewModel.selectedDate != null
                                          ? _formatDate(viewModel.selectedDate!)
                                          : 'Select date',
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Time Field
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () => _selectTime(context, viewModel),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    color: AppTheme.primary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      viewModel.selectedTime != null
                                          ? _formatTime(viewModel.selectedTime!)
                                          : 'Select time',
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Paid Event Checkbox
                CheckboxListTile(
                  title: const Text(
                    'Paid Event',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  value: viewModel.isPaid,
                  activeColor: AppTheme.primary,
                  onChanged: (value) => viewModel.setIsPaid(value ?? false),
                  controlAffinity: ListTileControlAffinity.leading,
                ),

                // Payment Options (shown only if paid is enabled)
                if (viewModel.isPaid) ...[
                  const SizedBox(height: 24),
                  const SizedBox(height: 12),

                  // Payment Type Selection
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      children: [
                        RadioListTile<String>(
                          title: const Text('Fixed Amount'),
                          subtitle: const Text(
                            'Set a specific price for the event',
                            style: TextStyle(fontSize: 12),
                          ),
                          value: 'fixed',
                          groupValue: viewModel.paymentType,
                          activeColor: AppTheme.primary,
                          onChanged: (value) =>
                              viewModel.setPaymentType(value!),
                        ),
                        Divider(height: 1, color: Colors.grey.shade300),
                        RadioListTile<String>(
                          title: const Text('Contribution of Choice'),
                          subtitle: const Text(
                            'Let attendees contribute any amount',
                            style: TextStyle(fontSize: 12),
                          ),
                          value: 'contribution',
                          groupValue: viewModel.paymentType,
                          activeColor: AppTheme.primary,
                          onChanged: (value) =>
                              viewModel.setPaymentType(value!),
                        ),
                      ],
                    ),
                  ),

                  // Amount Field (shown only for fixed payment)
                  if (viewModel.paymentType == 'fixed') ...[
                    const SizedBox(height: 24),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: 'Enter amount',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (viewModel.isPaid &&
                            viewModel.paymentType == 'fixed') {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter amount';
                          }
                          final amount = int.tryParse(value);
                          if (amount == null || amount <= 0) {
                            return 'Please enter a valid amount';
                          }
                        }
                        return null;
                      },
                    ),
                  ],
                ],

                const SizedBox(height: 32),

                // Create Event Button
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (viewModel.selectedDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select event date'),
                            ),
                          );
                          return;
                        }
                        if (viewModel.selectedTime == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select event time'),
                            ),
                          );
                          return;
                        }

                        // Save event data
                        await _createEvent(context, viewModel);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Create Event',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
