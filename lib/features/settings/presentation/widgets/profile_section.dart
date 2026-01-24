import 'package:flutter/material.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final blue = const Color(0xFF2F80ED);
    return Column(
      children: [
        SizedBox(
          height: 140,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // Avatar with blue border
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: blue, width: 4),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'images/logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Edit icon overlapping
              Positioned(
                bottom: 6,
                left: MediaQuery.of(context).size.width / 2 - 110 / 2 - 6,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {},
                    child: Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0B1720),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: blue.withOpacity(0.12)),
                      ),
                      child: const Icon(Icons.edit, color: Colors.white70, size: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),
        const Text('أحمد محمد', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        const Text('مدير المخيم', style: TextStyle(color: Colors.white54, fontSize: 14)),
        const SizedBox(height: 6),
        const Text('ahmed.m@example.com', style: TextStyle(color: Colors.white38, fontSize: 13)),
        const SizedBox(height: 12),

        SizedBox(
          width: 190,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0B1720),
              foregroundColor: const Color(0xFF2F80ED),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text('تعديل الملف'),
          ),
        ),
      ],
    );
  }
}

