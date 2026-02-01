import 'package:flutter/material.dart';
import 'package:smartcamp_gazarecovery/core/prefs.dart';
import 'package:smartcamp_gazarecovery/features/login/data/models/data_user_model.dart';

class ProfileSection extends StatefulWidget {
  const ProfileSection({Key? key}) : super(key: key);

  @override
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  DataUserModel? _dataUser;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    setState(() {
      _loading = true;
    });
    try {
      final user = await Prefs.getUser();
      if (mounted) {
        setState(() {
          _dataUser = user;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _dataUser = null;
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final blue = const Color(0xFF2F80ED);
    final name = _dataUser?.user.name ?? 'غير معروف';
    final subtitle = _dataUser?.user.email?.isNotEmpty == true
        ? _dataUser!.user.email!
        : (_dataUser?.user.mobileNumber ?? '');
    final role = _dataUser?.user.username ?? 'مدير المخيم';

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
                        border: Border.all(color: const Color(0x1F2F80ED)),
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
        if (_loading)
          const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        else ...[
          Text(name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(role, style: const TextStyle(color: Colors.white54, fontSize: 14)),
          const SizedBox(height: 6),
          Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 13)),
          const SizedBox(height: 12),

          SizedBox(
            width: 190,
            child: ElevatedButton(
              onPressed: () async {
                // Navigate to EditProfileScreen and refresh when it returns true
                final result = await Navigator.of(context).pushNamed('/EditProfileScreen');
                if (result == true) {
                  _loadUser();
                }
              },
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
      ],
    );
  }
}
