import 'package:flutter/material.dart';

const Color kNavy = Color(0xFF06284A);
const Color kSky = Color(0xFF4EA8F1);
const Color kSoftGrey = Color(0xFFF3F5F8);

class PaymentRequestForm extends StatefulWidget {
  const PaymentRequestForm({super.key});

  @override
  State<PaymentRequestForm> createState() => _PaymentRequestFormState();
}

class _PaymentRequestFormState extends State<PaymentRequestForm> {
  final _formKey = GlobalKey<FormState>();

  // Request Info
  String? paymentType;
  String? department;
  String? unit;
  DateTime? requestDate;
  DateTime? dueDate;

  // Item Details
  List<Map<String, dynamic>> items = [
    {"description": "", "quantity": 1, "unitPrice": 0.0},
  ];

  // Comments
  final TextEditingController commentsController = TextEditingController();

  // Beneficiary Details
  String beneficiaryType = "individual";
  String? bankName;
  String? accountName;
  String? accountNumber;
  String? mpesaName;
  String? mpesaNumber;

  // ================== Helpers ==================
  Future<void> _pickDate(BuildContext context, bool isRequestDate) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isRequestDate) {
          requestDate = picked;
        } else {
          dueDate = picked;
        }
      });
    }
  }

  void _addItem() {
    setState(() {
      items.add({"description": "", "quantity": 1, "unitPrice": 0.0});
    });
  }

  void _removeItem(int index) {
    if (items.length > 1) {
      setState(() => items.removeAt(index));
    }
  }

  double _calculateTotal() => items.fold(
        0.0,
        (sum, item) => sum + ((item["quantity"] ?? 0) * (item["unitPrice"] ?? 0.0)),
      );

  String _formatDate(DateTime? date) {
    if (date == null) return "Pick a date";
    final d = date.toLocal();
    return "${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Payment Request - RequestFlow"),
        backgroundColor: kNavy,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle("1", "Request Information"),
                    Card(
                      elevation: 3,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          children: [
                            _readOnlyField("Form Reference Number", "PRF-2024-0156"),
                            const SizedBox(height: 8),
                            LayoutBuilder(builder: (context, constraints) {
                              final colWidth = (constraints.maxWidth - 12) / 2;
                              return Wrap(
                                spacing: 12,
                                runSpacing: 8,
                                children: [
                                  SizedBox(
                                    width: colWidth,
                                    child: _readOnlyField("Submitted By", "John Davis"),
                                  ),
                                  SizedBox(
                                    width: colWidth,
                                    child: _radioGroupModern(
                                      "Payment Type *",
                                      ["cheque", "cash"],
                                      paymentType,
                                      (val) => setState(() => paymentType = val),
                                    ),
                                  ),
                                ],
                              );
                            }),
                            LayoutBuilder(builder: (context, constraints) {
                              final colWidth = (constraints.maxWidth - 12) / 2;
                              return Wrap(
                                spacing: 12,
                                runSpacing: 8,
                                children: [
                                  SizedBox(
                                    width: colWidth,
                                    child: _dropdownField("Department *", [
                                      "Finance",
                                      "Human Resources",
                                      "IT",
                                      "Marketing",
                                      "Operations"
                                    ], (val) => setState(() => department = val)),
                                  ),
                                  SizedBox(width: colWidth, child: _textField("Unit *", (val) => unit = val)),
                                ],
                              );
                            }),
                            LayoutBuilder(builder: (context, constraints) {
                              final colWidth = (constraints.maxWidth - 12) / 2;
                              return Wrap(
                                spacing: 12,
                                runSpacing: 8,
                                children: [
                                  SizedBox(
                                    width: colWidth,
                                    child: _datePickerField("Request Date *", requestDate, () => _pickDate(context, true)),
                                  ),
                                  SizedBox(
                                    width: colWidth,
                                    child: _datePickerField("Due Date *", dueDate, () => _pickDate(context, false)),
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _sectionTitle("2", "Item Details"),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final itemTotal = (item["quantity"] ?? 0) * (item["unitPrice"] ?? 0.0);
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: _textField("Description", (val) => items[index]["description"] = val)),
                                    const SizedBox(width: 8),
                                    InkWell(
                                      onTap: () => _removeItem(index),
                                      borderRadius: BorderRadius.circular(20),
                                      child: const Padding(
                                        padding: EdgeInsets.all(6),
                                        child: Icon(Icons.delete_outline, color: Colors.redAccent),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _numberField("Quantity", (val) => items[index]["quantity"] = int.tryParse(val) ?? 0, allowDecimal: false),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: _numberField("Unit Price", (val) => items[index]["unitPrice"] = double.tryParse(val) ?? 0.0),
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text("Line Total", style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                                        const SizedBox(height: 4),
                                        Text("KES ${itemTotal.toStringAsFixed(2)}",
                                            style: const TextStyle(fontWeight: FontWeight.bold, color: kNavy)),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton.icon(
                        onPressed: _addItem,
                        icon: const Icon(Icons.add),
                        label: const Text("Add Item"),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Chip(
                        backgroundColor: kSky.withAlpha((0.12 * 255).round()),
                        label: Text("Total: KES ${_calculateTotal().toStringAsFixed(2)}",
                            style: const TextStyle(fontWeight: FontWeight.bold, color: kNavy)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _sectionTitle("3", "Comments"),
                    TextFormField(
                      controller: commentsController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: "Enter comments",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _sectionTitle("4", "Approval Flow"),
                    _readOnlyField("Line Manager Approval", "Pending"),
                    _readOnlyField("Finance Approval", "Pending"),
                    _readOnlyField("CEO Approval", "Pending"),
                    const SizedBox(height: 20),
                    _sectionTitle("5", "Beneficiary Details"),
                    _radioGroupModern(
                      "Beneficiary Type *",
                      ["individual", "company"],
                      beneficiaryType,
                      (val) => setState(() => beneficiaryType = val!),
                    ),
                    if (beneficiaryType == "company") ...[
                      _textField("Bank Name", (val) => bankName = val),
                      _textField("Account Name", (val) => accountName = val),
                      _textField("Account Number", (val) => accountNumber = val),
                    ] else ...[
                      _textField("MPESA Name", (val) => mpesaName = val),
                      _textField("MPESA Number", (val) => mpesaNumber = val),
                    ],
                    const SizedBox(height: 20),
                    _sectionTitle("6", "Clarification / Feedback"),
                    const Text("No feedback provided yet."),
                    const SizedBox(height: 30),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade900,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        ),
                        onPressed: _submitForm,
                        child: const Text("Submit Request"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================== Submit Handler ==================
  void _submitForm() {
    if (paymentType == null || department == null || unit == null || requestDate == null || dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all required fields (type, department, unit, dates).")),
      );
      return;
    }
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Add at least one item.")),
      );
      return;
    }
    for (var it in items) {
      if ((it["description"] as String).trim().isEmpty || (it["quantity"] ?? 0) <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Ensure each item has a description and quantity > 0.")),
        );
        return;
      }
    }
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Form Submitted Successfully!")),
      );
    }
  }

  // ================== Helper Widgets ==================
  Widget _sectionTitle(String number, String title) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.blue.shade900,
          child: Text(number, style: const TextStyle(color: Colors.white)),
        ),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _readOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(label),
        TextFormField(
          initialValue: value,
          readOnly: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade200,
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _textField(String label, Function(String) onSaved) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(label),
        TextFormField(
          decoration: InputDecoration(
            hintText: label,
            border: const OutlineInputBorder(),
          ),
          validator: (val) => val == null || val.isEmpty ? "$label is required" : null,
          onChanged: onSaved,
        ),
      ],
    );
  }

  Widget _numberField(String label, Function(String) onSaved, {bool allowDecimal = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(label),
        TextFormField(
          keyboardType: TextInputType.numberWithOptions(decimal: allowDecimal),
          decoration: InputDecoration(
            hintText: label,
            border: const OutlineInputBorder(),
          ),
          onChanged: onSaved,
        ),
      ],
    );
  }

  Widget _dropdownField(String label, List<String> options, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(label),
        DropdownButtonFormField<String>(
          items: options.map((opt) => DropdownMenuItem(value: opt, child: Text(opt))).toList(),
          onChanged: onChanged,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          validator: (val) => val == null ? "Please select $label" : null,
        ),
      ],
    );
  }

  // ================== Modern RadioGroup Replacement ==================
  Widget _radioGroupModern(String label, List<String> options, String? value, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(label),
        Wrap(
          spacing: 10,
          children: options
              .map((opt) => ChoiceChip(
                    label: Text(opt.capitalize()),
                    selected: value == opt,
                    onSelected: (_) => onChanged(opt),
                    backgroundColor: Colors.grey.shade200,
                    selectedColor: kSky,
                    labelStyle: TextStyle(color: value == opt ? Colors.white : Colors.black),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _datePickerField(String label, DateTime? date, Function() onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(label),
        InkWell(
          onTap: onTap,
          child: InputDecorator(
            decoration: const InputDecoration(border: OutlineInputBorder()),
            child: Text(_formatDate(date)),
          ),
        ),
      ],
    );
  }
}

// ================== Extension ==================
extension StringCasingExtension on String {
  String capitalize() => isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';
}
