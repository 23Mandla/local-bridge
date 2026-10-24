import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OpportunityQuotesToggle extends StatelessWidget {
  final String selectedPage;
  final ValueChanged<String> onPageSelected;

  const OpportunityQuotesToggle({
    super.key,
    required this.selectedPage,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.blueGrey.shade100,
            width: 2,
          ),
        ),
      ),
      child: Row(
        children: [
          _ToggleTab(
            title: 'Opportunities',
            isSelected: selectedPage == 'Opportunities',
            onTap: () => onPageSelected('Opportunities'),
          ),
          _ToggleTab(
            title: 'My quotes',
            isSelected: selectedPage == 'My Quotes',
            onTap: () => onPageSelected('My Quotes'),
          ),
        ],
      ),
    );
  }
}

class _ToggleTab extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleTab({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? const Color(0xFF246B55)
                          : const Color(0xFF424846),
                    ),
                  ),
                ),
              ),
              Container(
                height: 5,
                width: 180,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF246B55)
                      : Colors.transparent,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
