part of 'bar.dart';

class _RectClipper extends CustomClipper<Rect> {
  final Rect rect;

  _RectClipper(this.rect);

  @override
  Rect getClip(Size size) => rect;

  @override
  bool shouldReclip(covariant _RectClipper oldClipper) =>
      rect != oldClipper.rect;
}

class _InfiniteBar extends StatelessWidget {
  final List<Widget> children;
  final int visibleItemCount;
  final double position;
  final int centerPosition;
  final Size size;

  const _InfiniteBar({
    Key? key,
    required this.children,
    required this.size,
    required this.visibleItemCount,
    this.position = -1,
    this.centerPosition = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLengthTwo = children.length == 2;
    final position = (-this.position + centerPosition) % children.length -
        (isLengthTwo ? 0.5 : 0.0);
    final isLockedIn = this.position % 1 == 0;
    final overflowItemCount = position.ceil() + (isLockedIn ? 1 : 0);
    final nonIntOffset = position - position.floor();
    final itemHeight = size.height / visibleItemCount;

    List<Widget> secondCategoryChildren = [];
    List<Widget> thirdCategoryChildren = [];

    for (int i = 0; i < overflowItemCount; i++) {
      final verticalPosition = (i + nonIntOffset - 1) * itemHeight;
      final halfHeight = size.height / 2;
      final distanceFromCenter =
          (min((verticalPosition - halfHeight).abs(), halfHeight));
      final scale = 1 - ((distanceFromCenter / halfHeight) * 0.8);

      secondCategoryChildren.add(
        Transform.translate(
          offset: Offset(0, verticalPosition),
          child: Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: scale,
              child: SizedBox(
                width: size.width,
                height: itemHeight,
                child: children[(i -
                        overflowItemCount -
                        (isLengthTwo && isLockedIn ? 1 : 0)) %
                    children.length],
              ),
            ),
          ),
        ),
      );
    }

    for (int i = 0; i < children.length; i++) {
      final verticalPosition = (position + i) * itemHeight;
      final halfHeight = size.height / 2;
      final distanceFromCenter =
          (min((verticalPosition - halfHeight).abs(), halfHeight));
      final scale = 1 - ((distanceFromCenter / halfHeight) * 0.8);

      thirdCategoryChildren.add(
        Transform.translate(
          offset: Offset(0, verticalPosition),
          child: Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: scale,
              child: SizedBox(
                width: size.width,
                height: itemHeight,
                child: children[i],
              ),
            ),
          ),
        ),
      );
    }

    return ClipRect(
      clipper: _RectClipper(Rect.fromLTWH(0, 0, size.width, size.height)),
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            if (isLengthTwo)
              Transform.translate(
                offset: Offset(0, (position + children.length) * itemHeight),
                child: SizedBox(
                  width: size.width,
                  height: itemHeight,
                  child: children[0],
                ),
              ),
            ...secondCategoryChildren,
            ...thirdCategoryChildren,
          ],
        ),
      ),
    );
  }
}
