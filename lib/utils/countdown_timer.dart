import 'dart:async';
import 'package:flutter/material.dart';

import '../components/ui/text_style.dart';

class CountDownTimer extends StatefulWidget {
  const CountDownTimer({
    super.key,
    required this.countdown,
    required this.restart,
  });

  final int countdown;
  final VoidCallback restart;

  @override
  // ignore: library_private_types_in_public_api
  _CountDownTimerState createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer> {
  late Timer _timer;
  int remainingTime = 0;
  bool timerComplete = false;

  @override
  void initState() {
    super.initState();
    remainingTime = widget.countdown;
    startTimer(widget.countdown);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer(int countdown) {
    setState(() {
      timerComplete = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        remainingTime--;
      });

      if (remainingTime <= 0) {
        setState(() {
          timerComplete = true;
        });
        _timer.cancel();
      }
    });
  }

  void resetTimer() {
    widget.restart();
    startTimer(widget.countdown);
    setState(() {
      remainingTime = widget.countdown;
      timerComplete = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
            text: TextSpan(children: <TextSpan>[
          const TextSpan(text: 'Time left : ', style: AppTextStyles.kw700Secondary14),
          TextSpan(
              text: '$remainingTime',
              style: timerComplete
                  ? AppTextStyles.kw700Secondary16
                  : AppTextStyles.kErrorText16),
          const TextSpan(text: 's', style: AppTextStyles.kw700Secondary14)
        ])),
        InkWell(
          onTap: () {
            if (timerComplete) {
              resetTimer();
            }
          },
          child: Text(
            'Resend OTP ?',
            style: timerComplete
                ? AppTextStyles.kw700secondaryBg16
                : AppTextStyles.kErrorText16,
          ),
        ),
      ],
    );
  }
}
