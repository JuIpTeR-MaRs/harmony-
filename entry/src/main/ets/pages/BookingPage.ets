import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { SpaceItem, BookingRecord, MOCK_SPACES, MOCK_RECORDS } from '../model/SpaceModel';
import { LengthMetrics } from '@kit.ArkUI';
@Entry
@Component
struct BookingPage {
  @State spaceId: string = '';
  @State spaceItem: SpaceItem | null = null;

  // Form States
  @State selectedDate: string = '2026-06-12';
  @State selectedTimeSlot: string = '';
  @State selectedSeat: string = '';

  // Options
  private timeSlots: string[] = [
    '08:00 - 10:00',
    '10:00 - 12:00',
    '12:00 - 14:00',
    '14:00 - 16:00',
    '16:00 - 18:00',
    '18:00 - 20:00'
  ];

  private seats: string[] = ['A-01号座', 'A-02号座', 'A-03号座', 'B-01号座', 'B-02号座', 'C-05号座'];

  aboutToAppear() {
    const params = router.getParams() as Record<string, Object>;
    if (params && params.spaceId) {
      this.spaceId = params.spaceId as string;
      const found = MOCK_SPACES.find(item => item.id === this.spaceId);
      if (found) {
        this.spaceItem = found;
      }
    }
  }

  // Handle booking form submission
  handleBookingSubmit() {
    // 1. Validation
    if (!this.selectedDate) {
      promptAction.showToast({ message: '请选择预约日期', duration: 2000 });
      return;
    }
    if (!this.selectedTimeSlot) {
      promptAction.showToast({ message: '请选择预约时间段', duration: 2000 });
      return;
    }
    if (!this.selectedSeat) {
      promptAction.showToast({ message: '请选择座位或研讨桌', duration: 2000 });
      return;
    }

    if (!this.spaceItem) return;

    // 2. Interactive Dialog Confirmation
    AlertDialog.show({
      title: '确认提交预约？',
      message: `预约空间: ${this.spaceItem.name}\n日期: ${this.selectedDate}\n时段: ${this.selectedTimeSlot}\n座位: ${this.selectedSeat}\n\n提交后可在“我的”页面查看及取消。`,
      autoCancel: true,
      alignment: DialogAlignment.Bottom,
      offset: { dx: 0, dy: -20 },
      primaryButton: {
        value: '取消',
        action: () => {
          promptAction.showToast({ message: '已取消操作', duration: 1500 });
        }
      },
      secondaryButton: {
        value: '确认预约',
        action: () => {
          this.createBookingRecord();
        }
      }
    });
  }

  // Generate and insert the record into local storage simulator
  createBookingRecord() {
    if (!this.spaceItem) return;

    const newRecord: BookingRecord = {
      id: `bk_${Date.now()}`,
      spaceId: this.spaceItem.id,
      spaceName: this.spaceItem.name,
      spaceImage: this.spaceItem.image,
      date: this.selectedDate,
      timeSlot: this.selectedTimeSlot,
      seatNumber: this.selectedSeat,
      status: 'Upcoming',
      bookingTime: new Date().toISOString().replace('T', ' ').substring(0, 19)
    };

    // Push into our static dataset
    MOCK_RECORDS.unshift(newRecord);

    // Prompt Toast
    promptAction.showToast({
      message: '预约成功！已为您生成预订凭证。',
      duration: 3000
    });

    // Jump to MePage (clear routes hierarchy to make MePage the root or replace)
    router.replaceUrl({
      url: 'pages/MePage'
    });
  }

