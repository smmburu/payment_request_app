import 'package:flutter/material.dart';

const Color kNavy = Color(0xFF06284A);
const Color kSky = Color(0xFF4EA8F1);
const Color kSoftGrey = Color(0xFFF3F5F8);

class PaymentRequestForm extends StatefulWidget {
  @override
  _PaymentRequestFormState createState() => _PaymentRequestFormState();
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
    // start with a single empty item to make the UI friendlier on first open
    {"description": "", "quantity": 1, "unitPrice": 0.0},
  ];

  // Comments
  TextEditingController commentsController = TextEditingController();

  // Beneficiary Details
  String? beneficiaryType = "individual";
  String? bankName;
  String? accountName;
  String? accountNumber;
  String? mpesaName;
  String? mpesaNumber;

  // Helper: Date Picker
  Future<void> _pickDate(BuildContext context, bool isRequestDate) async {
    DateTime? picked = await showDatePicker(
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

  // Helper: Add Item Row
  void _addItem() {
    setState(() {
      items.add({
        "description": "",
        "quantity": 1,
        "unitPrice": 0.0,
      });
    });
  }

  // Helper: Remove Item
  void _removeItem(int index) {
    setState(() {
      if (items.length > 1) items.removeAt(index);
    });
  }

  // Helper: Calculate Total
  double _calculateTotal() {
    return items.fold(
      0.0,
      (sum, item) => sum + ( (item["quantity"] ?? 0) * (item["unitPrice"] ?? 0.0) ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "Pick a date";
    // simple yyyy-MM-dd formatting without extra packages
    final d = date.toLocal();
    return "${d.year.toString().padLeft(4,'0')}-${d.month.toString().padLeft(2,'0')}-${d.day.toString().padLeft(2,'0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Payment Request - RequestFlow"),
        backgroundColor: kNavy,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Center(
          // constrain width so the window doesn't stretch full width on desktop
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 900),
            // Add breathing space left & right inside the constrained form
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 6),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ================= Request Information =================
                    _sectionTitle("1", "Request Information"),
                    Card(
                      elevation: 3,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: EdgeInsets.all(14),
                        child: Column(
                          children: [
                            _readOnlyField("Form Reference Number", "PRF-2024-0156"),
                            SizedBox(height: 8),

                            // NEW: Responsive two-column: Submitted By | Payment Type
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
                                    child: _radioGroup("Payment Type *", ["Cheque", "Cash"], (val) {
                                      setState(() => paymentType = val);
                                    }, paymentType),
                                  ),
                                ],
                              );
                            }),

                            // Responsive two-column: Department | Unit
                            LayoutBuilder(builder: (context, constraints) {
                              final colWidth = (constraints.maxWidth - 12) / 2;
                              return Wrap(
                                spacing: 12,
                                runSpacing: 8,
                                children: [
                                  SizedBox(width: colWidth, child: _dropdownField("Department *", [
                                    "Finance",
                                    "Human Resources",
                                    "IT",
                                    "Marketing",
                                    "Operations"
                                  ], (val) {
                                    setState(() => department = val);
                                  })),
                                  SizedBox(width: colWidth, child: _textField("Unit *", (val) => unit = val)),
                                ],
                              );
                            }),

                            // Responsive two-column: Request Date | Due Date
                            LayoutBuilder(builder: (context, constraints) {
                              final colWidth = (constraints.maxWidth - 12) / 2;
                              return Wrap(
                                spacing: 12,
                                runSpacing: 8,
                                children: [
                                  SizedBox(width: colWidth, child: _datePickerField("Request Date *", requestDate, () => _pickDate(context, true))),
                                  SizedBox(width: colWidth, child: _datePickerField("Due Date *", dueDate, () => _pickDate(context, false))),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 12),

                    // ================= Item Details =================
                    _sectionTitle("2", "Item Details"),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final itemTotal = (item["quantity"] ?? 0) * (item["unitPrice"] ?? 0.0);
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: _textField("Description", (val) {
                                      items[index]["description"] = val;
                                    })),
                                    SizedBox(width: 8),
                                    // smaller, subtle delete affordance
                                    InkWell(
                                      onTap: () => _removeItem(index),
                                      borderRadius: BorderRadius.circular(20),
                                      child: Padding(
                                        padding: EdgeInsets.all(6),
                                        child: Icon(Icons.delete_outline, color: Colors.redAccent),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _numberField("Quantity", (val) {
                                        items[index]["quantity"] = int.tryParse(val) ?? 0;
                                      }, allowDecimal: false),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: _numberField("Unit Price", (val) {
                                        items[index]["unitPrice"] =
                                            double.tryParse(val) ?? 0.0;
                                      }, allowDecimal: true),
                                    ),
                                    SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text("Line Total", style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                                        SizedBox(height: 4),
                                        Text("KES ${itemTotal.toStringAsFixed(2)}",
                                            style: TextStyle(fontWeight: FontWeight.bold, color: kNavy)),
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
                        icon: Icon(Icons.add),
                        label: Text("Add Item"),
                      ),
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Chip(
                        backgroundColor: kSky.withOpacity(0.12),
                        label: Text("Total: KES ${_calculateTotal().toStringAsFixed(2)}",
                            style: TextStyle(fontWeight: FontWeight.bold, color: kNavy)),
                      ),
                    ),

                    SizedBox(height: 20),

                    // ================= Comments =================
                    _sectionTitle("3", "Comments"),
                    TextFormField(
                      controller: commentsController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "Enter comments",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    SizedBox(height: 20),

                    // ================= Approval Flow =================
                    _sectionTitle("4", "Approval Flow"),
                    _readOnlyField("Line Manager Approval", "Pending"),
                    _readOnlyField("Finance Approval", "Pending"),
                    _readOnlyField("CEO Approval", "Pending"),

                    SizedBox(height: 20),

                    // ================= Beneficiary Details =================
                    _sectionTitle("5", "Beneficiary Details"),
                    _radioGroup("Beneficiary Type *", ["Individual", "Company"],
                        (val) {
                      setState(() => beneficiaryType = val!.toLowerCase());
                    }, beneficiaryType),

                    if (beneficiaryType == "company") ...[
                      _textField("Bank Name", (val) => bankName = val),
                      _textField("Account Name", (val) => accountName = val),
                      _textField("Account Number", (val) => accountNumber = val),
                    ] else ...[
                      _textField("MPESA Name", (val) => mpesaName = val),
                      _textField("MPESA Number", (val) => mpesaNumber = val),
                    ],

                    SizedBox(height: 20),

                    // ================= Clarification =================
                    _sectionTitle("6", "Clarification / Feedback"),
                    Text("No feedback provided yet."),

                    SizedBox(height: 30),

                    // ================= Submit Button =================
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade900,
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        ),
                        onPressed: () {
                          // extra basic validation before final submit
                          if (paymentType == null ||
                              department == null ||
                              unit == null ||
                              requestDate == null ||
                              dueDate == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Please complete all required fields (type, department, unit, dates).")),
                            );
                            return;
                          }
                          if (items.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Add at least one item.")),
                            );
                            return;
                          }
                          bool itemValid = true;
                          for (var it in items) {
                            if ((it["description"] as String).trim().isEmpty ||
                                (it["quantity"] ?? 0) <= 0) {
                              itemValid = false;
                              break;
                            }
                          }
                          if (!itemValid) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Ensure each item has a description and quantity > 0.")),
                            );
                            return;
                          }

                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Form Submitted Successfully!")),
                            );
                          }
                        },
                        child: Text("Submit Request"),
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

  // ================== Helper Widgets ==================

  Widget _sectionTitle(String number, String title) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.blue.shade900,
          child: Text(number, style: TextStyle(color: Colors.white)),
        ),
        SizedBox(width: 8),
        Text(title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _readOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(label),
        TextFormField(
          initialValue: value,
          readOnly: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _textField(String label, Function(String) onSaved) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(label),
        TextFormField(
          decoration: InputDecoration(
            hintText: label,
            border: OutlineInputBorder(),
          ),
          validator: (val) =>
              val == null || val.isEmpty ? "$label is required" : null,
          onChanged: onSaved,
        ),
      ],
    );
  }

  Widget _numberField(String label, Function(String) onSaved, {bool allowDecimal = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(label),
        TextFormField(
          keyboardType: TextInputType.numberWithOptions(decimal: allowDecimal),
          decoration: InputDecoration(
            hintText: label,
            border: OutlineInputBorder(),
          ),
          onChanged: onSaved,
        ),
      ],
    );
  }

  Widget _dropdownField(
      String label, List<String> options, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(label),
        DropdownButtonFormField<String>(
          items: options
              .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(border: OutlineInputBorder()),
          validator: (val) =>
              val == null ? "Please select $label" : null,
        ),
      ],
    );
  }

  Widget _radioGroup(
      String label, List<String> options, Function(String?) onChanged, String? groupValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(label),
        Row(
          children: options
              .map((opt) => Expanded(
                    child: RadioListTile<String>(
                      title: Text(opt),
                      value: opt.toLowerCase(),
                      groupValue: groupValue,
                      onChanged: onChanged,
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _datePickerField(
      String label, DateTime? date, Function() onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(label),
        InkWell(
          onTap: onTap,
          child: InputDecorator(
            decoration: InputDecoration(border: OutlineInputBorder()),
            child: Text(_formatDate(date)),
          ),
        ),
      ],
    );
  }
}
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _datePickerField(
      String label, DateTime? date, Function() onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(label),
        InkWell(
          onTap: onTap,
          child: InputDecorator(
            decoration: InputDecoration(border: OutlineInputBorder()),
            child: Text(_formatDate(date)),
          ),
        ),
      ],
    );
  }
}
