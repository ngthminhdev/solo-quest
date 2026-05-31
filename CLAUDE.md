# Solo Quest - Project Rules

## Icon System

**Use Remix Icons (`remixicon` package) instead of Flutter's default Material Icons.**

```dart
import 'package:remixicon/remixicon.dart';

// Usage
Icon(RemixIcons.home_3_line)
Icon(RemixIcons.settings_3_fill)
```

- Use `_line` variants for outlined/regular icons
- Use `_fill` variants for active/selected states
- Reference: https://remixicon.com

### Common Icons Mapping

| Purpose | Remix Icon |
|---------|------------|
| Home | `RemixIcons.home_3_line` / `RemixIcons.home_3_fill` |
| Logs/Journal | `RemixIcons.file_text_line` / `RemixIcons.file_text_fill` |
| Progress/Chart | `RemixIcons.bar_chart_2_line` / `RemixIcons.bar_chart_2_fill` |
| Rewards/Star | `RemixIcons.star_line` / `RemixIcons.star_fill` |
| Profile/User | `RemixIcons.user_3_line` / `RemixIcons.user_3_fill` |
| Settings | `RemixIcons.settings_3_line` / `RemixIcons.settings_3_fill` |
| Back/Arrow Left | `RemixIcons.arrow_left_s_line` |
| Calendar | `RemixIcons.calendar_line` |
| Clock/Time | `RemixIcons.time_line` |
| Check/Complete | `RemixIcons.check_line` |
| Close | `RemixIcons.close_line` |
| Add/Plus | `RemixIcons.add_line` |
| Search | `RemixIcons.search_line` |
| Filter | `RemixIcons.filter_3_line` |
| Notification | `RemixIcons.notification_3_line` |
| Bookmark | `RemixIcons.bookmark_line` / `RemixIcons.bookmark_fill` |
| Heart | `RemixIcons.heart_line` / `RemixIcons.heart_fill` |
| Edit/Pen | `RemixIcons.edit_line` |
| Delete/Trash | `RemixIcons.delete_bin_6_line` |
| Info | `RemixIcons.information_line` |
| Warning | `RemixIcons.error_warning_line` |
| Success | `RemixIcons.checkbox_circle_line` |
| Refresh | `RemixIcons.refresh_line` |
| More/Menu | `RemixIcons.more_2_line` |
| Share | `RemixIcons.share_forward_line` |
| Copy | `RemixIcons.file_copy_line` |
| Download | `RemixIcons.download_line` |
| Upload | `RemixIcons.upload_line` |
| Lock | `RemixIcons.lock_line` |
| Unlock | `RemixIcons.lock_unlock_line` |
| Eye/View | `RemixIcons.eye_line` |
| Eye Off | `RemixIcons.eye_off_line` |
| Mail | `RemixIcons.mail_line` |
| Phone | `RemixIcons.phone_line` |
| Location | `RemixIcons.map_pin_line` |
| Image | `RemixIcons.image_line` |
| Camera | `RemixIcons.camera_line` |
| Music | `RemixIcons.music_line` |
| Play | `RemixIcons.play_line` |
| Pause | `RemixIcons.pause_line` |
| Stop | `RemixIcons.stop_line` |
| Volume | `RemixIcons.volume_up_line` |
| Mute | `RemixIcons.volume_mute_line` |
| Wifi | `RemixIcons.wifi_line` |
| Battery | `RemixIcons.battery_line` |
| Sun/Light | `RemixIcons.sun_line` |
| Moon/Dark | `RemixIcons.moon_line` |
