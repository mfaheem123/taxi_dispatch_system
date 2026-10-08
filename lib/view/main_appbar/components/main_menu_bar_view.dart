import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../component/color.dart';
import '../menu/app_menu_item.dart';

/// The shell's menu bar — our own, built on Flutter's [MenuAnchor].
///
/// Mouse: works as before — hovering a top menu opens it, and moving the
/// pointer away (off the button and its pop-ups) closes it.
/// Touch (iPad / phone browser): tap a top menu to open it, tap an entry to
/// run it — the menu closes on that tap. Tapping anywhere else closes it too.
///
/// The items themselves are built in `menu/main_menu.dart`.
class MainMenuBarView extends StatelessWidget {
  const MainMenuBarView({super.key, required this.menus});

  final List<AppMenuItem> menus;

  /// Same as the old package bar.
  static const double height = 45;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: DynamicColors.primaryClr,
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [for (final m in menus) _TopMenu(menu: m)],
        ),
      ),
    );
  }
}

/// One top-level menu: its button in the bar and its pop-up.
class _TopMenu extends StatefulWidget {
  const _TopMenu({required this.menu});

  final AppMenuItem menu;

  @override
  State<_TopMenu> createState() => _TopMenuState();
}

class _TopMenuState extends State<_TopMenu> {
  /// The top menu that is open right now, so opening another closes it.
  static _TopMenuState? _openMenu;

  final MenuController _controller = MenuController();

  /// Pending close after the mouse left — cancelled if it comes back over the
  /// button or any of the pop-ups (the gap between them is crossed in time).
  Timer? _closeTimer;

  bool _hovered = false;

  @override
  void dispose() {
    _closeTimer?.cancel();
    if (identical(_openMenu, this)) _openMenu = null;
    super.dispose();
  }

  void _open() {
    _closeTimer?.cancel();
    if (_controller.isOpen) return;
    if (!identical(_openMenu, this)) _openMenu?._close();
    _openMenu = this;
    _controller.open();
  }

  void _close() {
    _closeTimer?.cancel();
    if (_controller.isOpen) _controller.close();
  }

  void _toggle() => _controller.isOpen ? _close() : _open();

  // ---- mouse only: touch has no enter / exit ----

  void _mouseEnter(PointerEnterEvent e) {
    if (e.kind != PointerDeviceKind.mouse) return;
    setState(() => _hovered = true);
    if (widget.menu.hasChildren) _open();
  }

  void _mouseExit(PointerExitEvent e) {
    if (e.kind != PointerDeviceKind.mouse) return;
    setState(() => _hovered = false);
    _scheduleClose();
  }

  void _scheduleClose() {
    _closeTimer?.cancel();
    _closeTimer = Timer(const Duration(milliseconds: 250), _close);
  }

  /// Wraps a pop-up panel so the mouse being over it keeps the menu open.
  Widget _keepOpenWhileHovered(Widget child) => MouseRegion(
        onEnter: (e) {
          if (e.kind == PointerDeviceKind.mouse) _closeTimer?.cancel();
        },
        onExit: (e) {
          if (e.kind == PointerDeviceKind.mouse) _scheduleClose();
        },
        child: child,
      );

  List<Widget> _buildItems(List<AppMenuItem> items) => [
        for (final item in items)
          item.hasChildren
              ? SubmenuButton(
                  style: _itemStyle,
                  menuStyle: _popupStyle,
                  menuChildren: [
                    _keepOpenWhileHovered(Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: _buildItems(item.children!),
                    )),
                  ],
                  child: Text(item.title),
                )
              : MenuItemButton(
                  style: _itemStyle,
                  // Closes the whole menu, then runs the entry — on a tap as
                  // well as a click.
                  onPressed: item.onTap ?? () {},
                  child: Text(item.title),
                ),
      ];

  @override
  Widget build(BuildContext context) {
    final menu = widget.menu;
    return MenuAnchor(
      controller: _controller,
      style: _popupStyle,
      alignmentOffset: const Offset(0, 0),
      onClose: () {
        if (identical(_openMenu, this)) _openMenu = null;
        if (mounted) setState(() {});
      },
      menuChildren: [
        _keepOpenWhileHovered(Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildItems(menu.children ?? const []),
        )),
      ],
      builder: (context, controller, _) {
        final active = _hovered || controller.isOpen;
        return MouseRegion(
          onEnter: _mouseEnter,
          onExit: _mouseExit,
          child: InkWell(
            onTap: menu.hasChildren ? _toggle : menu.onTap,
            child: Container(
              height: MainMenuBarView.height,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: active ? Colors.white : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                menu.title,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// White rounded pop-up, as before.
const MenuStyle _popupStyle = MenuStyle(
  backgroundColor: WidgetStatePropertyAll(Colors.white),
  surfaceTintColor: WidgetStatePropertyAll(Colors.white),
  padding: WidgetStatePropertyAll(EdgeInsets.all(3)),
  shape: WidgetStatePropertyAll(
    RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
  ),
);

/// Entries: black on white, white on black when hovered / focused / pressed —
/// the same colours the package bar used.
final ButtonStyle _itemStyle = ButtonStyle(
  padding: const WidgetStatePropertyAll(
      EdgeInsets.symmetric(horizontal: 10, vertical: 10)),
  minimumSize: const WidgetStatePropertyAll(Size(180, 0)),
  textStyle: const WidgetStatePropertyAll(TextStyle(fontSize: 14)),
  shape: const WidgetStatePropertyAll(
    RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
  ),
  backgroundColor: WidgetStateProperty.resolveWith((s) =>
      _isActive(s) ? Colors.black : Colors.white),
  foregroundColor: WidgetStateProperty.resolveWith((s) =>
      _isActive(s) ? Colors.white : Colors.black),
  iconColor: WidgetStateProperty.resolveWith((s) =>
      _isActive(s) ? Colors.white : Colors.black),
  overlayColor: const WidgetStatePropertyAll(Colors.transparent),
);

bool _isActive(Set<WidgetState> s) =>
    s.contains(WidgetState.hovered) ||
    s.contains(WidgetState.focused) ||
    s.contains(WidgetState.pressed);
