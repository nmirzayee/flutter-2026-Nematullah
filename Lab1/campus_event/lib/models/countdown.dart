sealed class Countdown {
  const Countdown();
}

final class Upcoming extends Countdown {
  final Duration remaining;

  const Upcoming(this.remaining);
}

final class Started extends Countdown {
  final Duration elapsed;

  const Started(this.elapsed);
}

final class Ended extends Countdown {
  const Ended();
}

Countdown getCountdown(DateTime startsAt, {DateTime? now}) {
  final currentTime = now ?? DateTime.now();

  if (currentTime.isBefore(startsAt)) {
    return Upcoming(startsAt.difference(currentTime));
  }

  final elapsed = currentTime.difference(startsAt);

  if (elapsed < const Duration(hours: 1)) {
    return Started(elapsed);
  }

  return const Ended();
}

String countdownLabel(Countdown countdown) {
  return switch (countdown) {
    Upcoming(:final remaining) => _formatRemaining(remaining),
    Started(:final elapsed) => 'Started ${elapsed.inMinutes} min ago',
    Ended() => 'Ended',
  };
}

String _formatRemaining(Duration duration) {
  final days = duration.inDays;
  final hours = duration.inHours % 24;
  final minutes = duration.inMinutes % 60;

  if (days > 0) {
    return 'Starts in $days days, $hours hours';
  }

  if (duration.inHours > 0) {
    return 'Starts in ${duration.inHours} hours, '
        '$minutes min';
  }

  return 'Starts in ${duration.inMinutes} min';
}
