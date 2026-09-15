import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';

/// Colour and picture set for a category's photo tiles. Until admin adds real
/// photos, each product shows a small gallery of these drawn tiles.
(Color, List<IconData>) _photoSet(String categoryIcon) => switch (categoryIcon) {
      'cctv' => (const Color(0xFF2563EB), const [
          Icons.videocam_outlined, Icons.phone_android_outlined,
          Icons.dvr_outlined, Icons.handyman_outlined]),
      'ac' => (const Color(0xFF0891B2), const [
          Icons.ac_unit_outlined, Icons.air, Icons.thermostat_outlined, Icons.build_outlined]),
      'solar' => (const Color(0xFFD97706), const [
          Icons.solar_power_outlined, Icons.wb_sunny_outlined, Icons.bolt_outlined,
          Icons.roofing_outlined]),
      'interior' => (const Color(0xFF7C3AED), const [
          Icons.chair_outlined, Icons.kitchen_outlined, Icons.bed_outlined,
          Icons.design_services_outlined]),
      'tiles' => (const Color(0xFF475569), const [
          Icons.grid_view_outlined, Icons.texture, Icons.bathtub_outlined,
          Icons.straighten_outlined]),
      'jewellery' => (const Color(0xFFB45309), const [
          Icons.diamond_outlined, Icons.auto_awesome_outlined, Icons.redeem_outlined,
          Icons.workspace_premium_outlined]),
      'pooja' => (const Color(0xFFEA580C), const [
          Icons.temple_hindu_outlined, Icons.local_florist_outlined,
          Icons.emoji_objects_outlined, Icons.celebration_outlined]),
      'appliance' => (const Color(0xFF0F766E), const [
          Icons.kitchen_outlined, Icons.local_laundry_service_outlined, Icons.tv_outlined,
          Icons.local_shipping_outlined]),
      'painting' => (const Color(0xFFDB2777), const [
          Icons.format_paint_outlined, Icons.palette_outlined, Icons.brush_outlined,
          Icons.home_outlined]),
      'water' => (const Color(0xFF0284C7), const [
          Icons.water_drop_outlined, Icons.filter_alt_outlined, Icons.opacity,
          Icons.plumbing_outlined]),
      'electrical' => (const Color(0xFFCA8A04), const [
          Icons.electrical_services_outlined, Icons.lightbulb_outline,
          Icons.plumbing_outlined, Icons.power_outlined]),
      'furniture' => (const Color(0xFF92400E), const [
          Icons.weekend_outlined, Icons.chair_alt_outlined,
          Icons.table_restaurant_outlined, Icons.desk_outlined]),
      'lift' => (const Color(0xFF334155), const [
          Icons.elevator_outlined, Icons.apartment_outlined, Icons.stairs_outlined,
          Icons.engineering_outlined]),
      _ => (const Color(0xFF4F46E5), const [
          Icons.category_outlined, Icons.search, Icons.local_shipping_outlined,
          Icons.support_agent_outlined]),
    };

/// One photo of a product. Shows [url] when there is one, otherwise a drawn
/// tile in the category's colour. Decorative: the product name is always
/// written next to it.
class ProductPhoto extends StatelessWidget {
  const ProductPhoto({
    super.key,
    required this.categoryIcon,
    this.index = 0,
    this.url,
    this.radius = Corners.mdAll,
    this.iconAlignment = Alignment.center,
  });

  final String categoryIcon;

  /// Which picture of the set; different indexes give different tiles.
  final int index;
  final String? url;
  final BorderRadius radius;
  final Alignment iconAlignment;

  @override
  Widget build(BuildContext context) {
    final drawn = _DrawnPhoto(categoryIcon: categoryIcon, index: index, alignment: iconAlignment);
    return ExcludeSemantics(
      child: ClipRRect(
        borderRadius: radius,
        child: url == null
            ? drawn
            : Image.network(
                url!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (_, _, _) => drawn,
              ),
      ),
    );
  }
}

class _DrawnPhoto extends StatelessWidget {
  const _DrawnPhoto({required this.categoryIcon, required this.index, required this.alignment});

