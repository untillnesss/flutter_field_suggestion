library field_suggestion;

import 'utils.dart';
import 'styles.dart';
import 'box_controller.dart';
import 'package:flutter/material.dart';

export 'package:field_suggestion/styles.dart';
export 'package:field_suggestion/box_controller.dart';
export 'package:highlightable/highlightable.dart';

typedef SearchCallback<T> = bool Function(T item, String input);

enum OverlayPosition { top, bottom }

/// Create highly customizable, simple, and controllable autocomplete fields.
///
/// Widget Structure:
///  ╭───────╮      ╭─────────────╮
///  │ Input │╮    ╭│ Suggestions │
///  ╰───────╯│    │╰─────────────╯
///           │    │
///           │    │               Generated by
///           │  Element         search algorithm
///           │    │              ╭──────────╮
///           ▼    ▼          ╭──▶│ Matchers │─╮
///     ╭──────────────────╮  │   ╰──────────╯ │  ╭──────────────╮
///     │ Search Algorithm │──╯                ╰─▶│ Item Builder │
///     ╰──────────────────╯                      ╰──────────────╯
///      Passes input and suggestion's             ... Passes context and
///      element to search function.               index of "matcher in suggestions".
///      So, as a result matchers                  suggestion item widget.
///      fill be filled appropriate
///      to algorithm
///
/// ──────────────────────────────────
///
/// Basic usage example:
/// ```dart
/// FieldSuggestion(
///    textController: _textController,
///    suggestions: suggestions,
///    search: (item, input) {
///       return item.toString().contains(input);
///    },
///    itemBuilder: (context, index) {
///       return Card(...);
///    },
///    ...
/// )
/// ```
///
/// ──────────────────────────────────
///
/// For mode details about usage refer to:
///  > https://github.com/theiskaa/field_suggestion/wiki
class FieldSuggestion<T> extends StatefulWidget {
  /// Suggestion widget builder.
  ///
  /// Example:
  /// ```dart
  /// FieldSuggestion(
  ///   itemBuilder: (context, index) {
  ///    return Card( // Fill the widget the way you want.
  ///       ...
  ///    );
  ///   }
  /// )
  /// ```
  final Widget Function(BuildContext, int) itemBuilder;

  /// Separator builder for suggestions list.
  ///
  /// Example:
  /// ```dart
  /// FieldSuggestion(
  ///   separatorBuilder: (context, index) {
  ///    return const Divider();
  ///   }
  ///   ...
  /// )
  /// ```
  final Widget Function(BuildContext, int)? separatorBuilder;

  /// Main text editing controller.
  ///
  /// Widget listens controller and calls appropriate functionalities
  /// to execute search algorithm and fill matchers.
  final TextEditingController textController;

  /// Suggestions list of widget.
  ///
  /// Don't forget writing search algorithm appropriate to suggestions type.
  final List<T> suggestions;

  /// Search algorithm of widget. Basic example: (check if item contains input) ```dart
  /// search: (item, input) => item.toString().contains(input)
  /// ```
  ///
  /// Object suggestions example:
  /// ```dart
  /// search: (item, input) => item.field.toString().contains(input)
  /// ```
  final SearchCallback<T> search;

