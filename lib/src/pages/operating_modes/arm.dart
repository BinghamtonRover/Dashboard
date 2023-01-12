import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";

/// The page for the science operating mode. 
class ArmPage extends StatelessWidget {
  /// A const constructor.
  const ArmPage();

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (_) => ArmModel(), 
    child: Consumer<ArmModel>(
      builder: (context, model, _) => Row(
        children: [
          Expanded(child: VideoFeeds(model.feeds)),
        ]
      )
    )
  );
}
