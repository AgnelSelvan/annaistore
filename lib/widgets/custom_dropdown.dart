import 'package:annaistore/utils/universal_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class CustomDropdown extends StatefulWidget {
  final String text;

  const CustomDropdown({Key key, this.text}) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  GlobalKey actionKey;
  double height, width, xPosition, yPosition;
  bool isDropdownOpened = false;
  OverlayEntry floatingDropdown;

  @override
  void initState() {
    super.initState();
    actionKey = LabeledGlobalKey(widget.text);
  }

  void findDropDownData() {
    RenderBox renderBox = actionKey.currentContext.findRenderObject();
    height = renderBox.size.height;
    width = renderBox.size.width;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    xPosition = offset.dx;
    yPosition = offset.dy;
  }

  OverlayEntry _createFloatingDropdown() {
    return OverlayEntry(builder: (context) {
      return Positioned(
        left: xPosition,
        top: yPosition + height,
        height: 4 * height + 40,
        width: width,
        child: DropDown(
          itemHeight: height,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: actionKey,
      onTap: () {
        setState(() {
          if (isDropdownOpened) {
            floatingDropdown.remove();
          } else {
            findDropDownData();
            floatingDropdown = _createFloatingDropdown();
            Overlay.of(context).insert(floatingDropdown);
          }
          isDropdownOpened = !isDropdownOpened;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.yellow[100],
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: <Widget>[
            Text(
              widget.text,
              style: TextStyle(
                  color: Variables.blackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            Spacer(),
            Icon(
              isDropdownOpened ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: Variables.blackColor,
            )
          ],
        ),
      ),
    );
  }
}

class DropDown extends StatelessWidget {
  final double itemHeight;

  const DropDown({Key key, this.itemHeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 5),
        Align(
          alignment: Alignment(-0.85, 0),
          child: ClipPath(
            clipper: ArrowClipper(),
            child: Container(
              height: 20,
              width: 30,
              decoration: BoxDecoration(color: Colors.yellow.shade100),
            ),
          ),
        ),
        Material(
          elevation: 10,
          shape: ArrowShape(),
          child: Container(
            height: 4 * itemHeight,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: Column(
              children: <Widget>[
                DropDownItem(
                    text: 'Thread', icon: Icons.theaters, isSelected: null),
                DropDownItem(
                    text: 'Canvas', icon: Ionicons.ios_paper, isSelected: null),
                DropDownItem(
                    text: 'Rolls', icon: Icons.camera_roll, isSelected: null),
                DropDownItem(
                    text: 'Laice', icon: Icons.camera_roll, isSelected: null),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class ArrowShape extends ShapeBorder {
  @override
  EdgeInsetsGeometry get dimensions => throw UnimplementedError();

  @override
  Path getInnerPath(Rect rrrect, {TextDirection textDirection}) {
    throw UnimplementedError();
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    return getClip(rect.size);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {}

  @override
  ShapeBorder scale(double t) {
    throw UnimplementedError();
  }

  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);

    return path;
  }
}

class DropDownItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool isSelected;

  const DropDownItem({
    Key key,
    @required this.text,
    @required this.icon,
    @required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(text);
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 2,
        decoration: BoxDecoration(
          color: Colors.yellow[100],
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: <Widget>[
            Text(
              text,
              style: TextStyle(
                  color: Variables.blackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            Spacer(),
            Icon(
              icon,
              color: Variables.blackColor,
            )
          ],
        ),
      ),
    );
  }
}

class ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
