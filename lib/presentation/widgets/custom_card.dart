import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final IconData? icon;
  final List<String>? extraInfo;
  final VoidCallback? onTap;

  const CustomCard({
    super.key,
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.icon,
    this.extraInfo,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize:
                MainAxisSize.min, 
            children: [
              if (imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl!,
                    width: double.infinity,
                    height: 110, 
                    fit: BoxFit.cover,
                  ),
                )
              else if (icon != null)
                Icon(icon, size: 50),
              const SizedBox(height: 8),
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 2, 
                  overflow: TextOverflow.ellipsis),
              if (subtitle != null)
                Text(subtitle!,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    maxLines: 1, 
                    overflow: TextOverflow.ellipsis),
              const SizedBox(height: 5),
              if (extraInfo != null)
                Expanded(
                 
                  child: ListView(
                    shrinkWrap:
                        true, 
                    physics:
                        const NeverScrollableScrollPhysics(), 
                    children: extraInfo!
                        .map((info) => Text(
                              info,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black54),
                              maxLines:
                                  2, 
                              overflow: TextOverflow.ellipsis,
                            ))
                        .toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
