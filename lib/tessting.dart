import 'package:flutter/material.dart';

class DynamicStepperScreen extends StatefulWidget {
  @override
  _DynamicStepperScreenState createState() => _DynamicStepperScreenState();
}

class _DynamicStepperScreenState extends State<DynamicStepperScreen> {
  int currentStep = 0;
  final ScrollController _scrollController = ScrollController();

  List<String> stepsData = [
    "Personal Info",
    "Address Details",
    "Upload Documents",
    "Review & Submit",
    "Address Details",
    "Upload Documents",
    "Review & Submit",
    "Address Details",
    "Upload Documents",
    "Review & Submit",
    "Review & Submit",
    "Address Details",
    "Upload Documents",
    "Review & Submit",
    "Address Details",
    "Upload Documents",
    "Review & Submit",
  ];

  void nextStep() {
    if (currentStep < stepsData.length - 1) {
      setState(() {
        currentStep++;
      });
      _scrollToTop();
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
      _scrollToTop();
    }
  }

  void jumpToStep(int index) {
    setState(() {
      currentStep = index;
    });
    _scrollToTop();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dynamic Stepper")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // 🔺 TOP ARROW
          if (currentStep > 0)
            IconButton(
              icon: Icon(Icons.arrow_upward, size: 35),
              onPressed: previousStep,
            ),

          Expanded(
            child: Theme(
              data: Theme.of(context).copyWith(
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Stepper(
                margin: EdgeInsets.zero,
                type: StepperType.horizontal, // 👈 IMPORTANT
                elevation: 0,
                controller: _scrollController,
                currentStep: currentStep,
                physics: AlwaysScrollableScrollPhysics(),
                onStepTapped: (index) {
                  jumpToStep(index);
                },
                controlsBuilder: (context, details) {
                  return SizedBox();
                },
                steps: List.generate(stepsData.length, (index) {
                  return Step(

                    title: SizedBox.shrink(),
                    content: Padding(
                      padding: EdgeInsets.symmetric(vertical: 4), // 👈 spacing kam
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          10,
                              (_) => Text(
                            "Content of ${stepsData[index]}",
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                    ),
                    isActive: currentStep >= index,
                    state: currentStep > index
                        ? StepState.complete
                        : StepState.indexed,
                  );
                }),
              ),
            ),
          ),

          // 🔻 BOTTOM ARROW
          if (currentStep < stepsData.length - 1)
            IconButton(
              icon: Icon(Icons.arrow_downward, size: 35),
              onPressed: nextStep,
            ),

          SizedBox(height: 20),
        ],
      ),
    );
  }
}