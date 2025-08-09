import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          pinned: true,
          title: Text('PlanIt'),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const _SectionHeader(title: 'Today')
            , const SizedBox(height: 8),
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('No tasks yet', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 8),
                    Text('Add tasks and schedules in your planner.')
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const _SectionHeader(title: 'Suggestions'),
              const SizedBox(height: 8),
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Try our AI chat to plan meals and shopping.'),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: child,
      ),
    );
  }
}