import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/services/api_service.dart';
import '../../data/services/user_local_service.dart';

class WinScreen extends StatefulWidget {
  final int finalScore;
  static const String routeName = "WinScreen";

  const WinScreen({super.key, required this.finalScore});

  @override
  State<WinScreen> createState() => _WinScreenState();
}

class _WinScreenState extends State<WinScreen> {
  @override
  void initState() {
    super.initState();
    _sendFinalScore();
  }

  Future<void> _sendFinalScore() async {
    final activeUser = await UserLocalService.getActiveUser();
    if (activeUser != null) {
      // تحديث كل البيانات في نفس الوقت قبل الحفظ
      activeUser.points = widget.finalScore;
      activeUser.gameTimeRemaining = 0; // تأكد من أن الوقت المتبقي هو صفر
      activeUser.hasCompletedGame = true; // تعيين حالة اللعبة إلى مكتملة

      // حفظ التغييرات مرة واحدة
      await activeUser.save();

      // إرسال السكور للسيرفر بعد الحفظ المحلي
      if (activeUser.serverId != null) {
        await ApiService.sendPointsUpdateToServer(activeUser.serverId!, widget.finalScore);
        activeUser.synced = true;
        await activeUser.save(); // حفظ حالة المزامنة
      } else {
        print('Error: Cannot send final score. User serverId is null.');
      }
    } else {
      print('Error: Cannot send final score. User is null.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.9,
                  colors: [
                    Color(0xFF000919),
                    Color(0xFF006F94),
                  ],
                  stops: [0.2, 1.0],
                ),
              ),
            ),
            Positioned.fill(
              child: Image.asset(
                'assets/images/lines.png',
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '⏰ Time is Up! ⏰',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontSize: 36.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Your Final Score: ${widget.finalScore}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 18.sp,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}