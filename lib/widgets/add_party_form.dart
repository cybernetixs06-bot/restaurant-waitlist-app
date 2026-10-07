import 'package:flutter/material.dart';

class AddPartyForm extends StatefulWidget {
  final Future<void> Function({
    required String name,
    required int numberOfPeople,
  }) onSubmit;

  final String title;
  final String submitButtonText;
  final String? initialName;
  final int? initialNumberOfPeople;

  const AddPartyForm({
    super.key,
    required this.onSubmit,
    this.title = 'Add Party',
    this.submitButtonText = 'Add',
    this.initialName,
    this.initialNumberOfPeople,
  });

  @override
  State<AddPartyForm> createState() => _AddPartyFormState();
}

class _AddPartyFormState extends State<AddPartyForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _partySizeController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.initialName ?? '',
    );

    _partySizeController = TextEditingController(
      text: widget.initialNumberOfPeople?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _partySizeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = _nameController.text.trim();
    final numberOfPeople = int.parse(_partySizeController.text);

    await widget.onSubmit(
      name: name,
      numberOfPeople: numberOfPeople,
    );

    if (!mounted) return;

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Name is required';
                }

                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _partySizeController,
              decoration: const InputDecoration(
                labelText: 'Party size',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Party size is required';
                }

                final size = int.tryParse(value);

                if (size == null || size <= 0) {
                  return 'Enter a whole number greater than 0';
                }

                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text(widget.submitButtonText),
        ),
      ],
    );
  }
}
