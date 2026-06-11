import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { SpaceItem, MOCK_SPACES } from '../model/SpaceModel';
import { LengthMetrics } from '@kit.ArkUI';
@Entry
@Component
struct DetailPage {
  @State spaceId: string = '';
  @State spaceItem: SpaceItem | null = null;
  @State isFavorite: boolean = false;

  aboutToAppear() {
    // 1. Retrieve the parameters passed during routing
    const params = router.getParams() as Record<string, Object>;
    if (params && params.spaceId) {
      this.spaceId = params.spaceId as string;
      // Find the space details
      const found = MOCK_SPACES.find(item => item.id === this.spaceId);
      if (found) {
        this.spaceItem = found;
        this.isFavorite = found.isFavorite;
      }
    }
  }

  toggleFavorite() {
    if (this.spaceItem) {
      this.isFavorite = !this.isFavorite;
      // Update state in our object (representing dynamic update)
      this.spaceItem.isFavorite = this.isFavorite;

      promptAction.showToast({
        message: this.isFavorite ? '已收藏该安静空间' : '已取消收藏',
        duration: 2000
      });
    }
  }

  build() {
    Column() {
      if (this.spaceItem) {
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

          Text('空间详情')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1F2937')

          Blank()

          // Header Favorite Button
          Button() {
            Text(this.isFavorite ? '❤️' : '🤍')
              .fontSize(20)
          }
          .width(40)
          .height(40)
          .backgroundColor('#F3F4F6')
          .borderRadius(20)
          .onClick(() => {
            this.toggleFavorite();
          })
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#FFFFFF')

        // --- SCROLL CONTENT ---
        Scroll() {
          Column() {
            // Space Mock Image Banner
            Rect()
              .width('100%')
              .height(220)
              .fill('#E5E7EB')
              .radius(16)
              .margin({ bottom: 16 })

            // Title and Category Badge
            Row() {
              Text(this.spaceItem.name)
                .fontSize(22)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1F2937')
                .layoutWeight(1)
            }
            .width('100%')
            .margin({ bottom: 8 })

            // Rating & Location Row
            Row() {
              Text(`⭐ ${this.spaceItem.rating.toFixed(1)}分`)
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .fontColor('#D97706')

              Text(' | ')
                .fontColor('#D1D5DB')
                .margin({ left: 8, right: 8 })

              Text(this.spaceItem.location)
                .fontSize(14)
                .fontColor('#4B5563')
                .layoutWeight(1)
            }
            .width('100%')
            .margin({ bottom: 16 })

            // Capacity & Availability Info Grid
            Row({ space: 12 }) {
              // Card 1: Capacity
              Column() {
                Text('总容纳人数')
                  .fontSize(12)
                  .fontColor('#6B7280')
                Text(`${this.spaceItem.capacity} 人`)
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#1F2937')
                  .margin({ top: 4 })
              }
              .layoutWeight(1)
              .backgroundColor('#F3F4F6')
              .padding(12)
              .borderRadius(10)
              .alignItems(HorizontalAlign.Start)

              // Card 2: Status
              Column() {
                Text('当前空闲席位')
                  .fontSize(12)
                  .fontColor('#6B7280')
                Text(`${this.spaceItem.availableSeats} 席`)
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#10B981')
                  .margin({ top: 4 })
              }
              .layoutWeight(1)
              .backgroundColor('#ECFDF5')
              .padding(12)
              .borderRadius(10)
              .alignItems(HorizontalAlign.Start)
            }
            .width('100%')
            .margin({ bottom: 20 })

            // Facilities Section (Flexible layout with multi-line wrap)
            Text('设施与服务')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1F2937')
              .margin({ bottom: 10 })

            Flex({ wrap: FlexWrap.Wrap, space: { main: LengthMetrics.vp(8), cross: LengthMetrics.vp(8) } }) {
              ForEach(this.spaceItem.facilities, (facility: string) => {
                Text(facility)
                  .fontSize(12)
                  .fontColor('#3B82F6')
                  .backgroundColor('#EFF6FF')
                  .padding({ left: 12, right: 12, top: 6, bottom: 6 })
                  .borderRadius(16)
              })
            }
            .width('100%')
            .margin({ bottom: 20 })

            // Description Section
            Text('空间介绍')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1F2937')
              .margin({ bottom: 8 })

            Text(this.spaceItem.description)
              .fontSize(14)
              .fontColor('#4B5563')
              .lineHeight(22)
              .margin({ bottom: 32 })
          }
          .alignItems(HorizontalAlign.Start)
          .padding({ left: 16, right: 16 })
        }
        .layoutWeight(1)

        // --- BOTTOM ACTION BAR ---
        Row() {
          Button('立即预约', { type: ButtonType.Normal })
            .width('100%')
            .height(48)
            .borderRadius(24)
            .backgroundColor('#3B82F6')
            .fontColor('#FFFFFF')
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              if (this.spaceItem && this.spaceItem.isBookable) {
                // Navigate to BookingPage and pass spaceId
                router.pushUrl({
                  url: 'pages/BookingPage',
                  params: { spaceId: this.spaceItem.id }
                });
              } else {
                promptAction.showToast({
                  message: '该空间目前不可预订',
                  duration: 2000
                });
              }
            })
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#FFFFFF')
        .shadow({ radius: 10, color: 'rgba(0,0,0,0.05)', offsetY: -4 })
      } else {
        // Fallback for errors or missing spaceId
        Column() {
          Text('未找到对应空间信息')
            .fontSize(16)
            .fontColor('#9CA3AF')
          Button('返回首页')
            .margin({ top: 16 })
            .onClick(() => {
              router.back();
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

