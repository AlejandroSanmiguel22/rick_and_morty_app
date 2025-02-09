import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final IconData? icon;
  final List<String>? extraInfo;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final double width; 
  final double height;

  const CustomCard({
    super.key,
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.icon,
    this.extraInfo,
    this.onTap,
    this.onDelete,
    this.width = double.infinity, 
    this.height = 230.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: SizedBox(
          width: width,
          height: height,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imageUrl!,
                      width: double.infinity,
                      height: height *
                          0.5, // 🔥 Se ajusta dinámicamente a la mitad del height
                      fit: BoxFit.cover,
                    ),
                  )
                else if (icon != null)
                  Icon(icon, size: 50, color: Colors.blueAccent),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(title,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                    ),
                    if (onDelete != null)
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: onDelete,
                      ),
                  ],
                ),
                if (subtitle != null)
                  Text(subtitle!,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                const SizedBox(height: 5),
                if (extraInfo != null && extraInfo!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: extraInfo!
                        .map((info) => Text(
                              info,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black54),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ))
                        .toList(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
