import 'package:the_lifecounter/functions/utlis.dart';
import 'package:flutter/material.dart';
import 'package:the_lifecounter/functions/player.dart';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({
    super.key,
    required this.setButtons,
    required this.selectedButtons,
    required this.player,
    required this.onChangeBackground,
    required this.onToggleIcon,
    required this.onToggleBlur,
    this.extraActions,
    this.profileNames,
    this.profileBackgrounds,
    this.activeProfileName,
    this.onSelectProfile,
    this.onClearProfile,
    this.onDeleteProfile,
    this.showProfileActionInExtraActions = false,
  });

  final Function setButtons;
  final List selectedButtons;
  final Player player;
  final void Function(String background) onChangeBackground;
  final VoidCallback onToggleIcon;
  final VoidCallback onToggleBlur;
  final List<Widget>? extraActions;
  final List<String>? profileNames;
  final Map<String, String?>? profileBackgrounds;
  final String? activeProfileName;
  final void Function(String name)? onSelectProfile;
  final VoidCallback? onClearProfile;
  final void Function(String name)? onDeleteProfile;
  final bool showProfileActionInExtraActions;

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

enum _SettingsPanel {
  main,
  background,
  profiles,
}

class _SettingsWidgetState extends State<SettingsWidget>
    with SingleTickerProviderStateMixin {
  _SettingsPanel _panel = _SettingsPanel.main;

  void _openPanel(_SettingsPanel panel) {
    if (_panel != _SettingsPanel.main) return;
    setState(() {
      _panel = panel;
      _animationController.forward();
    });
  }

  void _closePanel() {
    if (_panel == _SettingsPanel.main) return;
    _animationController.reverse();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() {
        _panel = _SettingsPanel.main;
      });
    });
  }

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      lowerBound: 0,
      upperBound: 1,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 40, top: 10, right: 40),
      child: _panel == _SettingsPanel.background
          ? AnimatedBuilder(
              animation: _animationController,
              child: BackgroundWidget(
                onBack: _closePanel,
                player: widget.player,
                onChangeBackground: widget.onChangeBackground,
                onToggleIcon: widget.onToggleIcon,
                onToggleBlur: widget.onToggleBlur,
              ),
              builder: (context, child) => SlideTransition(
                position: Tween(
                        begin: const Offset(1, 0), end: const Offset(0, 0))
                    .animate(CurvedAnimation(
                        parent: _animationController, curve: Curves.easeInOut)),
                child: child,
              ))
          : _panel == _SettingsPanel.profiles
          ? AnimatedBuilder(
              animation: _animationController,
                  child: ProfileWidget(
                    profileNames: widget.profileNames ?? const [],
                    activeProfileName: widget.activeProfileName,
                    onSelectProfile: (name) {
                      widget.onSelectProfile?.call(name);
                      _closePanel();
                    },
                    onBack: _closePanel,
                    onClearProfile: () {
                      widget.onClearProfile?.call();
                      _closePanel();
                    },
                    onDeleteProfile: widget.onDeleteProfile,
                    profileBackgrounds: widget.profileBackgrounds,
                  ),
              builder: (context, child) => SlideTransition(
                    position: Tween(
                            begin: const Offset(1, 0), end: const Offset(0, 0))
                        .animate(CurvedAnimation(
                            parent: _animationController,
                            curve: Curves.easeInOut)),
                    child: child,
                  ))
              : ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: ListTile(
                        title: const Text("Select background"),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _openPanel(_SettingsPanel.background),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var button in allButtons)
                          CheckboxListTile(
                              title: Text(getButtonText(button)),
                              value: widget.selectedButtons.contains(button),
                              onChanged: (_) => widget.setButtons(button))
                      ],
                    ),
                    if (widget.showProfileActionInExtraActions &&
                        (widget.profileNames ?? const []).isNotEmpty &&
                        widget.onSelectProfile != null)
                      ListTile(
                        leading: _profileLeading(
                          widget.activeProfileName,
                          profileBackgrounds: widget.profileBackgrounds,
                        ),
                        title: const Text("Select profile"),
                        subtitle: widget.activeProfileName == null
                            ? null
                            : Text(widget.activeProfileName!),
                        onTap: () => _openPanel(_SettingsPanel.profiles),
                      ),
                    if (widget.extraActions != null) ...widget.extraActions!,
                  ],
                ),
    );
  }
}

