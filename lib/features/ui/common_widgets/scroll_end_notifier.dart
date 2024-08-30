import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project_template/features/interfaces/i_pagination.dart';

class ScrollEndNotifier<T extends IPagination> extends StatelessWidget {
  const ScrollEndNotifier({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollEndNotification>(
      onNotification: (ScrollEndNotification scrollInfo) {
        final boolCanLoadMore =
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
                context.read<T>().canLoadMore;
        if (boolCanLoadMore) {
          context.read<T>().getMore();
        }
        return true;
      },
      child: child,
    );
  }
}
