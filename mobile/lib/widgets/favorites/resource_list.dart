import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/resource.dart';
import '../../pages/detail_resource.dart';
import '../../providers/session_provider.dart';
import 'resource_card.dart';

class ResourceList extends StatelessWidget {
  final List<Resource> resources;
  final Future<void> Function() onRefresh;

  const ResourceList({
    Key? key,
    required this.resources,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (resources.isEmpty) {
      return const Center(child: Text("Aucune ressource disponible."));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: resources.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final res = resources[index];
        return ResourceCard(
          resource: res,
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ResourceDetailPage(
                  resource: res,
                  token: Provider.of<SessionProvider>(context, listen: false).token,
                ),
              ),
            );
            await onRefresh();
          },
        );
      },
    );
  }
}
