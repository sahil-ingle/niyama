import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hive/hive.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:niyama/theme/theme_provider.dart';
import 'package:niyama/widgets/my_elevated_btn.dart';
import 'package:niyama/widgets/my_text_field.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Box<String> myProfile = Hive.box<String>('profile');
  Box<bool> authBox = Hive.box<bool>('auth');
  late Box<int> myThemeColor;
  late Color selectedColor;

  @override
  void initState() {
    super.initState();
    myThemeColor = Hive.box<int>('themeColor');
    selectedColor = Color(myThemeColor.get("color") ?? Colors.white.value);
  }

  final _nameController = TextEditingController();

  void changeSeedColor() {
    Color tempColor = selectedColor; // Temporary color for live preview

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) => AlertDialog(
          title: const Text(
            "Select Color",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Color preview
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: tempColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 12), // adjusted spacing
                // Color picker
                ColorPicker(
                  pickerColor: tempColor,
                  onColorChanged: (color) {
                    setStateDialog(() {
                      tempColor = color; // Live preview
                    });
                  },
                  enableAlpha: false,
                  pickerAreaHeightPercent: 0.6, // slightly smaller for balance
                  displayThumbColor: true,

                  paletteType: PaletteType.hsvWithHue,
                ),
                const SizedBox(height: 12), // consistent spacing
                // Preset colors
                SizedBox(
                  height: 52,
                  child: BlockPicker(
                    pickerColor: tempColor,
                    availableColors: [
                      Colors.green, // Enreld green
                      Colors.lightBlue, // Sky blue
                      Colors.yellow, // Yellow
                      Colors.pink, // Pinky
                    ],
                    onColorChanged: (color) {
                      setStateDialog(() {
                        tempColor = color; // Update preview
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          actions: [
            MyElevatedBtn(
              fixedSize: const Size(double.infinity, 52),
              text: "Done",
              onTap: () {
                setState(() {
                  selectedColor = tempColor; // Apply to main state
                });
                myThemeColor.put("color", selectedColor.value);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('To see effect, reset the app')),
                );

                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void showDialogBox() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text("Enter Your Name"),
        content: MyTextField(nameController: _nameController, hintText: "Name"),
        actions: [
          Center(
            child: MyElevatedBtn(
              text: "Update",
              onTap: () {
                final enteredName = _nameController.text.trim();
                if (enteredName.isNotEmpty) {
                  myProfile.put("name", enteredName);

                  Navigator.pop(ctx);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter a valid name")),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isAuthEnabled = authBox.get('isAuthEnabled', defaultValue: false)!;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 160,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              "Settings",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            titlePadding: EdgeInsets.only(left: 16, bottom: 16),
          ),
        ),
        SliverList.list(
          children: [
            Card(
              child: Column(
                children: [
                  SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Change Name",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              "Add your Name",
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: showDialogBox,
                          icon: Icon(FontAwesome.pen_to_square),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),

                  Divider(indent: 20, endIndent: 20),

                  SizedBox(height: 8),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Theme Color",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              "Change the look of your \napp ",
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        MyElevatedBtn(
                          text: "Select",
                          onTap: changeSeedColor,
                          fixedSize: Size(100, 52),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 8),

                  Divider(indent: 20, endIndent: 20),

                  SizedBox(height: 8),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Theme",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              "Change to theme of your app \nLight or Dark",
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Switch(
                          value: themeProvider.isDarkMode,
                          onChanged: (value) {
                            final provider = Provider.of<ThemeProvider>(
                              context,
                              listen: false,
                            );
                            provider.toggleTheme(value);
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 8),

                  Divider(indent: 20, endIndent: 20),

                  SizedBox(height: 8),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Biometric Lock",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              "Add Applock to secure \nyour Habits",
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Switch(
                          value: isAuthEnabled,
                          onChanged: (value) {
                            setState(() {
                              isAuthEnabled = value;
                              authBox.put('isAuthEnabled', value);
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