Widget _profileLeading(String? profileName,
    {Map<String, String?>? profileBackgrounds, bool isNone = false}) {
  if (isNone || profileName == null) {
    return const Icon(Icons.person_outline);
  }
  final background = profileBackgrounds?[profileName];
  if (background == null) {
    return const Icon(Icons.person_outline);
  }
  return Container(
    width: 28,
    height: 28,
    decoration: BoxDecoration(
      color: isMonoColor(background) ? getBackgroundColor(background) : Colors.black12,
      borderRadius: BorderRadius.circular(6),
    ),
    padding: const EdgeInsets.all(2),
    child: Image.asset(getImage(background)),
  );
}

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({
    super.key,
    required this.onBack,
    required this.player,
    required this.onChangeBackground,
    required this.onToggleIcon,
    required this.onToggleBlur,
  });

  final VoidCallback onBack;
  final Player player;
  final void Function(String background) onChangeBackground;
  final VoidCallback onToggleIcon;
  final VoidCallback onToggleBlur;

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Back',
            ),
          ],
        ),
        CheckboxListTile(
            title: const Text("Show player icons"),
            value: player.icon,
            onChanged: (_) => onToggleIcon()),
        CheckboxListTile(
            title: const Text("Blurred background"),
            value: player.blur,
            onChanged: (_) => onToggleBlur()),
        SizedBox(
          height: 50,
          child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (String button in monoBackgrounds)
                  Container(
                    decoration: BoxDecoration(color: getBackgroundColor(button)),
                    margin: const EdgeInsets.only(right: 10),
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: IconButton(
                        onPressed: () => onChangeBackground(button),
                        icon: Image.asset(getImage(button)),
                      ),
                    ),
                  )
              ]),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 50,
          child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (String button in dualBackgrounds)
                  Container(
                    decoration: BoxDecoration(gradient: getGradient(button, player)),
                    margin: const EdgeInsets.only(right: 10),
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: IconButton(
                        onPressed: () => onChangeBackground(button),
                        icon: Image.asset(getImage(button)),
                      ),
                    ),
                  )
              ]),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 50,
          child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (String button in trioBackgrounds)
                  Container(
                    decoration: BoxDecoration(gradient: getGradient(button, player)),
                    margin: const EdgeInsets.only(right: 10),
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: IconButton(
                        onPressed: () => onChangeBackground(button),
                        icon: Image.asset(getImage(button)),
                      ),
                    ),
                  )
              ]),
        ),
      ],
    );
  }
}

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({
    super.key,
    required this.profileNames,
    required this.activeProfileName,
    required this.onSelectProfile,
    required this.onBack,
    required this.onClearProfile,
    required this.onDeleteProfile,
    this.profileBackgrounds,
  });

  final List<String> profileNames;
  final String? activeProfileName;
  final void Function(String name) onSelectProfile;
  final VoidCallback onBack;
  final VoidCallback onClearProfile;
  final void Function(String name)? onDeleteProfile;
  final Map<String, String?>? profileBackgrounds;

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Back',
            ),
          ],
        ),
        const SizedBox(height: 8),
        ListTile(
          leading: _profileLeading(null, isNone: true),
          title: const Text('None'),
          trailing: activeProfileName == null ? const Icon(Icons.check) : null,
          onTap: onClearProfile,
        ),
        for (final name in profileNames)
          ListTile(
            title: Text(name),
            leading: _profileLeading(
              name,
              profileBackgrounds: profileBackgrounds,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (activeProfileName == name)
                  const Icon(Icons.check, color: Colors.green),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.red.shade800),
                  onPressed:
                      onDeleteProfile == null ? null : () => onDeleteProfile!(name),
                  tooltip: 'Delete',
                ),
              ],
            ),
            onTap: () => onSelectProfile(name),
          ),
      ],
    );
  }
}
