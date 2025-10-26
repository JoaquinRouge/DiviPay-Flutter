import 'package:divipay/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';

class ChangeUsernameModal extends ConsumerStatefulWidget {
  const ChangeUsernameModal({Key? key}) : super(key: key);

  @override
  ConsumerState<ChangeUsernameModal> createState() => _AddSpentModalState();
}

class _AddSpentModalState extends ConsumerState<ChangeUsernameModal> {
  final usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: "Nuevo nombre de Usuario",
                    labelStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                    prefixIcon: HeroIcon(
                      HeroIcons.user,
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
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      try {
                        await ref
                            .read(userServiceProvider)
                            .changeUsername(usernameController.text);

                        context.pop();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Nombre de usuario modificado"),
                            duration: Duration(seconds: 2),
                            backgroundColor: Colors.green,
                          ),
                        );

                        ref.invalidate(userServiceProvider);
                      } catch (e) {
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
                    },
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
