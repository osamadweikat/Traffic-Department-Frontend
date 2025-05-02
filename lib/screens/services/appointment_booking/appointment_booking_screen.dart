import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../theme/app_theme.dart';
import '../appointment_booking/appointment_locations.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentBookingScreen extends StatefulWidget {
  const AppointmentBookingScreen({super.key});

  @override
  State<AppointmentBookingScreen> createState() => _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  String? selectedCity;
  String? selectedBranch;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  List<String> get branchesForSelectedCity =>
      selectedCity != null ? appointmentLocations[selectedCity!] ?? [] : [];

  void showCustomCalendarDialog() {
    final today = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'choose_date'.tr(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppTheme.navy,
                  ),
                ),
                const SizedBox(height: 12),
                TableCalendar(
                  locale: context.locale.languageCode == 'ar' ? 'ar_AR' : 'en_US',
                  firstDay: today,
                  lastDay: today.add(const Duration(days: 30)),
                  focusedDay: selectedDate ?? today,
                  calendarFormat: CalendarFormat.month,
                  selectedDayPredicate: (day) => isSameDay(selectedDate, day),
                  onDaySelected: (selected, focused) {
                    if (selected.weekday != DateTime.friday &&
                        selected.weekday != DateTime.saturday) {
                      setState(() => selectedDate = selected);
                      Navigator.pop(context);
                    }
                  },
                  enabledDayPredicate: (day) {
                    final isAfterToday = !day.isBefore(DateTime(today.year, today.month, today.day));
                    final isAllowedWeekday = day.weekday != DateTime.friday && day.weekday != DateTime.saturday;
                    return isAfterToday && isAllowedWeekday;
                  },
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: AppTheme.navy.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: AppTheme.navy,
                      shape: BoxShape.circle,
                    ),
                    outsideDaysVisible: false,
                    weekendTextStyle: const TextStyle(color: Colors.red),
                    disabledTextStyle: const TextStyle(color: Colors.grey),
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    weekendStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showCupertinoTimePickerDialog() {
    int tempHour = selectedTime?.hour ?? 8;
    int tempMinute = selectedTime?.minute ?? 0;

    final hourController = FixedExtentScrollController(initialItem: tempHour - 8);
    final minuteController = FixedExtentScrollController(initialItem: tempMinute);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, localSetState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'select_time'.tr(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.navy,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 160,
                            child: ListWheelScrollView.useDelegate(
                              controller: minuteController,
                              itemExtent: 48,
                              diameterRatio: 2.5,
                              physics: const FixedExtentScrollPhysics(),
                              onSelectedItemChanged: (index) {
                                tempMinute = index;
                                setState(() {
                                  selectedTime = TimeOfDay(hour: tempHour, minute: tempMinute);
                                });
                                localSetState(() {});
                              },
                              childDelegate: ListWheelChildBuilderDelegate(
                                childCount: 60,
                                builder: (context, index) {
                                  final isSelected = index == minuteController.selectedItem;
                                  return Center(
                                    child: Text(
                                      index.toString().padLeft(2, '0'),
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected ? AppTheme.navy : Colors.grey.shade400,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 160,
                            child: ListWheelScrollView.useDelegate(
                              controller: hourController,
                              itemExtent: 48,
                              diameterRatio: 2.5,
                              physics: const FixedExtentScrollPhysics(),
                              onSelectedItemChanged: (index) {
                                tempHour = 8 + index;
                                setState(() {
                                  selectedTime = TimeOfDay(hour: tempHour, minute: tempMinute);
                                });
                                localSetState(() {});
                              },
                              childDelegate: ListWheelChildBuilderDelegate(
                                childCount: 6,
                                builder: (context, index) {
                                  final hour = (8 + index).toString().padLeft(2, '0');
                                  final isSelected = index == hourController.selectedItem;
                                  return Center(
                                    child: Text(
                                      hour,
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected ? AppTheme.navy : Colors.grey.shade400,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'time_note'.tr(),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void confirmAppointment() {
    if (selectedCity == null || selectedBranch == null || selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('please_complete_all_fields'.tr())),
      );
      return;
    }

    final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);
    final formattedTime = selectedTime!.format(context);
    final qrData = '$selectedCity - $selectedBranch | $formattedDate | $formattedTime';

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset('assets/animations/success_check.json', width: 140),
              const SizedBox(height: 12),
              Text('appointment_confirmed'.tr(),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
              const SizedBox(height: 8),
              Text('$selectedBranch\n$formattedDate - $formattedTime', textAlign: TextAlign.center),
              const SizedBox(height: 20),
              QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 160,
              ),
              const SizedBox(height: 12),
              Text(
                'please_show_barcode'.tr(),
                style: const TextStyle(fontSize: 14, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _goToDashboard(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('تم', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGrey,
      appBar: AppBar(
        title: Text('book_appointment'.tr()),
        backgroundColor: AppTheme.navy,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Lottie.asset('assets/animations/Animation 55.json', height: 300),
              ),
            ),
            const SizedBox(height: 16),
            Text('choose_city'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: appointmentLocations.keys.map((city) {
                final isSelected = selectedCity == city;
                return ChoiceChip(
                  label: Text(city),
                  selected: isSelected,
                  onSelected: (_) => setState(() => selectedCity = city),
                  selectedColor: AppTheme.navy,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            if (branchesForSelectedCity.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('choose_branch'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: branchesForSelectedCity.map((branch) {
                      final isSelected = selectedBranch == branch;
                      return ChoiceChip(
                        label: Text(branch),
                        selected: isSelected,
                        onSelected: (_) => setState(() => selectedBranch = branch),
                        selectedColor: AppTheme.navy,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            const SizedBox(height: 24),
            Text('choose_date'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: showCustomCalendarDialog,
              icon: const Icon(Icons.calendar_today),
              label: Text(
                selectedDate == null
                    ? 'tap_to_select_date'.tr()
                    : DateFormat('yyyy-MM-dd').format(selectedDate!),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.navy,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text('choose_time'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: showCupertinoTimePickerDialog,
              icon: const Icon(Icons.access_time),
              label: Text(selectedTime == null
                  ? 'tap_to_select_time'.tr()
                  : selectedTime!.format(context)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.navy,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: confirmAppointment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('confirm_booking'.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

void _goToDashboard(BuildContext context) {
  Navigator.of(context, rootNavigator: true).popUntil((route) => route.isFirst);
  Future.delayed(const Duration(milliseconds: 100), () {
    Navigator.of(context, rootNavigator: true).pushReplacementNamed('/dashboard');
  });
}
