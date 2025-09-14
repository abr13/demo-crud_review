import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import '../bloc/business_detail_bloc.dart';
import '../bloc/business_detail_event.dart';
import '../bloc/business_detail_state.dart';
import '../widgets/business_header.dart';
import '../widgets/review_card.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/error_widget.dart';
import '../../../shared/widgets/skeleton_loader.dart';
import '../../deeplink/services/deeplink_service.dart';
import '../../../core/theme/app_colors.dart';

class BusinessDetailPage extends StatefulWidget {
  final String placeId;
  final String businessName;

  const BusinessDetailPage({
    super.key,
    required this.placeId,
    required this.businessName,
  });

  @override
  State<BusinessDetailPage> createState() => _BusinessDetailPageState();
}

class _BusinessDetailPageState extends State<BusinessDetailPage> {
  late final DeeplinkService _deeplinkService;
  bool _isOpeningMaps = false;

  @override
  void initState() {
    super.initState();
    _deeplinkService = DeeplinkService();

    // Request business details when the page is initialized
    context.read<BusinessDetailBloc>().add(
      BusinessDetailRequested(placeId: widget.placeId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.businessName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          BlocBuilder<BusinessDetailBloc, BusinessDetailState>(
            builder: (context, state) {
              if (state is BusinessDetailSuccess) {
                return IconButton(
                  icon: const Icon(Icons.share, size: 20),
                  onPressed: () {
                    _shareBusiness(context, state);
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, size: 20),
            onPressed: () {
              context.read<BusinessDetailBloc>().add(
                BusinessDetailRefreshed(placeId: widget.placeId),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<BusinessDetailBloc, BusinessDetailState>(
        builder: (context, state) {
          if (state is BusinessDetailLoading) {
            return Column(
              children: [
                const BusinessHeaderSkeleton(),
                Expanded(
                  child: ListView.builder(
                    itemCount: 3, // Show 3 skeleton review cards
                    itemBuilder: (context, index) => const ReviewCardSkeleton(),
                  ),
                ),
              ],
            );
          }

          if (state is BusinessDetailError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () {
                context.read<BusinessDetailBloc>().add(
                  BusinessDetailRequested(placeId: widget.placeId),
                );
              },
            );
          }

          if (state is BusinessDetailSuccess) {
            return Column(
              children: [
                // Business header
                BusinessHeader(businessDetail: state.businessDetail),

                // Reviews section with filters
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Reviews header with filter
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Text(
                              'Reviews (${state.businessDetail.reviews.length})',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: state.businessDetail.reviews.isEmpty
                            ? const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.reviews,
                                      size: 64,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'No reviews available',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemCount: state.businessDetail.reviews.length
                                    .clamp(0, 5), // Limit to 5 reviews
                                itemBuilder: (context, index) {
                                  final review =
                                      state.businessDetail.reviews[index];
                                  return ReviewCard(review: review);
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return const LoadingWidget();
        },
      ),
      floatingActionButton:
          BlocBuilder<BusinessDetailBloc, BusinessDetailState>(
            builder: (context, state) {
              if (state is BusinessDetailSuccess) {
                return FloatingActionButton.extended(
                  onPressed: _isOpeningMaps
                      ? null
                      : () async {
                          setState(() {
                            _isOpeningMaps = true;
                          });

                          final scaffoldMessenger = ScaffoldMessenger.of(
                            context,
                          );
                          try {
                            // Use url_launcher to open Google Maps
                            await _deeplinkService.openGoogleMaps(
                              businessName: state.businessDetail.name,
                              address: state.businessDetail.locality,
                            );
                          } catch (e) {
                            if (mounted) {
                              scaffoldMessenger.showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Failed to open Google Maps: $e',
                                  ),
                                  backgroundColor: AppColors.error,
                                ),
                              );
                            }
                          } finally {
                            if (mounted) {
                              setState(() {
                                _isOpeningMaps = false;
                              });
                            }
                          }
                        },
                  icon: _isOpeningMaps
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Icon(Icons.map),
                  label: Text(_isOpeningMaps ? 'Opening...' : 'See on Google'),
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                );
              }
              return const SizedBox.shrink();
            },
          ),
    );
  }

  void _shareBusiness(BuildContext context, BusinessDetailSuccess state) {
    final business = state.businessDetail;
    final googleMapsUrl = business.getGoogleMapsUrl();
    final shareText =
        '''
${business.name}
${business.category}
⭐ ${business.rating} (${business.userRatingsTotal} reviews)
📍 ${business.locality}

Check it out on Google Maps: $googleMapsUrl

Found via CRUD Review App!
''';

    Share.share(shareText, subject: 'Check out ${business.name}');
  }
}