  final String categoryIcon;
  final int index;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final (base, icons) = _photoSet(categoryIcon);
    final i = index % icons.length;
    final light = Color.lerp(base, Colors.white, i.isEven ? 0.86 : 0.78)!;
    final mid = Color.lerp(base, Colors.white, i.isEven ? 0.66 : 0.58)!;
    final ink = Color.lerp(base, Colors.black, 0.12)!;
    return LayoutBuilder(builder: (context, c) {
      final side = c.biggest.shortestSide.isFinite ? c.biggest.shortestSide : 80.0;
      return DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: i.isEven ? Alignment.topLeft : Alignment.topRight,
            end: i.isEven ? Alignment.bottomRight : Alignment.bottomLeft,
            colors: [light, mid],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Two soft circles give the tile some depth.
            Positioned(
              right: -side * 0.25,
              top: -side * 0.3,
              width: side * 0.9,
              height: side * 0.9,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.35),
                ),
              ),
            ),
            Positioned(
              left: -side * 0.2,
              bottom: -side * 0.35,
              width: side * 0.7,
              height: side * 0.7,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: base.withValues(alpha: 0.10),
                ),
              ),
            ),
            Align(
              alignment: alignment,
              child: Icon(icons[i], size: side * 0.44, color: ink),
            ),
          ],
        ),
      );
    });
  }
}

/// A row of small photos, as on a marketplace listing.
class PhotoStrip extends StatelessWidget {
  const PhotoStrip({
    super.key,
    required this.categoryIcon,
    this.count = 3,
    this.start = 0,
    this.photos = const [],
    this.height = 78,
  });

  final String categoryIcon;
  final int count;

  /// First picture index, so different sellers show different tiles.
  final int start;
  final List<String> photos;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        children: [
          for (var i = 0; i < count; i++) ...[
            if (i > 0) const SizedBox(width: 6),
            Expanded(
              child: ProductPhoto(
                categoryIcon: categoryIcon,
                index: start + i,
                url: i < photos.length ? photos[i] : null,
                radius: Corners.smAll,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// The big picture at the top of a product page, with the product's name and
/// description written over it, and small photos underneath to switch the
/// picture.
class ProductBanner extends StatefulWidget {
  const ProductBanner({
    super.key,
    required this.categoryIcon,
    required this.title,
    required this.description,
    this.label,
    this.photos = const [],
    this.count = 4,
    this.start = 0,
    this.photoLabel,
  });

  final String categoryIcon;
  final String title;
  final String description;

  /// Small tag above the title, such as the category.
  final String? label;
  final List<String> photos;
  final int count;
  final int start;

  /// Screen-reader name for each small photo, e.g. "Photo 2 of 4".
  final String Function(String index, String count)? photoLabel;

  @override
  State<ProductBanner> createState() => _ProductBannerState();
}

class _ProductBannerState extends State<ProductBanner> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final w = widget;
    String? url(int i) => i < w.photos.length ? w.photos[i] : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: Corners.xlAll,
          child: SizedBox(
            height: 232,
            child: Stack(
              fit: StackFit.expand,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: ProductPhoto(
                    key: ValueKey(_selected),
                    categoryIcon: w.categoryIcon,
                    index: w.start + _selected,
                    url: url(_selected),
                    radius: BorderRadius.zero,
                    iconAlignment: const Alignment(0.55, -0.45),
                  ),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.25, 1],
                      colors: [Color(0x00000000), Color(0xC8111827)],
                    ),
                  ),
                ),
                Positioned(
                  left: Space.lg,
                  right: Space.lg,
                  bottom: Space.lg,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (w.label != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.92),
                            borderRadius: Corners.pillAll,
                          ),
                          child: Text(
                            w.label!,
                            style: context.text.labelSmall?.copyWith(color: AppColors.text),
                          ),
                        ),
                        Space.gapSm,
                      ],
                      Semantics(
                        header: true,
                        child: Text(
                          w.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppType.weight(context.text.headlineSmall!, FontWeight.w800)
                              .copyWith(color: Colors.white, height: 1.15),
                        ),
                      ),
                      if (w.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          w.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: context.text.bodyMedium
                              ?.copyWith(color: Colors.white.withValues(alpha: 0.94)),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (w.count > 1) ...[
          Space.gapSm,
          SizedBox(
            height: 60,
            child: Row(
              children: [
                for (var i = 0; i < w.count; i++) ...[
                  if (i > 0) Space.gapSm,
                  Expanded(
                    child: Semantics(
                      button: true,
                      selected: _selected == i,
                      label: w.photoLabel?.call('${i + 1}', '${w.count}'),
                      child: InkWell(
                        borderRadius: Corners.smAll,
                        onTap: () => setState(() => _selected = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            borderRadius: Corners.smAll,
                            border: Border.all(
                              width: 2,
                              color: _selected == i ? AppColors.primary : Colors.transparent,
                            ),
                          ),
                          child: ProductPhoto(
                            categoryIcon: w.categoryIcon,
                            index: w.start + i,
                            url: url(i),
                            radius: const BorderRadius.all(Radius.circular(6)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}
