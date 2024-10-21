import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

import '/themes/main_theme.dart';
import '/ui/components/icon_with_background.dart';

// const double _graphicSize = 60;

class InfoAlertDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const InfoAlertDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: 400.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.title ?? 'Information',
                          style: Theme.of(context).textTheme.titleMedium,
                          textScaleFactor: 1.0,
                        ),
                        if (request.description != null) ...[
                          const SizedBox(height: 5.0),
                          Text(
                            request.description!,
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 4,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconWithBackground(
                    icon: Icons.info_outline,
                    circleColor: colors(context).dialogInfoEmojiBackground!,
                    size: 60,
                  ),
                ],
              ),
              const SizedBox(height: 25.0),
              TextButton(
                style: TextButton.styleFrom(
                  minimumSize: const Size(
                    double.infinity,
                    50.0,
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () => completer(DialogResponse(confirmed: true)),
                child: Text(
                  'OK',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: colors(context).altText),
                  textScaleFactor: 1.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
