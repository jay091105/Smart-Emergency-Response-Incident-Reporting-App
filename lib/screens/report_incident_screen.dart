import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/incident.dart';
import '../services/incident_service.dart';
import '../utils/logger.dart';

/// Incident priority enum
enum IncidentPriority { low, medium, high, critical }

/// Incident category enum
enum IncidentCategory { medical, fire, security, environment, utility, accident, other }

/// Form state notifier for incident reporting
class IncidentFormNotifier extends StateNotifier<IncidentFormState> {
  IncidentFormNotifier() : super(IncidentFormState());

  void setTitle(String title) => state = state.copyWith(title: title);
  void setDescription(String desc) => state = state.copyWith(description: desc);
  void setPriority(IncidentPriority priority) => state = state.copyWith(priority: priority);
  void setCategory(IncidentCategory category) => state = state.copyWith(category: category);
  void setLocation(String location) => state = state.copyWith(location: location);

  bool validate() {
    if (state.title.trim().isEmpty) return false;
    if (state.description.trim().isEmpty) return false;
    if (state.location.trim().isEmpty) return false;
    return true;
  }
}

/// Form state class
class IncidentFormState {
  final String title;
  final String description;
  final IncidentPriority priority;
  final IncidentCategory category;
  final String location;

  IncidentFormState({
    this.title = '',
    this.description = '',
    this.priority = IncidentPriority.medium,
    this.category = IncidentCategory.other,
    this.location = '',
  });

  IncidentFormState copyWith({
    String? title,
    String? description,
    IncidentPriority? priority,
    IncidentCategory? category,
    String? location,
  }) {
    return IncidentFormState(
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      location: location ?? this.location,
    );
  }
}

/// Riverpod provider for incident form
final incidentFormProvider = StateNotifierProvider<IncidentFormNotifier, IncidentFormState>((ref) {
  return IncidentFormNotifier();
});

/// Report Incident Screen Widget
class ReportIncidentScreenWidget extends ConsumerWidget {
  const ReportIncidentScreenWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _ReportIncidentScreenContent(ref: ref);
  }
}

/// Report Incident Screen Content
class _ReportIncidentScreenContent extends ConsumerStatefulWidget {
  final WidgetRef ref;
  const _ReportIncidentScreenContent({super.key, required this.ref});

  @override
  ConsumerState<_ReportIncidentScreenContent> createState() => _ReportIncidentScreenContentState();
}

class _ReportIncidentScreenContentState extends ConsumerState<_ReportIncidentScreenContent> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(incidentFormProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Incident'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title field
                const Text('Incident Title *', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'e.g., Medical Emergency',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (v) => v?.trim().isEmpty == true ? 'Title is required' : null,
                  onChanged: (v) => ref.read(incidentFormProvider.notifier).setTitle(v),
                ),
                const SizedBox(height: 16),

                // Description field
                const Text('Description *', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Provide details about the incident',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  maxLines: 4,
                  validator: (v) => v?.trim().isEmpty == true ? 'Description is required' : null,
                  onChanged: (v) => ref.read(incidentFormProvider.notifier).setDescription(v),
                ),
                const SizedBox(height: 16),

                // Category dropdown
                const Text('Category *', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                DropdownButtonFormField<IncidentCategory>(
                  value: form.category,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  items: IncidentCategory.values
                      .map((cat) => DropdownMenuItem(value: cat, child: Text(_categoryLabel(cat))))
                      .toList(),
                  onChanged: (cat) {
                    if (cat != null) ref.read(incidentFormProvider.notifier).setCategory(cat);
                  },
                ),
                const SizedBox(height: 16),

                // Priority dropdown
                const Text('Priority *', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                DropdownButtonFormField<IncidentPriority>(
                  value: form.priority,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  items: IncidentPriority.values
                      .map((p) => DropdownMenuItem(value: p, child: Text(_priorityLabel(p))))
                      .toList(),
                  onChanged: (p) {
                    if (p != null) ref.read(incidentFormProvider.notifier).setPriority(p);
                  },
                ),
                const SizedBox(height: 16),

                // Location field
                const Text('Location *', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Manual entry or GPS location',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.location_on),
                      onPressed: () {
                        // TODO: Implement simulated GPS
                        ref.read(incidentFormProvider.notifier).setLocation('Current Location');
                      },
                    ),
                  ),
                  validator: (v) => v?.trim().isEmpty == true ? 'Location is required' : null,
                  onChanged: (v) => ref.read(incidentFormProvider.notifier).setLocation(v),
                ),
                const SizedBox(height: 24),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _submitReport,
                    icon: _isSubmitting ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.check),
                    label: Text(_isSubmitting ? 'Submitting...' : 'Submit Report'),
                  ),
                ),
                const SizedBox(height: 12),

                // Offline notice
                Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: const [
                        Icon(Icons.cloud_off, color: Colors.blue),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Incidents are saved locally and synced when connection is restored.',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields'), backgroundColor: Colors.red),
      );
      return;
    }

    final form = ref.read(incidentFormProvider);
    if (!ref.read(incidentFormProvider.notifier).validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final id = const Uuid().v4();
      final incident = Incident(
        id: id,
        title: form.title,
        description: form.description,
        timestamp: DateTime.now(),
      );

      await IncidentService.instance.saveIncident(incident, markPending: true);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Incident reported successfully! ID: $id'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e, st) {
      logError('submitReport error: $e\n$st');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  String _priorityLabel(IncidentPriority p) {
    switch (p) {
      case IncidentPriority.low:
        return 'Low';
      case IncidentPriority.medium:
        return 'Medium';
      case IncidentPriority.high:
        return 'High';
      case IncidentPriority.critical:
        return 'Critical';
    }
  }
  String _categoryLabel(IncidentCategory cat) {
    switch (cat) {
      case IncidentCategory.medical:
        return 'Medical';
      case IncidentCategory.fire:
        return 'Fire';
      case IncidentCategory.security:
        return 'Security';
      case IncidentCategory.environment:
        return 'Environment';
      case IncidentCategory.utility:
        return 'Utility';
      case IncidentCategory.accident:
        return 'Accident';
      case IncidentCategory.other:
        return 'Other';
    }
  }
}
