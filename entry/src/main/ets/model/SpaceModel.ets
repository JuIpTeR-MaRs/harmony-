/**
 * Campus Quiet Space App - Data Models
 */

// 1. Quiet Space Data Structure
export interface SpaceItem {
  id: string;
  name: string;
  location: string;
  category: 'Silent' | 'Discussion' | 'StudyRoom'; // Silent Area, Discussion Area, Study Room
  capacity: number; // Maximum seats
  availableSeats: number; // Available seats
  facilities: string[]; // e.g., ["Wi-Fi", "Charging Outlet", "Air Conditioning", "Whiteboard"]
  description: string;
  image: string; // Image placeholder or local resource name
  rating: number;
  isBookable: boolean;
  isFavorite: boolean; // Managed locally via State
}

// 2. Booking Record Data Structure
export interface BookingRecord {
  id: string;
  spaceId: string;
  spaceName: string;
  spaceImage: string;
  date: string; // e.g., "2026-06-12"
  timeSlot: string; // e.g., "14:00 - 16:00"
  seatNumber: string;
  status: 'Upcoming' | 'Completed' | 'Cancelled';
  bookingTime: string; // When the booking was created
}

// 3. User Profile Data Structure
export interface UserProfile {
  studentId: string;
  name: string;
  department: string;
  avatar: string;
  creditScore: number;
}

// ==========================================
// Static Mock Data for Initial Development
// ==========================================

export const MOCK_SPACES: SpaceItem[] = [
  {
    id: 'space_01',
    name: '图书馆三楼东侧静音室',
    location: '主校区图书馆三楼C区',
    category: 'Silent',
    capacity: 20,
    availableSeats: 8,
    facilities: ['免费Wi-Fi', '独立插座', '静音降噪', '舒适桌椅'],
    description: '位于图书馆东侧的深度静音学习空间，禁止任何有声讨论与电子设备外放，适合需要高度专注的自主学习。',
    image: 'app.media.space_library_silent',
    rating: 4.9,
    isBookable: true,
    isFavorite: false
  },
  {
    id: 'space_02',
    name: '自习楼204小组研讨室',
    location: '第二教学楼自习区2楼',
    category: 'Discussion',
    capacity: 8,
    availableSeats: 4,
    facilities: ['免费Wi-Fi', '智能投影仪', '白板', '多孔排插'],
    description: '中型多功能研讨室，配备高清水写白板与多媒体投影设备，支持开展学术研讨、小组项目与课题交流。',
    image: 'app.media.space_discussion_204',
    rating: 4.7,
    isBookable: true,
    isFavorite: true
  },
  {
    id: 'space_03',
    name: '信息中心101单人智慧舱',
    location: '网络与信息中心一楼大厅旁',
    category: 'StudyRoom',
    capacity: 1,
    availableSeats: 1,
    facilities: ['免费Wi-Fi', '降噪耳机', '多功能充电面板', '新风系统'],
    description: '高集成度单人智慧隔音自习舱，支持恒温新风、灯光亮度和色温调节，是个人线上面试、网课学习的完美选择。',
    image: 'app.media.space_pod_101',
    rating: 4.8,
    isBookable: true,
    isFavorite: false
  },
  {
    id: 'space_04',
    name: '西校区教学楼402静音自习区',
    location: '西校区教学楼四楼',
    category: 'Silent',
    capacity: 50,
    availableSeats: 32,
    facilities: ['免费Wi-Fi', '防眩光台灯', '集中供冷'],
    description: '宽敞的大型自习大厅，配有挡板隔绝视线，保证独立学习空间，光线充足柔和，适合长时间备考。',
    image: 'app.media.space_west_402',
    rating: 4.5,
    isBookable: true,
    isFavorite: false
  }
];

export const MOCK_RECORDS: BookingRecord[] = [
  {
    id: 'bk_001',
    spaceId: 'space_01',
    spaceName: '图书馆三楼东侧静音室',
    spaceImage: 'app.media.space_library_silent',
    date: '2026-06-12',
    timeSlot: '09:00 - 11:00',
    seatNumber: 'A-08号座',
    status: 'Upcoming',
    bookingTime: '2026-06-11 15:30:00'
  },
  {
    id: 'bk_002',
    spaceId: 'space_02',
    spaceName: '自习楼204小组研讨室',
    spaceImage: 'app.media.space_discussion_204',
    date: '2026-06-10',
    timeSlot: '14:00 - 17:00',
    seatNumber: '讨论桌A',
    status: 'Completed',
    bookingTime: '2026-06-09 10:15:00'
  }
];

export const MOCK_USER: UserProfile = {
  studentId: '2023110294',
  name: '张同学',
  department: '计算机科学与技术学院',
  avatar: 'app.media.user_avatar_default',
  creditScore: 100
};
