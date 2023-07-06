import 'package:flutter/material.dart';
import '../models/rock.dart';

class RockDetailsPopup extends StatelessWidget {
  final Rock rock;

  const RockDetailsPopup({required this.rock});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(rock.name),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: ${rock.category}'),
            Text('Formula: ${rock.formula}'),
            Text('Crystal System: ${rock.crystalSystem}'),
            Text('Luster: ${rock.luster}'),
            Text('Streak: ${rock.streak}'),
            Text('Formation: ${rock.formation}'),
            Text('Properties: ${rock.properties}'),
            Text('Uses: ${rock.uses}'),
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