  /// Controller object of suggestions box.
  ///
  /// Can bu used to [open], [close] and even [refresh] content of suggestion box.
  ///
  /// ```dart
  /// class ExternalControlExample extends StatelessWidget {
  ///   final _boxController = BoxController();
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return GestureDetector(
  ///       onTap: () => _boxController.close?.call(),
  ///       child: Scaffold(
  ///         body: Center(
  ///           child: FieldSuggestion(
  ///             boxController: _boxController,
  ///             ...
  ///           ),
  ///         ),
  ///       ),
  ///     );
  ///   }
  /// }
  /// ```
  final BoxController? boxController;

  /// Suggestion's box style.
  ///
  /// If unset, defaults to the ─▶ [BoxStyle.defaultStyle].
  final BoxStyle? boxStyle;

  /// Text input decoration of input field.
  final InputDecoration? inputDecoration;

  /// Text input type of input field.
  final TextInputType? inputType;

  /// Focus node of input field.
  final FocusNode? focusNode;

  /// Max lines of the input field.
  final int? maxLines;

  /// Text style of input field.
  final TextStyle? inputStyle;

  /// Field's input validator.
  final FormFieldValidator<String>? validator;

  /// The width(thickness) of field's cursor.
  final double cursorWidth;

  /// The height(length) of field's cursor.
  final double? cursorHeight;

  /// The border radius of field's cursor.
  final Radius? cursorRadius;

  /// The color of field's cursor.
  final Color? cursorColor;

  /// The appearance of the keyboard.
  /// Honored only IOS devices, 'cause Apple is awesome.
  ///
  /// If unset, defaults to the brightness of [ThemeData.primaryColorBrightness].
  final Brightness? keyboardAppearance;

  /// Scroll controller for the suggestions list.
  final ScrollController? scrollController;

  /// Spacer is the value of size between field and box.
  ///
  /// If unset, defaults to the ─▶ [5.0].
  final double spacer;

  /// Sets suggestion box's height by item count.
  ///
  /// If [sizeByItem] equals [1] ─▶ x * 1.0
  /// ...
  /// If [sizeByItem] equals [3] ─▶ x * 3.0
  final int? sizeByItem;

  /// Padding of suggestion box's sub widgets.
  final EdgeInsets padding;

  /// Boolean to disable/enable opacity animation of [SuggestionBox].
  ///
  /// If unset, defaults to the ─▶ [false].
  final bool wOpacityAnimation;

  /// Boolean to enable/disable slide animation of [SuggestionBox].
  ///
  /// If unset, defaults to the ─▶ [false].
  final bool wSlideAnimation;

  /// Duration of suggestion box animation.
  ///
  /// If unset, defaults to the ─▶ [400 milliseconds].
  final Duration animationDuration;

  /// Rotation slide to determine tween offset of slide animation.
  ///
  /// **Right to left [RTL], Left to right [LTR], Bottom to up [BTU], Up to down [UTD].**
  final SlideStyle slideStyle;

  /// Tween offset of slide animation.
  ///
  /// When you use [slideOffset], then [slideStyle] automatically would be disabled.
  final Tween<Offset>? slideOffset;

  /// Curve for box slide animation.
  ///
  /// If unset, defaults to the ─▶ [Curves.decelerate].
  final Curve slideCurve;

  final OverlayPosition overlayPosition;

  const FieldSuggestion({
    Key? key,
    required this.itemBuilder,
    this.separatorBuilder,
    required this.textController,
    required this.suggestions,
    required this.search,
    this.boxController,
    this.boxStyle,
    this.inputDecoration,
    this.inputType,
    this.focusNode,
    this.maxLines,
    this.inputStyle,
    this.validator,
    this.cursorWidth = 2,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.scrollController,
    this.spacer = 5.0,
    this.sizeByItem,
    this.padding = const EdgeInsets.all(12),
    this.wOpacityAnimation = false,
    this.wSlideAnimation = false,
    this.animationDuration = const Duration(milliseconds: 400),
    this.slideStyle = SlideStyle.RTL,
    this.slideOffset,
    this.slideCurve = Curves.decelerate,
    this.overlayPosition = OverlayPosition.bottom,
  }) : super(key: key);

  @override
  _FieldSuggestionState createState() =>
      _FieldSuggestionState<T>(boxController);
}

class _FieldSuggestionState<T> extends State<FieldSuggestion<T>>
    with TickerProviderStateMixin {
  // Initialize BoxController closures.
  _FieldSuggestionState(BoxController? _boxController) {
    if (_boxController == null) return;

    _boxController.close = closeBox;
    _boxController.open = openBox;
    _boxController.refresh = refresh;
  }

  // "CURRENT" matchers collection ─▶ generated by [_textListener] method.
  List matchers = <T>[];

  // "CURRENT" active overlay ─▶ represents suggestion box.
  OverlayEntry? _overlayEntry;

  // The collection of active overlays.
  final List<dynamic> _overlaysList = [];

  // Widget has two main parts ─▶ Input Field and Suggestion Box.
  // the whole widget uses layer link to connect that two parts.
  // It's bridge between suggestion box and input field.
  final LayerLink _layerLink = LayerLink();

  // Suggestion box's active style.
  // As default it'd be setted to ─▶ [BoxStyle.defaultStyle].
  BoxStyle? boxStyle;

  late Animation<double> _opacity;
  late Animation<Offset>? _slide;
  late AnimationController _animationController;

  @override
  void dispose() {
    widget.textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.textController.addListener(_textListener);

    // Initialize animations, if one of the animation was enabled.
    if (widget.wOpacityAnimation || widget.wSlideAnimation) {
      _animationController = AnimationController(
        vsync: this,
        duration: widget.animationDuration,
      );

      if (widget.wOpacityAnimation) {
        _opacity = Tween<double>(
          begin: 0,
          end: 1,
        ).animate(_animationController);
      }

      // Set slide animations if it was enabled.
      if (widget.wSlideAnimation) {
        _slide = FieldAnimationStyle.setBoxAnimation(
          slideStyle: widget.slideStyle,
          animationController: _animationController,
          slideTweenOffset: widget.slideOffset,
          slideCurve: widget.slideCurve,
        );
      }
    }
  }

  // Searches [input] in [suggestions] by [search] method.
  void _textListener() {
    final input = widget.textController.text;

    // Should close box if input is empty.
    if (input.isEmpty) return closeBox();

    matchers = widget.suggestions.where((i) {
      return widget.search(i, input.toString());
    }).toList();

    return (matchers.isEmpty) ? closeBox() : openBox();
  }

  // A set-state wrapper to avoid [setState after dispose] error.
  void _mountedSetState(void Function() fn) {
    if (this.mounted) setState(fn);
  }

  // A external callback function used to refresh content-state of box.
  // Uses clojure set-state and [_textListener] method to update the state.
  void refresh() {
    _mountedSetState(() {});
    _textListener();
  }

  // Method of opening suggestion box.
  // Could be used externally.
  void openBox() {
    // Clear current overlay.
    if (_overlayEntry != null && _overlaysList.isNotEmpty) {
      _overlayEntry!.remove();
      _mountedSetState(() => _overlayEntry = null);
    }

    // Generate a new one.
    _generateOverlay(context);
    if (widget.wOpacityAnimation || widget.wSlideAnimation) {
      _animationController.forward();
    }
  }

  // Method of closing suggestion box.
  // Could be used externally.
  void closeBox() {
    if (!(_overlayEntry != null && _overlaysList.isNotEmpty)) return;

    _overlayEntry!.remove();
    if (widget.wOpacityAnimation || widget.wSlideAnimation) {
      _animationController.reverse();
    }

    _mountedSetState(() => _overlayEntry = null);
  }

  // Creates the suggestion box (overlay entry).
  // Appends it to the overlay state and state overlay management list.
  void _generateOverlay(BuildContext context) {
    final _state = Overlay.of(context)!;
    final _size = (context.findRenderObject() as RenderBox).size;

    // Re-append overlay entry.
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: _size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: this.widget.overlayPosition == OverlayPosition.bottom
              ? Offset(0.0, _size.height + widget.spacer)
              : Offset(0.0, 0 - _size.height - widget.spacer),
          child: _buildSuggestionBox(context),
        ),
      ),
    );

    // Append refreshing functionality of overlay to the animation controller
    // if one of the animation property was enabled.
    if (widget.wOpacityAnimation || widget.wSlideAnimation) {
      _animationController.addListener(() => _state.setState(() {}));
    }

    // Insert generated overlay entry to overlay state.
    _state.insert(_overlayEntry!);

    // Add the overlay entry to cleared list.
    _overlaysList.clear();
    _overlaysList.add(_overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    boxStyle = widget.boxStyle ?? BoxStyle.defaultStyle(context);

    // Layer linking adds normal widget's behaviour to overlay widget.
    // It follows [TextField] every time, and behaves as a normal non-hidable widget.
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        keyboardType: widget.inputType,
        focusNode: widget.focusNode,
        controller: widget.textController,
        maxLines: widget.maxLines,
        decoration: widget.inputDecoration,
        style: widget.inputStyle,
        validator: widget.validator,
        cursorWidth: widget.cursorWidth,
        cursorHeight: widget.cursorHeight,
        cursorRadius: widget.cursorRadius,
        cursorColor: widget.cursorColor,
        keyboardAppearance: widget.keyboardAppearance,
      ),
    );
  }

  // Generates suggestion box widget for overlay entry.
  // Used in [_generateOverlay] method.
  Widget _buildSuggestionBox(BuildContext context) {
    final _box = Opacity(
      opacity: (widget.wOpacityAnimation) ? _opacity.value : 1,
      child: Container(
        padding: widget.padding,
        decoration: BoxDecoration(
          color: boxStyle?.backgroundColor,
          borderRadius: boxStyle?.borderRadius,
          boxShadow: widget.boxStyle?.boxShadow,
          border: widget.boxStyle?.border,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: Utils.maxBoxHeight(
              matchers: matchers.length,
              sizeByItem: widget.sizeByItem,
            ),
          ),
          child: ListView.separated(
            controller: widget.scrollController,
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: matchers.length,
            separatorBuilder:
                widget.separatorBuilder ?? (_, __) => const SizedBox.shrink(),
            itemBuilder: (context, index) {
              // Get the index of matcher[i] in suggestions list.
              final matcherIndex = widget.suggestions.indexOf(matchers[index]);
              return widget.itemBuilder(context, matcherIndex);
            },
          ),
        ),
      ),
    );

    // Determine box widget appropriate to slide animation.
    final boxWidget = !widget.wSlideAnimation
        ? _box
        : SlideTransition(position: _slide!, child: _box);

    return Material(
      color: boxStyle?.backgroundColor,
      borderRadius: boxStyle?.borderRadius,
      elevation: 0,
      child: boxWidget,
    );
  }
}
