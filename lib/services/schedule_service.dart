import '../models/schedule_model.dart';

class ScheduleService {
  static final List<ScheduleBlockModel> _blocks = [
    ScheduleBlockModel(
      id: '1',
      title: 'Làm việc',
      timeRange: TimeRangeModel(start: '08:30', end: '12:00'),
      weekdays: [1, 2, 3, 4, 5],
      type: 'work',
      isFlexible: false,
    ),
    ScheduleBlockModel(
      id: '2',
      title: 'Nghỉ trưa',
      timeRange: TimeRangeModel(start: '12:00', end: '13:00'),
      weekdays: [1, 2, 3, 4, 5],
      type: 'meal',
      isFlexible: false,
    ),
    ScheduleBlockModel(
      id: '3',
      title: 'Học Flutter',
      timeRange: TimeRangeModel(start: '20:00', end: '21:30'),
      weekdays: [1, 3, 5],
      type: 'study',
      isFlexible: true,
    ),
    ScheduleBlockModel(
      id: '4',
      title: 'Ngủ',
      timeRange: TimeRangeModel(start: '23:30', end: '07:00'),
      weekdays: [1, 2, 3, 4, 5, 6, 7],
      type: 'sleep',
      isFlexible: false,
    ),
    ScheduleBlockModel(
      id: '5',
      title: 'Tập gym',
      timeRange: TimeRangeModel(start: '18:00', end: '18:30'),
      weekdays: [2, 4, 6],
      type: 'exercise',
      isFlexible: true,
    ),
  ];

  Future<List<ScheduleBlockModel>> getScheduleBlocks() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_blocks)..sort((a, b) => a.timeRange.start.compareTo(b.timeRange.start));
  }

  Future<ScheduleBlockModel> addScheduleBlock(ScheduleBlockModel block) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newBlock = block.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    _blocks.add(newBlock);
    return newBlock;
  }

  Future<ScheduleBlockModel> updateScheduleBlock(ScheduleBlockModel block) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _blocks.indexWhere((b) => b.id == block.id);
    if (index != -1) {
      _blocks[index] = block;
      return block;
    }
    throw Exception('Block not found');
  }

  Future<void> deleteScheduleBlock(String blockId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _blocks.removeWhere((b) => b.id == blockId);
  }
}
