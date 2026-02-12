import 'package:flutter/material.dart';
import 'package:app/core/theme/style/colors.dart';

class PdfCard extends StatelessWidget {
  final String fileName;
  final VoidCallback onOpen;
  final VoidCallback onShare;
  final VoidCallback onDelete;

  const PdfCard({
    super.key,
    required this.fileName,
    required this.onOpen,
    required this.onShare,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha:0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.picture_as_pdf, color: AppColors.error, size: 32),

          const SizedBox(width: 16),

          Expanded(
            child: Text(
              fileName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.secondary,
              ),
            ),
          ),

          PopupMenuButton<String>(
            color: AppColors.white,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            offset: const Offset(0, 10),
            surfaceTintColor: AppColors.white,
            shadowColor: AppColors.black.withValues(alpha:0.1),
            icon: const Icon(Icons.more_vert, color: AppColors.secondary),
            onSelected: (value) {
              if (value == 'abrir') onOpen();
              if (value == 'compartir') onShare();
              if (value == 'borrar') onDelete();
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'abrir',
                child: Row(
                  children: const [
                    Icon(
                      Icons.open_in_new,
                      color: AppColors.secondary,
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Text(
                      "Abrir",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'compartir',
                child: Row(
                  children: const [
                    Icon(Icons.share, color: AppColors.secondary, size: 20),
                    SizedBox(width: 12),
                    Text(
                      "Compartir",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'borrar',
                child: Row(
                  children: const [
                    Icon(Icons.delete, color: AppColors.error, size: 20),
                    SizedBox(width: 12),
                    Text(
                      "Borrar",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
