import 'package:flutter/material.dart';

class CustomGrid<T> extends StatelessWidget {
  final List<T> items;
  final String Function(T) getTitle;
  final String? Function(T)? getSubtitle;
  final String? Function(T)? getImageUrl;
  final IconData? icon;
  final void Function(T) onTap;
  final double aspectRatio;

  const CustomGrid({
    super.key,
    required this.items,
    required this.getTitle,
    this.getSubtitle,
    this.getImageUrl,
    this.icon,
    required this.onTap,
    this.aspectRatio = 0.8,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: aspectRatio,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _buildGridItem(context, items[index]);
      },
    );
  }

  Widget _buildGridItem(BuildContext context, T item) {
    final String title = getTitle(item);
    final String? subtitle = getSubtitle != null ? getSubtitle!(item) : null;
    final String? imageUrl = getImageUrl != null ? getImageUrl!(item) : null;

    return GestureDetector(
      onTap: () => onTap(item),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              )
            else if (icon != null)
              Icon(icon, size: 40, color: Colors.blueAccent),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (subtitle != null)
              Text(
                subtitle,
                style: const TextStyle(fontSize: 15, color: Colors.black54),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }
}
