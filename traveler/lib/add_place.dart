import 'package:flutter/material.dart';

/// AddPlacePage
/// 
/// Defines the UI for the page that allows the user to add a place to the map.
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
enum AddMethod { search, gpsPin }

class AddPlaceButton extends StatefulWidget {
  const AddPlaceButton({super.key});

  @override
  State<AddPlaceButton> createState() => _AddPlaceButtonState();
}

class _AddPlaceButtonState extends State<AddPlaceButton>{
  AddMethod method = AddMethod.search;

  @override
  Widget build(BuildContext context){
    return SegmentedButton<AddMethod>(
      segments: const <ButtonSegment<AddMethod>>[
        ButtonSegment<AddMethod>(
          value: AddMethod.search,
          label: Text('Search'),
        ),
        ButtonSegment<AddMethod>(
          value: AddMethod.gpsPin,
          label: Text('Pin'),
        )
      ],
      selected: <AddMethod>{method},
      onSelectionChanged: (Set<AddMethod> newSelection){
        setState(() {
          method = newSelection.first;
        });
      },
      showSelectedIcon: false,  // Hide the checkmark icon, and keeps the button width consistent
    );
  }
}

/// AddPlaceForm
/// 
/// A form that allows the user to add a place to the map using search.
Widget _searchForm(){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Search Bar

      // Description TextField

      // Has Visited Bool

      // Submit Button

    ],
  );
}

/// AddPlaceForm
/// 
/// A form that allows the user to add a place to the map using GPS.
Widget _gpsPinForm(){
return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Name TextField

      // Description TextField

      // Has Visited Bool

      // Add Pin Button
      
    ],
  );
}

/// Location Search Bar
/// 
/// A search bar that allows the user to search for a location.
class LocationSearch extends StatefulWidget {
  const LocationSearch({super.key});

  @override
  _LocationSearchState createState() => _LocationSearchState();
}