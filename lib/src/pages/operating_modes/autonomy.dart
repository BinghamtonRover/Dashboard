import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";

/// The page for the science operating mode. 
class AutonomyPage extends StatelessWidget {
  /// A const constructor.
  const AutonomyPage();
  
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (_) => AutonomyModel(), 
    child: Consumer<AutonomyModel>(
      builder: (context, model, _) => Row(
        children: const [
          Expanded(child: VideoFeeds()),
        ]
      )
    )
  );
}
