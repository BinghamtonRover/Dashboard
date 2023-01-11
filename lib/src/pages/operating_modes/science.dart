import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";

/// The page for the science operating mode. 
class SciencePage extends StatelessWidget {
  /// A const constructor.
  const SciencePage();
  
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (_) => ScienceModel(), 
    child: Consumer<ScienceModel>(
      builder: (context, model, _) => Row(
        children: [
          Expanded(child: VideoFeeds(model.feeds)),
          Sidebar<ScienceModel>(),
        ]
      )
    )
  );
}
