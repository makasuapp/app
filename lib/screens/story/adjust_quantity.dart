import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kitchen/screens/story/story_styles.dart';
import 'package:kitchen/services/unit_converter.dart';
import 'package:kitchen/styles.dart';
import '../common/cancel_button.dart';
import '../common/submit_button.dart';

class StoryAdjustQuantityPage extends StatefulWidget {
  final double currentServingSize;
  final String unit;

  //final bool adjustUnits;
  final void Function(double qty, String unit, BuildContext qtyViewContext)
      onSubmit;

  StoryAdjustQuantityPage({this.onSubmit, this.currentServingSize, this.unit})
      : assert(onSubmit != null);

  @override
  createState() => _StoryAdjustQuantityPageState();
}

class _StoryAdjustQuantityPageState extends State<StoryAdjustQuantityPage> {
  double _setServingSize;
  TextEditingController _controller;
  String _setUnit;

  @override
  void initState() {
    super.initState();
    this._setServingSize = (this.widget.currentServingSize != null)
        ? this.widget.currentServingSize
        : 1;
    _controller = TextEditingController(text: "${this._setServingSize}");
    if (this.widget.unit != null) {
      this._setUnit = this.widget.unit;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Adjust Quantity")),
        body: Container(
            padding: Styles.spacerPadding,
            child: Column(children: [
              Text("Adjust serving size", style: StoryStyles.storyHeaderLarge),
              _renderPickers(),
              _renderButtons(context)
            ])));
  }

  Widget _renderPickers() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _renderQtyPicker(),
        (this.widget.unit != null) ? _renderUnitPicker() : Container()
      ],
    );
  }

  Widget _renderQtyPicker() {
    return Container(
        width: 180,
        child: TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'serving size',
          ),
          onChanged: (input) {
            setState(() {
              this._setServingSize = double.tryParse(input);
            });
          },
        ));
  }

  Widget _renderUnitPicker() {
    if (weightUnits.containsKey(this._setUnit) ||
        volumeUnits.containsKey(this._setUnit)) {
      return DropdownButton<String>(
        value: this._setUnit,
        icon: StoryStyles.unitPickerIcon,
        iconSize: StoryStyles.unitPickerIconSize,
        style: TextStyle(color: StoryStyles.unitPickerTextColor),
        underline: Container(
          height: StoryStyles.unitPickerUnderlineHeight,
          color: StoryStyles.unitPickerUnderlineColor,
        ),
        items: (weightUnits.containsKey(this._setUnit))
            ? weightUnits.keys.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList()
            : volumeUnits.keys.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
        onChanged: (input) {
          setState(() {
            this._setUnit = input;
          });
        },
      );
    } else {
      return Text("${this._setUnit}");
    }
  }

  Widget _renderButtons(BuildContext context) {
    return Container(
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          CancelButton(() => Navigator.pop(context)),
          SubmitButton(() => this
              .widget
              .onSubmit(this._setServingSize, this._setUnit, context))
        ]),
        padding: Styles.spacerPadding);
  }
}
