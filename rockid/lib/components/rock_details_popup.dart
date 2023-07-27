import 'package:flutter/material.dart';
import '../models/rock.dart';

class RockDetailsPopup extends StatefulWidget {
  final Rock rock;

  const RockDetailsPopup({required this.rock});

  @override
  _RockDetailsPopupState createState() => _RockDetailsPopupState();
}

class _RockDetailsPopupState extends State<RockDetailsPopup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.rock.name),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${widget.rock.description}'),
            Text('Category: ${widget.rock.category}'),
            Text('Formula: ${widget.rock.formula}'),
            Text('Crystal System: ${widget.rock.crystalSystem}'),
            Text('Luster: ${widget.rock.luster}'),
            Text('Streak: ${widget.rock.streak}'),
            if (widget.rock.imageURL.isNotEmpty)
              Image.network(widget.rock.imageURL), // Display the image using the URL
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}




// class RockDetailsPopup extends StatelessWidget {
//   final Rock rock;

//   const RockDetailsPopup({super.key, required this.rock});

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text(rock.name),
//       content: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Check if the imageURL is not empty
//             if (rock.imageURL.isNotEmpty) 
//               Image.network(rock.imageURL),
//             Text('Category: ${rock.category}'),
//             Text('Formula: ${rock.formula}'),
//             Text('Crystal System: ${rock.crystalSystem}'),
//             Text('Luster: ${rock.luster}'),
//             Text('Streak: ${rock.streak}'),
//             Text('Formation: ${rock.description}'),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: const Text('Close'),
//         ),
//       ],
//     );
//   }
// }
