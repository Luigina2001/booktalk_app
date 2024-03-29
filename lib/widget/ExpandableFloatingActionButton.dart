import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ExpandableFloatingActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final ScrollController scrollController;
  final void Function() onPressed;

  const ExpandableFloatingActionButton(
      {required this.icon,
      required this.label,
      required this.scrollController,
      required this.onPressed});

  @override
  State<ExpandableFloatingActionButton> createState() =>
      _ExpandableFloatingActionButtonState();
}

class _ExpandableFloatingActionButtonState
    extends State<ExpandableFloatingActionButton> {
  bool _extended = true;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_scrollListener);
  }


  void _scrollListener() {
    bool maxScrollReached = widget.scrollController.position.maxScrollExtent ==
        widget.scrollController.position.pixels;
    bool scrollUp = widget.scrollController.position.userScrollDirection ==
        ScrollDirection.forward;

    setState(() => _extended = maxScrollReached || scrollUp);
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0), 
      ),
      extendedIconLabelSpacing: _extended ? 10 : 0,
      extendedPadding:
          _extended ? null : const EdgeInsets.symmetric(horizontal: 15),
      onPressed: widget.onPressed,
      icon: Icon(widget.icon, color: Colors.white,),
      backgroundColor: Color(0xFF0097b2),
      label: AnimatedSize(
        duration: const Duration(milliseconds: 200),
        child: _extended ? Text(widget.label, style: TextStyle(color: Colors.white, fontSize: 16)) : Container(),
      ),
    );
  }
}