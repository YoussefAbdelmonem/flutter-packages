library custom_rating_bar;

import 'package:flutter/material.dart';

/// Creates rating bar.
///
/// The [onRatingChanged], [filledIcon] & [emptyIcon] must not be null.
class RatingBar extends StatefulWidget {
  /// Default constructor for [RatingBar].
  const RatingBar({
    super.key,
    required this.fillWidget,
    required this.emptyWidget,
    required this.onRatingChanged,
    this.filledIcon,
    this.emptyIcon,
    this.initialRating = 0.0,
    this.maxRating = 5,
    this.halfFilledIcon,
    this.isHalfAllowed = false,
    this.alignment = Alignment.centerLeft,
    this.direction = Axis.horizontal,
    this.filledColor = Colors.amber,
    this.emptyColor = Colors.grey,
    this.halfFilledColor = Colors.amber,
    this.size = 32,
  })  : _readOnly = false,
        assert(
          !isHalfAllowed || halfFilledIcon != null,
          'Please provide halfFilledIcon if isHalfAllowed is true.',
        );

  /// Creates read only rating bar.
  ///
  /// The [filledIcon] & [emptyIcon] must not be null.
  const RatingBar.readOnly({
    Key? key,
    required this.filledIcon,
    required this.emptyIcon,
    this.fillWidget,
    this.emptyWidget,
    this.maxRating = 5,
    this.halfFilledIcon,
    this.isHalfAllowed = false,
    this.alignment = Alignment.centerLeft,
    this.direction = Axis.horizontal,
    this.initialRating = 0.0,
    this.filledColor = Colors.amber,
    this.emptyColor = Colors.grey,
    this.halfFilledColor = Colors.amber,
    this.size = 32,
  })  : _readOnly = true,
        onRatingChanged = null,
        assert(
          !isHalfAllowed || halfFilledIcon != null,
          'Please provide halfFilledIcon if isHalfAllowed is true.',
        ),
        super(key: key);

  /// Icon used for filled part of the rating bar.
  final IconData ?filledIcon;

  final Widget? fillWidget;
    final Widget ?emptyWidget;


  /// Icon used for empty part of the rating bar.
  final IconData ?emptyIcon;

  /// Max rating value.
  final int maxRating;

  /// Icon used for half filled part of the rating bar.
  final IconData? halfFilledIcon;

  /// Callback for rating changes.
  final void Function(double)? onRatingChanged;

  /// Initial rating value.
  final double initialRating;

  /// Color used for filled part of the rating bar.
  final Color filledColor;

  /// Color used for empty part of the rating bar.
  final Color emptyColor;

  /// Color used for half filled part of the rating bar.
  final Color halfFilledColor;

  /// If true, supports half filled icons.
  final bool isHalfAllowed;

  /// Alignment of the rating bar.
  final Alignment alignment;

  /// Direction of the rating bar.
  final Axis direction;

  /// Size of the rating bar.
  final double size;

  /// If true, the rating bar is read only.
  final bool _readOnly;

  @override
  State<RatingBar> createState() => _RatingBarState();
}

class _RatingBarState extends State<RatingBar> {
  double? _currentRating;

  @override
  void initState() {
    super.initState();
    if (widget.isHalfAllowed) {
      _currentRating = widget.initialRating;
    } else {
      _currentRating = widget.initialRating.roundToDouble();
    }
  }

  @override
  Widget build(BuildContext context) => _buildRatingBar();

  Widget _buildRatingBar() => Align(
        alignment: widget.alignment,
        child: _buildDirectionWrapper(
          List.generate(
            widget.maxRating,
            (index) {
              final iconPosition = index + 1;
              return _buildIcon(iconPosition);
            },
          ),
        ),
      );

  Widget _buildDirectionWrapper(List<Widget> children) {
    if (widget.direction == Axis.vertical) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  Widget _buildIcon(int position) {
    if (widget._readOnly) return _buildIconView(position);

    return GestureDetector(
      child: _buildIconView(position),
      onTap: () {
        setState(() => _currentRating = position.toDouble());
        final currentRating = _currentRating;
        if (currentRating == null) return;
        widget.onRatingChanged?.call(currentRating);
      },
    );
  }

  Widget _buildIconView(int position) {
    final halfFilledIcon = widget.halfFilledIcon;

    Widget? iconData;
    Color color;
    double rating;

    if (widget._readOnly) {
      if (widget.isHalfAllowed) {
        rating = widget.initialRating;
      } else {
        rating = widget.initialRating.roundToDouble();
      }
    } else {
      final currentRating = _currentRating;
      if (currentRating == null) throw AssertionError('rating can\'t null');
      rating = currentRating;
    }
    if (position > rating + 0.5) {
      iconData = widget.emptyWidget??Icon(widget.emptyIcon);
      color = widget.emptyColor;
    } else if (position == rating + 0.5 && halfFilledIcon != null) {
      iconData = Icon(widget.halfFilledIcon);
      color = widget.halfFilledColor;
    } else {
      iconData = widget.fillWidget;
      color = widget.filledColor;
    }
    return Container(width:widget.size,color:color, child:iconData);
  }
}
