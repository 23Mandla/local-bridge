import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../opportunities/bloc/opportunities_bloc.dart';
import '../widgets/opportunity_quotes_toggle.dart';
import '../../quotes/ui/screens/my_quotes_screen.dart';
import '../../opportunities/ui/screens/opportunities_screen.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String selectedPage = "Opportunities";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Search bar, notifications and AI star
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                    child: SearchBar(
                      elevation: const WidgetStatePropertyAll(0),
                      backgroundColor: WidgetStatePropertyAll(
                        Colors.grey.shade50,
                      ),
                      side: WidgetStatePropertyAll(
                        BorderSide(color: Colors.grey.shade300, width: 1),
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      padding: const WidgetStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 12),
                      ),
                      constraints: const BoxConstraints(
                        minHeight: 40,
                        maxHeight: 40,
                      ),
                      textStyle: const WidgetStatePropertyAll(
                        TextStyle(fontSize: 14),
                      ),
                      hintText: "Search local opportunities",
                      hintStyle: const WidgetStatePropertyAll(
                        TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      onChanged: (value) {
                        debugPrint(value);
                      },
                      leading: const Icon(
                        Icons.search,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 14),
                  child: Icon(Icons.notifications_none, size: 25),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.blueGrey,
                    backgroundImage: AssetImage("assets/images/aistar.png"),
                  ),
                ),
              ],
            ),

            // Fixed buttons below the top row
            OpportunityQuotesToggle(
              selectedPage: selectedPage,
              onPageSelected: (page) {
                setState(() {
                  selectedPage = page;
                });
              },
            ),

            // main content
            Expanded(
              child: selectedPage == "Opportunities"
                  ? BlocConsumer<OpportunitiesBloc, OpportunitiesState>(
                      listener: (context, state) {
                        if (state is OpportunitiesError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is OpportunitiesLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state is OpportunitiesLoaded) {
                          return OpportunitiesScreen(
                            opportunities: state.opportunities,
                          );
                        }

                        if (state is OpportunitiesError) {
                          return Center(child: Text(state.message));
                        }

                        return const SizedBox.shrink();
                      },
                    )
                  : const MyQuotesScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
