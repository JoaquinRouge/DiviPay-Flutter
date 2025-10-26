import 'package:divipay/provider/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';

class ChangePasswordModal extends ConsumerStatefulWidget {
  const ChangePasswordModal({Key? key}) : super(key: key);

  @override
  ConsumerState<ChangePasswordModal> createState() =>
      _ChangePasswordModalState();
}

class _ChangePasswordModalState extends ConsumerState<ChangePasswordModal> {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool passwordsMatch = false;
  bool fieldsNotEmpty = false;

  void _validatePasswords() {
    final newPass = newPasswordController.text;
    final confirmPass = confirmPasswordController.text;

    setState(() {
      passwordsMatch = newPass == confirmPass;
      fieldsNotEmpty = newPass.isNotEmpty && confirmPass.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    newPasswordController.addListener(_validatePasswords);
    confirmPasswordController.addListener(_validatePasswords);
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit = passwordsMatch && fieldsNotEmpty;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.center,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: HeroIcon(
                  HeroIcons.chevronDown,
                  color: Theme.of(context).primaryColor,
                  size: 28,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                // Nuevo password
                TextFormField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Nueva contraseña",
                    labelStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                    prefixIcon: HeroIcon(
                      HeroIcons.lockClosed,
                      color: Theme.of(context).primaryColor,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Confirm password
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Confirmar contraseña",
                    labelStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                    prefixIcon: HeroIcon(
                      HeroIcons.lockClosed,
                      color: Theme.of(context).primaryColor,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Mensaje de error si no coinciden
                if (!passwordsMatch && fieldsNotEmpty)
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 4, left: 8),
                      child: Text(
                        "Las contraseñas no coinciden",
                        style: TextStyle(color: Colors.redAccent, fontSize: 12),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: canSubmit
                          ? Theme.of(context).primaryColor
                          : Colors.grey.shade400,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: canSubmit
                        ? () async {
                            try {
                              await ref
                                  .read(userServiceProvider)
                                  .changePassword(newPasswordController.text);

                              context.pop();

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Contraseña modificada"),
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } on FirebaseAuthException catch(e) {
                              context.pop();
                              String message = e.toString();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(message),
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        : null,
                    child: const Text(
                      "Modificar",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
