import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/utils/debouncer.dart';

class SearchBarWidget extends StatefulWidget {
  final TextEditingController controller;

  const SearchBarWidget({super.key, required this.controller});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late final Debouncer _debouncer;

  @override
  void initState() {
    super.initState();
    _debouncer = Debouncer(milliseconds: AppConstants.searchDebounceMs);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: widget.controller,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          hintText: 'Search for restaurants, cafes, etc.',
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
          prefixIcon: Container(
            margin: const EdgeInsets.only(left: 4),
            child: Icon(Icons.search, color: Colors.grey[600], size: 24),
          ),
          suffixIcon: widget.controller.text.isNotEmpty
              ? AnimatedSwitcher(
                  duration: const Duration(
                    milliseconds: AppConstants.shortAnimationMs,
                  ),
                  child: Container(
                    key: const ValueKey('clear_button'),
                    margin: const EdgeInsets.only(right: 4),
                    child: IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                      onPressed: () {
                        widget.controller.clear();
                        context.read<SearchBloc>().add(const SearchCleared());
                      },
                    ),
                  ),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(
              color: Colors.blue.withOpacity(0.3),
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        onChanged: (value) {
          setState(() {}); // Trigger rebuild for suffix icon animation
          _debouncer.run(() {
            // Get current location (simplified - use default location)
            const lat = ApiConstants.defaultLat;
            const lng = ApiConstants.defaultLng;

            context.read<SearchBloc>().add(
              SearchQueryChanged(query: value, lat: lat, lng: lng),
            );
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }
}
