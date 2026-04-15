import 'package:flutter/material.dart';

import '../../../domain/entities/staff_assignment.dart';

class StaffMemberTile extends StatelessWidget {
  final StaffAssignment assignment;
  final bool isCurrentUser;
  final VoidCallback? onChangeRole;
  final VoidCallback? onDeactivate;

  const StaffMemberTile({
    super.key,
    required this.assignment,
    this.isCurrentUser = false,
    this.onChangeRole,
    this.onDeactivate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.secondaryContainer,
        child: Text(
          (assignment.userName ?? '?')[0].toUpperCase(),
          style: TextStyle(color: theme.colorScheme.onSecondaryContainer),
        ),
      ),
      title: Row(
        children: [
          Flexible(child: Text(assignment.userName ?? 'Unknown')),
          if (isCurrentUser) ...[
            const SizedBox(width: 8),
            Chip(
              label: const Text('You'),
              labelStyle: theme.textTheme.labelSmall,
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            ),
          ],
        ],
      ),
      subtitle: Text(assignment.role.displayName),
      trailing: (onChangeRole != null || onDeactivate != null)
          ? PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'role') onChangeRole?.call();
                if (value == 'deactivate') onDeactivate?.call();
              },
              itemBuilder: (context) => [
                if (onChangeRole != null)
                  const PopupMenuItem(
                    value: 'role',
                    child: Text('Change Role'),
                  ),
                if (onDeactivate != null)
                  const PopupMenuItem(
                    value: 'deactivate',
                    child: Text('Deactivate'),
                  ),
              ],
            )
          : null,
    );
  }
}
