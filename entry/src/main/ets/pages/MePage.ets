import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { BookingRecord, SpaceItem, UserProfile, MOCK_RECORDS, MOCK_SPACES, MOCK_USER } from '../model/SpaceModel';

@Entry
@Component
struct MePage {
  // 1. Core States for the User Dashboard
  @State user: UserProfile = MOCK_USER;
  @State bookingRecords: BookingRecord[] = [];
  @State favoriteSpaces: SpaceItem[] = [];

  // Tab State: 0 represents "My Reservations", 1 represents "My Favorites"
  @State activeTab: number = 0;

  aboutToAppear() {
    this.refreshData();
  }

  onPageShow() {
    this.refreshData();
  }

  // Refreshes the local states from the global dataset mocks
  refreshData() {
    this.bookingRecords = [...MOCK_RECORDS];
    this.favoriteSpaces = MOCK_SPACES.filter(item => item.isFavorite);
  }

  // Trigger booking cancellation with an Alert dialog confirmation
  cancelBooking(recordId: string) {
    AlertDialog.show({
      title: '取消预约提醒',
      message: '确定取消该预约吗？取消后此时间段将释放供他人预约。',
      primaryButton: {
        value: '暂不取消',
        action: () => {}
      },
      secondaryButton: {
        value: '确认取消',
        action: () => {
          // Find record in the global dataset and update status
          const recordIndex = MOCK_RECORDS.findIndex(r => r.id === recordId);
          if (recordIndex !== -1) {
            // Update in mock memory
            MOCK_RECORDS[recordIndex].status = 'Cancelled';

            // Re-sync space seat availability simulator
            const spaceId = MOCK_RECORDS[recordIndex].spaceId;
            const space = MOCK_SPACES.find(s => s.id === spaceId);
            if (space) {
              space.availableSeats += 1;
            }

            // Sync reactive page state
            this.refreshData();

            promptAction.showToast({
              message: '预约已成功取消',
              duration: 2000
            });
          }
        }
      }
    });
  }

