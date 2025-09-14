import 'package:crud_review_app/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_state.dart';
import '../bloc/search_event.dart';
import '../widgets/search_bar.dart';
import '../models/search_result.dart';
import '../../results/models/business.dart';
import '../../results/widgets/business_card.dart';
import '../../results/bloc/results_bloc.dart';
import '../../results/bloc/results_event.dart';
import '../../results/bloc/results_state.dart';
import '../../business_detail/pages/business_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Business>? _currentSearchResults;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Sticky search header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey[600], size: 24),
                      const SizedBox(width: 8),
                      Text(
                        AppConstants.appName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: SearchBarWidget(controller: _searchController),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: const Icon(Icons.filter_list, size: 20),
                        onPressed: () {
                          _showFilterBottomSheet(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Results content
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchLoading) {
                    return _buildLoadingState();
                  }
                  if (state is SearchError) {
                    return _buildErrorState();
                  }
                  if (state is SearchSuccess) {
                    final newResults = state.results
                        .map((result) => Business.fromSearchResult(result))
                        .toList();

                    // Check if we have new search results
                    if (_currentSearchResults == null ||
                        _currentSearchResults!.length != newResults.length ||
                        !_currentSearchResults!.every(
                          (business) => newResults.any(
                            (newBusiness) =>
                                newBusiness.placeId == business.placeId,
                          ),
                        )) {
                      // New search results, update ResultsBloc
                      _currentSearchResults = newResults;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        context.read<ResultsBloc>().add(
                          ResultsUpdated(newResults: newResults),
                        );
                      });
                    }

                    return _buildResultsListWithFilter(state.results);
                  }
                  return _buildEmptyState();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Searching...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(32),
            ),
            child: Icon(Icons.error_outline, color: Colors.red[400], size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            'Search failed',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please check your connection and try again',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              if (_searchController.text.isNotEmpty) {
                context.read<SearchBloc>().add(
                  SearchQueryChanged(
                    query: _searchController.text,
                    lat: 12.9716,
                    lng: 77.5946,
                  ),
                );
              }
            },
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(Icons.search, size: 40, color: Colors.grey[400]),
          ),
          const SizedBox(height: 24),
          Text(
            'Find businesses near you',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Search for restaurants, shops, and more',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          _buildQuickSearchChips(),
        ],
      ),
    );
  }

  Widget _buildNoFilteredResultsState(ResultsSuccess state) {
    // Get the applied filters
    final appliedFilters = <String>[];
    if (state.ratingFilter != null) appliedFilters.add(state.ratingFilter!);
    if (state.distanceFilter != null) appliedFilters.add(state.distanceFilter!);
    if (state.categoryFilter != null) appliedFilters.add(state.categoryFilter!);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.orange[200]!, width: 2),
            ),
            child: Icon(
              Icons.filter_list_off,
              size: 50,
              color: Colors.orange[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No results found',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'No businesses match your current filters',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          // Show applied filters
          if (appliedFilters.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                children: [
                  Text(
                    'Applied Filters:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: appliedFilters.map((filter) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          filter,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  context.read<ResultsBloc>().add(const ResultsFilterCleared());
                },
                icon: const Icon(Icons.clear_all, size: 18),
                label: const Text('Clear Filters'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () {
                  _showFilterBottomSheet(context);
                },
                icon: const Icon(Icons.tune, size: 18),
                label: const Text('Adjust Filters'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Try adjusting your filters or clearing them to see more results',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSearchChips() {
    final quickSearches = ['Restaurants', 'Coffee', 'Shopping', 'Gas Station'];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: quickSearches.map((search) {
        return ActionChip(
          label: Text(search),
          onPressed: () {
            _searchController.text = search;
            context.read<SearchBloc>().add(
              SearchQueryChanged(query: search, lat: 12.9716, lng: 77.5946),
            );
          },
          backgroundColor: Colors.white,
          side: BorderSide(color: Colors.grey[300]!),
          labelStyle: TextStyle(color: Colors.grey[700], fontSize: 14),
        );
      }).toList(),
    );
  }

  Widget _buildResultsListWithFilter(List<SearchResult> results) {
    if (results.isEmpty) {
      return _buildEmptyState();
    }

    return BlocBuilder<ResultsBloc, ResultsState>(
      builder: (context, resultsState) {
        List<Business> displayResults;

        if (resultsState is ResultsSuccess) {
          // Use filtered results from ResultsBloc
          displayResults = resultsState.results;

          // Check if we have filters applied but no results
          if (displayResults.isEmpty &&
              (resultsState.ratingFilter != null ||
                  resultsState.distanceFilter != null ||
                  resultsState.categoryFilter != null)) {
            return _buildNoFilteredResultsState(resultsState);
          }
        } else {
          // Fallback to original results if no ResultsBloc state
          displayResults = results
              .map((result) => Business.fromSearchResult(result))
              .toList();
        }

        return RefreshIndicator(
          onRefresh: () async {
            if (_searchController.text.isNotEmpty) {
              context.read<SearchBloc>().add(
                SearchQueryChanged(
                  query: _searchController.text,
                  lat: 12.9716,
                  lng: 77.5946,
                ),
              );
            }
          },
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: displayResults.length,
            separatorBuilder: (context, index) => const SizedBox(height: 4),
            itemBuilder: (context, index) {
              final business = displayResults[index];
              return BusinessCard(
                business: business,
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          BusinessDetailPage(
                            placeId: business.placeId,
                            businessName: business.name,
                          ),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            return SlideTransition(
                              position: animation.drive(
                                Tween(
                                  begin: const Offset(1.0, 0.0),
                                  end: Offset.zero,
                                ).chain(CurveTween(curve: Curves.easeInOut)),
                              ),
                              child: child,
                            );
                          },
                      transitionDuration: const Duration(milliseconds: 300),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    String? selectedRating;
    String? selectedDistance;
    String? selectedCategory;

    // Get current filter state from ResultsBloc
    final currentState = context.read<ResultsBloc>().state;
    if (currentState is ResultsSuccess) {
      selectedRating = currentState.ratingFilter;
      selectedDistance = currentState.distanceFilter;
      selectedCategory = currentState.categoryFilter;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Text(
                      'Filter Results',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedRating = null;
                          selectedDistance = null;
                          selectedCategory = null;
                        });
                        context.read<ResultsBloc>().add(
                          const ResultsFilterCleared(),
                        );
                        Navigator.pop(context);
                      },
                      child: const Text('Clear All'),
                    ),
                  ],
                ),
              ),
              // Filter options
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildFilterSection(
                      'Rating',
                      ['4.5+ Stars', '4.0+ Stars', '3.5+ Stars', '3.0+ Stars'],
                      selectedRating,
                      (value) => setState(() => selectedRating = value),
                    ),
                    const SizedBox(height: 24),
                    _buildFilterSection(
                      'Distance',
                      ['Within 500m', 'Within 1km', 'Within 2km', 'Within 5km'],
                      selectedDistance,
                      (value) => setState(() => selectedDistance = value),
                    ),
                    const SizedBox(height: 24),
                    _buildFilterSection(
                      'Category',
                      [
                        'Restaurants',
                        'Coffee Shops',
                        'Shopping',
                        'Gas Stations',
                        'Hotels',
                      ],
                      selectedCategory,
                      (value) => setState(() => selectedCategory = value),
                    ),
                  ],
                ),
              ),
              // Apply button
              Container(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<ResultsBloc>().add(
                        ResultsFiltered(
                          ratingFilter: selectedRating,
                          distanceFilter: selectedDistance,
                          categoryFilter: selectedCategory,
                        ),
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Apply Filters',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection(
    String title,
    List<String> options,
    String? selectedValue,
    Function(String?) onSelectionChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selectedValue == option;
            return FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onSelectionChanged(option);
                } else {
                  onSelectionChanged(null);
                }
              },
              backgroundColor: Colors.grey[100],
              selectedColor: Colors.blue[100],
              checkmarkColor: Colors.blue,
              labelStyle: TextStyle(
                color: isSelected ? Colors.blue : Colors.grey[700],
                fontSize: 14,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
