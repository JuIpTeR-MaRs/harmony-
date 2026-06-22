import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { SpaceItem, MOCK_SPACES } from '../model/SpaceModel';

@Entry
@Component
struct Index {
  // 1. Reactive state for quiet spaces data
  @State spaces: SpaceItem[] = MOCK_SPACES;
  // Selected category filter
  @State selectedCategory: string = 'All';
  // Search query
  @State searchQuery: string = '';

  // Filtered spaces based on category and search query
  getFilteredSpaces(): SpaceItem[] {
    return this.spaces.filter(item => {
      const matchCategory = this.selectedCategory === 'All' || item.category === this.selectedCategory;
      const matchSearch = item.name.includes(this.searchQuery) || item.location.includes(this.searchQuery);
      return matchCategory && matchSearch;
    });
  }

  // Toggle favorite status dynamically
  toggleFavorite(spaceId: string) {
    this.spaces = this.spaces.map(item => {
      if (item.id === spaceId) {
        const newFavoriteStatus = !item.isFavorite;
        promptAction.showToast({
          message: newFavoriteStatus ? '已添加至我的收藏' : '已取消收藏',
          duration: 2000
        });

        // Sync to global mock data
        const found = MOCK_SPACES.find(s => s.id === spaceId);
        if (found) {
          found.isFavorite = newFavoriteStatus;
        }

        // Return a new object reference to trigger UI update
        const updatedItem: SpaceItem = {
          id: item.id,
          name: item.name,
          location: item.location,
          category: item.category,
          capacity: item.capacity,
          availableSeats: item.availableSeats,
          facilities: item.facilities,
          description: item.description,
          image: item.image,
          rating: item.rating,
          isBookable: item.isBookable,
          isFavorite: newFavoriteStatus
        };
        return updatedItem;
      }
      return item;
    });
  }

  onPageShow() {
    // Sync spaces state with global MOCK_SPACES when the page is displayed/returned to
    this.spaces = MOCK_SPACES.map(item => {
      const copy: SpaceItem = {
        id: item.id,
        name: item.name,
        location: item.location,
        category: item.category,
        capacity: item.capacity,
        availableSeats: item.availableSeats,
        facilities: item.facilities,
        description: item.description,
        image: item.image,
        rating: item.rating,
        isBookable: item.isBookable,
        isFavorite: item.isFavorite
      };
      return copy;
    });
  }