  build() {
    Column() {
      // --- HEADER & NAVIGATION ---
      Row() {
        Button() {
          Text('🏠')
            .fontSize(18)
        }
        .width(40)
        .height(40)
        .backgroundColor('#F3F4F6')
        .borderRadius(20)
        .onClick(() => {
          // Safely return to Home
          router.replaceUrl({
            url: 'pages/Index'
          });
        })

        Blank().width(12)

        Text('个人中心')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1F2937')
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')

      // --- USER PROFILE CARD (Row/Column Responsive layout) ---
      Row() {
        // User Avatar
        Rect()
          .width(60)
          .height(60)
          .radius(30)
          .fill('#D1D5DB') // Placeholder for avatar
          .margin({ right: 16 })

        Column() {
          Text(this.user.name)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFFFFF')

          Text(this.user.department)
            .fontSize(12)
            .fontColor('#EFF6FF')
            .margin({ top: 4 })

          Text(`学号: ${this.user.studentId}`)
            .fontSize(11)
            .fontColor('#DBEAFE')
            .margin({ top: 4 })
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        // Credit Score Pill
        Column() {
          Text('信用分')
            .fontSize(10)
            .fontColor('#EFF6FF')
          Text(`${this.user.creditScore}`)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFFFFF')
            .margin({ top: 2 })
        }
        .padding(8)
        .backgroundColor('rgba(255,255,255,0.15)')
        .borderRadius(10)
      }
      .width('92%')
      .padding(20)
      .margin({ top: 12, bottom: 16 })
      .backgroundColor('#3B82F6')
      .borderRadius(16)
      .shadow({ radius: 8, color: 'rgba(59,130,246,0.25)', offsetY: 4 })

      // --- TAB SWITCH SEGMENTS ---
      Row() {
        Button('我的预约记录', { type: ButtonType.Normal })
          .layoutWeight(1)
          .height(40)
          .backgroundColor(this.activeTab === 0 ? '#FFFFFF' : 'transparent')
          .fontColor(this.activeTab === 0 ? '#3B82F6' : '#6B7280')
          .fontWeight(this.activeTab === 0 ? FontWeight.Bold : FontWeight.Normal)
          .borderRadius(8)
          .onClick(() => { this.activeTab = 0; })

        Button('我的收藏空间', { type: ButtonType.Normal })
          .layoutWeight(1)
          .height(40)
          .backgroundColor(this.activeTab === 1 ? '#FFFFFF' : 'transparent')
          .fontColor(this.activeTab === 1 ? '#3B82F6' : '#6B7280')
          .fontWeight(this.activeTab === 1 ? FontWeight.Bold : FontWeight.Normal)
          .borderRadius(8)
          .onClick(() => { this.activeTab = 1; })
      }
      .width('92%')
      .backgroundColor('#F3F4F6')
      .borderRadius(10)
      .padding(4)
      .margin({ bottom: 12 })

      // --- TAB CONTENT LISTS ---
      if (this.activeTab === 0) {
        // TAB 1: Reservation Records List
        if (this.bookingRecords.length === 0) {
          Column({ space: 12 }) {
            Text('📭 暂无预约记录')
              .fontSize(14)
              .fontColor('#9CA3AF')
            Button('去逛逛空间', { type: ButtonType.Capsule })
              .fontSize(12)
              .backgroundColor('#3B82F6')
              .onClick(() => {
                router.replaceUrl({ url: 'pages/Index' });
              })
          }
          .width('100%')
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
        } else {
          List({ space: 12 }) {
            ForEach(this.bookingRecords, (record: BookingRecord) => {
              ListItem() {
                Column() {
                  Row() {
                    // Left Image block
                    Rect()
                      .width(48)
                      .height(48)
                      .radius(8)
                      .fill('#E5E7EB')
                      .margin({ right: 12 })

                    Column() {
                      Text(record.spaceName)
                        .fontSize(15)
                        .fontWeight(FontWeight.Bold)
                        .fontColor('#1F2937')

                      Text(`${record.date} | ${record.timeSlot}`)
                        .fontSize(12)
                        .fontColor('#4B5563')
                        .margin({ top: 4 })

                      Text(`座位: ${record.seatNumber}`)
                        .fontSize(12)
                        .fontColor('#6B7280')
                        .margin({ top: 2 })
                    }
                    .alignItems(HorizontalAlign.Start)
                    .layoutWeight(1)

                    // Status Tag
                    Text(record.status === 'Upcoming' ? '已预约' : record.status === 'Completed' ? '已履约' : '已取消')
                      .fontSize(11)
                      .fontColor(record.status === 'Upcoming' ? '#3B82F6' : record.status === 'Completed' ? '#10B981' : '#9CA3AF')
                      .backgroundColor(record.status === 'Upcoming' ? '#EFF6FF' : record.status === 'Completed' ? '#ECFDF5' : '#F3F4F6')
                      .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                      .borderRadius(6)
                  }
                  .width('100%')

                  // Action Row (Cancel booking if Upcoming status)
                  if (record.status === 'Upcoming') {
                    Divider()
                      .color('#F3F4F6')
                      .margin({ top: 12, bottom: 8 })

                    Row() {
                      Blank()
                      Button('取消预约', { type: ButtonType.Normal })
                        .fontSize(12)
                        .height(28)
                        .borderRadius(6)
                        .backgroundColor('#FEF2F2')
                        .fontColor('#EF4444')
                        .onClick(() => {
                          this.cancelBooking(record.id);
                        })
                    }
                    .width('100%')
                  }
                }
                .padding(14)
                .backgroundColor('#FFFFFF')
                .borderRadius(12)
                .shadow({ radius: 6, color: 'rgba(0,0,0,0.03)', offsetY: 2 })
              }
            }, (record: BookingRecord) => record.id)
          }
          .width('100%')
          .layoutWeight(1)
          .padding({ left: 16, right: 16, bottom: 16 })
        }
      } else {
        // TAB 2: Favorite Spaces List
        if (this.favoriteSpaces.length === 0) {
          Column() {
            Text('❤️ 暂无收藏空间')
              .fontSize(14)
              .fontColor('#9CA3AF')
          }
          .width('100%')
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
        } else {
          List({ space: 12 }) {
            ForEach(this.favoriteSpaces, (item: SpaceItem) => {
              ListItem() {
                Row() {
                  Rect()
                    .width(64)
                    .height(64)
                    .radius(8)
                    .fill('#E5E7EB')
                    .margin({ right: 12 })

                  Column() {
                    Text(item.name)
                      .fontSize(15)
                      .fontWeight(FontWeight.Bold)
                      .fontColor('#1F2937')

                    Text(item.location)
                      .fontSize(12)
                      .fontColor('#6B7280')
                      .margin({ top: 4 })

                    Text(`⭐ ${item.rating.toFixed(1)}分`)
                      .fontSize(11)
                      .fontColor('#D97706')
                      .margin({ top: 4 })
                  }
                  .alignItems(HorizontalAlign.Start)
                  .layoutWeight(1)

                  Button('查看详情', { type: ButtonType.Normal })
                    .fontSize(11)
                    .height(26)
                    .borderRadius(6)
                    .backgroundColor('#3B82F6')
                    .fontColor('#FFFFFF')
                    .onClick(() => {
                      router.pushUrl({
                        url: 'pages/DetailPage',
                        params: { spaceId: item.id }
                      });
                    })
                }
                .width('100%')
                .padding(12)
                .backgroundColor('#FFFFFF')
                .borderRadius(12)
                .shadow({ radius: 6, color: 'rgba(0,0,0,0.03)', offsetY: 2 })
              }
            }, (item: SpaceItem) => item.id)
          }
          .width('100%')
          .layoutWeight(1)
          .padding({ left: 16, right: 16, bottom: 16 })
        }
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F9FAFB')
  }
}
