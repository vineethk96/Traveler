import 'package:flutter/material.dart';

class AddPlacePage extends StatelessWidget {
  const AddPlacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Add Place'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(),
            AddPlaceButton(),
            Spacer(),
            Text('Welcome to the Add Place Page!'),
          ],
        )
      ),
    );
  }
}


/// AddPlaceButton
/// 
/// A segmented button that allows the user to choose between
/// auto-detecting their location or manually entering it.
enum AddMethod { auto, manual }

class AddPlaceButton extends StatefulWidget {
  const AddPlaceButton({super.key});

  @override
  State<AddPlaceButton> createState() => _AddPlaceButtonState();
}

class _AddPlaceButtonState extends State<AddPlaceButton>{
  AddMethod method = AddMethod.auto;

  @override
  Widget build(BuildContext context){
    return SegmentedButton<AddMethod>(
      segments: const <ButtonSegment<AddMethod>>[
        ButtonSegment<AddMethod>(
          value: AddMethod.auto,
          label: Text('Auto-Detect'),
        ),
        ButtonSegment<AddMethod>(
          value: AddMethod.manual,
          label: Text('Manual'),
        )
      ],
      selected: <AddMethod>{method},
      onSelectionChanged: (Set<AddMethod> newSelection){
        setState(() {
          method = newSelection.first;
        });
      },
    );
  }
}