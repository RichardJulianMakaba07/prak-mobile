import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:posttest2/providers/user_provider.dart';
import 'package:posttest2/utils/input_style.dart';

/// Bottom sheet edit profil.
/// StatefulWidget DIPAKAI di sini karena membutuhkan TextEditingController
/// (harus dibuat di initState dan di-dispose) serta GlobalKey form.
class EditProfileSheet extends StatefulWidget {
  const EditProfileSheet({super.key});

  @override
  State<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<EditProfileSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _nim;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  late final TextEditingController _major;

  @override
  void initState() {
    super.initState();
    // read() cukup karena hanya mengambil nilai awal sekali
    final u = context.read<UserProvider>();
    _name = TextEditingController(text: u.name);
    _nim = TextEditingController(text: u.nim);
    _email = TextEditingController(text: u.email);
    _phone = TextEditingController(text: u.phone);
    _major = TextEditingController(text: u.major);
  }

  @override
  void dispose() {
    _name.dispose();
    _nim.dispose();
    _email.dispose();
    _phone.dispose();
    _major.dispose();
    super.dispose();
  }

  String? _required(String? v, String label) =>
      (v == null || v.trim().isEmpty) ? '$label wajib diisi' : null;

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    context.read<UserProvider>().updateProfile(
          name: _name.text.trim(),
          nim: _nim.text.trim(),
          email: _email.text.trim(),
          phone: _phone.text.trim(),
          major: _major.text.trim(),
        );
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil berhasil diperbarui')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // viewInsets.bottom = tinggi keyboard, agar form tidak tertutup
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Edit Profil',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextFormField(
                controller: _name,
                decoration: appInputDecoration(context,
                    label: 'Nama', icon: Icons.person_outline),
                validator: (v) => _required(v, 'Nama'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nim,
                keyboardType: TextInputType.number,
                decoration: appInputDecoration(context,
                    label: 'NIM', icon: Icons.badge_outlined),
                validator: (v) => _required(v, 'NIM'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: appInputDecoration(context,
                    label: 'Email', icon: Icons.email_outlined),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Email wajib diisi';
                  if (!v.contains('@')) return 'Format email tidak valid';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                decoration: appInputDecoration(context,
                    label: 'No. HP', icon: Icons.phone_outlined),
                validator: (v) => _required(v, 'No. HP'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _major,
                decoration: appInputDecoration(context,
                    label: 'Program Studi', icon: Icons.school_outlined),
                validator: (v) => _required(v, 'Program studi'),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Simpan',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