  build() {
    Column() {
      // --- NAVIGATION HEADER ---
      Row() {
        Button() {
          Text('◀')
            .fontSize(16)
            .fontColor('#1F2937')
            .fontWeight(FontWeight.Bold)
        }
        .width(40)
        .height(40)
        .backgroundColor('#F3F4F6')
        .borderRadius(20)
        .onClick(() => {
          router.back();
        })

        Blank().width(12)

        Text('提交预约申请')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1F2937')
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')

      if (this.spaceItem) {
        Scroll() {
          Column() {
            // Selected Space Card (Brief details)
            Row() {
              Column() {
                Text('预约空间信息')
                  .fontSize(12)
                  .fontColor('#3B82F6')
                  .fontWeight(FontWeight.Bold)
                Text(this.spaceItem.name)
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#1F2937')
                  .margin({ top: 4 })
                Text(`📍 ${this.spaceItem.location}`)
                  .fontSize(13)
                  .fontColor('#6B7280')
                  .margin({ top: 4 })
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)
            }
            .width('100%')
            .backgroundColor('#EFF6FF')
            .padding(16)
            .borderRadius(12)
            .margin({ top: 12, bottom: 20 })

            // Section 1: Date Picker Trigger
            Text('1. 选择预约日期')
              .fontSize(15)
              .fontWeight(FontWeight.Bold)
              .fontColor('#374151')
              .margin({ bottom: 10 })

            Row() {
              Text(this.selectedDate)
                .fontSize(16)
                .fontColor('#1F2937')
                .layoutWeight(1)

              Button('更改日期', { type: ButtonType.Normal })
                .fontSize(12)
                .height(30)
                .borderRadius(6)
                .backgroundColor('#3B82F6')
                .onClick(() => {
                  DatePickerDialog.show({
                    start: new Date('2026-06-11'),
                    end: new Date('2026-06-25'),
                    selected: new Date(this.selectedDate),
                    onAccept: (value: DatePickerResult) => {
                      this.selectedDate = `${value.year}-${(value.month !== undefined ? value.month + 1 : 1).toString().padStart(2, '0')}-${(value.day !== undefined ? value.day : 1).toString().padStart(2, '0')}`;
                    }
                  });
                })
            }
            .width('100%')
            .padding(12)
            .backgroundColor('#FFFFFF')
            .borderRadius(10)
            .margin({ bottom: 20 })

            // Section 2: Time Slots Picker
            Text('2. 选择时段')
              .fontSize(15)
              .fontWeight(FontWeight.Bold)
              .fontColor('#374151')
              .margin({ bottom: 10 })

            // Grid Layout for time slots (Responsive design with wrapping Columns/Rows)
            Flex({ wrap: FlexWrap.Wrap, space: { main: LengthMetrics.vp(8), cross: LengthMetrics.vp(8) } }) {
              ForEach(this.timeSlots, (slot: string) => {
                Button(slot, { type: ButtonType.Normal })
                  .borderRadius(8)
                  .backgroundColor(this.selectedTimeSlot === slot ? '#EFF6FF' : '#FFFFFF')
                  .fontColor(this.selectedTimeSlot === slot ? '#3B82F6' : '#4B5563')
                  .borderWidth(1)
                  .borderColor(this.selectedTimeSlot === slot ? '#3B82F6' : '#E5E7EB')
                  .height(44)
                  .padding({ left: 16, right: 16 })
                  .onClick(() => {
                    this.selectedTimeSlot = slot;
                  })
              })
            }
            .width('100%')
            .margin({ bottom: 20 })

            // Section 3: Seats Selection
            Text('3. 选择座席位置')
              .fontSize(15)
              .fontWeight(FontWeight.Bold)
              .fontColor('#374151')
              .margin({ bottom: 10 })

            Flex({ wrap: FlexWrap.Wrap, space: { main: LengthMetrics.vp(8), cross: LengthMetrics.vp(8) } }) {
              ForEach(this.seats, (seat: string) => {
                Button(seat, { type: ButtonType.Normal })
                  .borderRadius(8)
                  .backgroundColor(this.selectedSeat === seat ? '#EFF6FF' : '#FFFFFF')
                  .fontColor(this.selectedSeat === seat ? '#3B82F6' : '#4B5563')
                  .borderWidth(1)
                  .borderColor(this.selectedSeat === seat ? '#3B82F6' : '#E5E7EB')
                  .height(40)
                  .padding({ left: 16, right: 16 })
                  .onClick(() => {
                    this.selectedSeat = seat;
                  })
              })
            }
            .width('100%')
            .margin({ bottom: 32 })
          }
          .alignItems(HorizontalAlign.Start)
          .padding({ left: 16, right: 16 })
        }
        .layoutWeight(1)

        // --- SUBMIT CONTAINER ---
        Row() {
          Button('提交预约申请', { type: ButtonType.Normal })
            .width('100%')
            .height(48)
            .borderRadius(24)
            .backgroundColor('#3B82F6')
            .fontColor('#FFFFFF')
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.handleBookingSubmit();
            })
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#FFFFFF')
        .shadow({ radius: 10, color: 'rgba(0,0,0,0.05)', offsetY: -4 })
      } else {
        Column() {
          Text('预约发生错误：无空间参数')
            .fontSize(16)
            .fontColor('#EF4444')
          Button('回到首页')
            .margin({ top: 16 })
            .onClick(() => {
              router.clear();
              router.pushUrl({ url: 'pages/Index' });
            })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F9FAFB')
  }
}