  build() {
    Column() {
      // --- HEADER SECTION ---
      Row() {
        Column() {
          Text('校园安静空间')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1F2937')
          Text('寻找属于你的专注角落')
            .fontSize(14)
            .fontColor('#6B7280')
            .margin({ top: 4 })
        }
        .alignItems(HorizontalAlign.Start)
        Blank()
        // Shortcut to Profile/Me Page
        Button({ type: ButtonType.Circle }) {
          Text('👤')
            .fontSize(20)
        }
        .width(40)
        .height(40)
        .backgroundColor('#F3F4F6')
        .onClick(() => {
          router.pushUrl({ url: 'pages/MePage' });
        })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 16, bottom: 12 })

      // --- SEARCH BAR ---
      Row() {
        Search({ placeholder: '搜索空间名称、地点...', value: this.searchQuery })
          .width('100%')
          .height(40)
          .backgroundColor('#F3F4F6')
          .placeholderColor('#9CA3AF')
          .onChange((value: string) => {
            this.searchQuery = value;
          })
      }
      .padding({ left: 16, right: 16, bottom: 12 })

      // --- CATEGORY ROW (Responsive horizontally scrollable) ---
      Scroll() {
        Row({ space: 8 }) {
          Button('全部', { type: ButtonType.Capsule })
            .backgroundColor(this.selectedCategory === 'All' ? '#3B82F6' : '#F3F4F6')
            .fontColor(this.selectedCategory === 'All' ? '#FFFFFF' : '#4B5563')
            .height(32)
            .onClick(() => { this.selectedCategory = 'All'; })

          Button('深度静音', { type: ButtonType.Capsule })
            .backgroundColor(this.selectedCategory === 'Silent' ? '#3B82F6' : '#F3F4F6')
            .fontColor(this.selectedCategory === 'Silent' ? '#FFFFFF' : '#4B5563')
            .height(32)
            .onClick(() => { this.selectedCategory = 'Silent'; })

          Button('小组研讨', { type: ButtonType.Capsule })
            .backgroundColor(this.selectedCategory === 'Discussion' ? '#3B82F6' : '#F3F4F6')
            .fontColor(this.selectedCategory === 'Discussion' ? '#FFFFFF' : '#4B5563')
            .height(32)
            .onClick(() => { this.selectedCategory = 'Discussion'; })

          Button('智慧舱', { type: ButtonType.Capsule })
            .backgroundColor(this.selectedCategory === 'StudyRoom' ? '#3B82F6' : '#F3F4F6')
            .fontColor(this.selectedCategory === 'StudyRoom' ? '#FFFFFF' : '#4B5563')
            .height(32)
            .onClick(() => { this.selectedCategory = 'StudyRoom'; })
        }
        .padding({ left: 16, right: 16 })
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .margin({ bottom: 16 })

      // --- LIST AREA (ForEach rendering spaces) ---
      List({ space: 12 }) {
        ForEach(this.getFilteredSpaces(), (item: SpaceItem) => {
          ListItem() {
            Column() {
              Stack({ alignContent: Alignment.TopEnd }) {
                // Background image representation
                Column()
                  .width('100%')
                  .height(140)
                  .backgroundColor('#E5E7EB') // Mock image container
                  .borderRadius({ topLeft: 12, topRight: 12 })

                // Rating & Capacity Row
                Row() {
                  Text(`⭐ ${item.rating.toFixed(1)}`)
                    .fontSize(12)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#D97706')
                    .backgroundColor('#FEF3C7')
                    .padding({ left: 6, right: 6, top: 4, bottom: 4 })
                    .borderRadius(6)

                  Blank().width(8)

                  Text(item.category === 'Silent' ? '🤫 深度静音' : item.category === 'Discussion' ? '🗣️ 小组研讨' : '💻 智慧舱')
                    .fontSize(11)
                    .fontColor('#FFFFFF')
                    .backgroundColor('#374151')
                    .padding({ left: 6, right: 6, top: 4, bottom: 4 })
                    .borderRadius(6)
                }
                .margin({ top: 8, right: 8 })
              }
              .width('100%')
              .height(140)

              // Text info and Actions row
              Row() {
                Column() {
                  Text(item.name)
                    .fontSize(16)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#1F2937')
                  Text(item.location)
                    .fontSize(13)
                    .fontColor('#9CA3AF')
                    .margin({ top: 4 })
                  Text(`容量: ${item.capacity}人  |  空闲: ${item.availableSeats}席`)
                    .fontSize(12)
                    .fontColor('#4B5563')
                    .margin({ top: 6 })
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)

                Column({ space: 10 }) {
                  // Favorite Action
                  Button() {
                    Text(item.isFavorite ? '❤️' : '🤍')
                      .fontSize(18)
                  }
                  .width(36)
                  .height(36)
                  .backgroundColor('#F3F4F6')
                  .onClick((event) => {
                    // Prevent navigation when clicking favorite button
                    this.toggleFavorite(item.id);
                  })

                  // Go to Booking
                  Button('查看详情', { type: ButtonType.Normal })
                    .fontSize(12)
                    .height(28)
                    .borderRadius(6)
                    .backgroundColor('#3B82F6')
                    .fontColor('#FFFFFF')
                    .onClick(() => {
                      // Navigate and pass parameter
                      router.pushUrl({
                        url: 'pages/DetailPage',
                        params: { spaceId: item.id }
                      });
                    })
                }
              }
              .width('100%')
              .padding(12)
            }
            .backgroundColor('#FFFFFF')
            .borderRadius(12)
            .shadow({ radius: 8, color: 'rgba(0,0,0,0.05)', offsetX: 0, offsetY: 4 })
          }
          .onClick(() => {
            // Clicking whole card jumps to detail page too
            router.pushUrl({
              url: 'pages/DetailPage',
              params: { spaceId: item.id }
            });
          })
        }, (item: SpaceItem) => item.id + '_' + item.isFavorite)
      }
      .width('100%')
      .layoutWeight(1)
      .padding({ left: 16, right: 16, bottom: 16 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F9FAFB')
  }
}
