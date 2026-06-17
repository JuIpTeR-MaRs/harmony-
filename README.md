# 校园安静空间预约系统 (Campus Quiet Space App)

这是一个基于 HarmonyOS (OpenHarmony) 开发的校园自习/安静空间预约应用程序。项目采用声明式 UI 框架 ArkUI 以及 ArkTS (TypeScript 的超集) 语言进行构建。

该应用旨在帮助高校学生快速寻找、筛选并预订校园内的深度静音自习室、小组研讨室以及个人智能智慧舱，从而提升学习效率并优化校园公共资源的利用。

---

## 📸 应用界面与核心功能

本应用包含了四个核心业务页面：

| 页面 | 说明 | 核心功能 |
| :--- | :--- | :--- |
| **🔍 空间大厅 (Index)** | 应用首页 | <ul><li>按分类（深度静音、小组研讨、个人智慧舱）进行快速过滤</li><li>根据空间名称、地点进行关键词模糊搜索</li><li>一键添加/取消收藏，实时吐司提示</li><li>查看每个空间的星级评分、容量和当前空闲席位</li></ul> |
| **📄 空间详情 (DetailPage)** | 空间的信息展示页 | <ul><li>查看空间的图文介绍和详细描述</li><li>动态加载服务设施标签（如免费 Wi-Fi、插座、降噪耳机、投影仪等）</li><li>实时计算与显示当前剩余空闲席位</li><li>收藏状态的双向联动同步</li></ul> |
| **📅 预约办理 (BookingPage)** | 选座与预约提交页 | <ul><li>预约日期与时间段的自主选择</li><li>可视化座位选择（支持单人座、研讨桌及多席位选择）</li><li>预约确认及信用分规则校验</li></ul> |
| **👤 个人中心 (MePage)** | 个人数据及订单管理页 | <ul><li>个人信息管理（展示头像、学号、学院及当前的信誉积分）</li><li>分类查看预约历史订单（包括：**进行中/未开始**、**已完成**、**已取消**）</li></ul> |

---

## 🛠️ 技术栈与环境要求

- **开发工具**：Huawei DevEco Studio (建议支持 API 9 及以上版本)
- **开发语言**：ArkTS (TypeScript) / CSS 样式
- **UI 框架**：声明式 UI 框架 ArkUI
- **构建工具**：Hvigor (OpenHarmony 原生构建系统)
- **操作系统**：HarmonyOS 4.0 / OpenHarmony 4.0 及以上版本 (API Version 9+)

---

## 📂 项目目录结构说明

```text
harmonyText
├── AppScope                  # 全局公共资源和应用配置文件
├── entry                     # 应用主模块 (HAP)
│   ├── src
│   │   └── main
│   │       ├── ets           # ArkTS 源代码目录
│   │       │   ├── entryability   # 应用生命周期及入口控制
│   │       │   ├── entrybackupability  # 备份服务
│   │       │   ├── model          # 数据模型与静态 Mock 数据
│   │       │   │   └── SpaceModel.ets  # 空间、预约订单、用户信息的定义及初始数据
│   │       │   └── pages          # 业务视图页面
│   │       │       ├── Index.ets        # 首页：自习空间列表与搜索过滤
│   │       │       ├── DetailPage.ets   # 详情页：设施、说明与预约入口
│   │       │       ├── BookingPage.ets  # 预约页：日期时间及座位选取
│   │       │       └── MePage.ets       # 我的：信誉分、个人信息及预约状态管理
│   │       ├── module.json5  # entry 模块配置文件（权限、Ability等）
│   │       └── resources     # entry 资源目录（图形、字符串、媒体资源等）
│   ├── build-profile.json5   # 模块级编译构建配置文件
│   └── hvigorfile.ts         # 模块级构建脚本
├── build-profile.json5       # 工程级编译构建配置文件
├── hvigorfile.ts             # 工程级构建脚本
├── oh-package.json5          # 工程三方依赖配置文件
└── README.md                 # 说明文档
```

---

## 🚀 快速上手与运行步骤

1. **导入工程**：
   打开 Huawei DevEco Studio，选择 `File -> Open`，定位并打开本工程根目录 (`harmonyText`)。

2. **同步依赖**：
   DevEco Studio 会自动执行 Gradle/Hvigor 的初始化。如果没有自动安装三方包，可以点击编辑器上方的 `Sync Now`，或者在终端执行：
   ```bash
   ohpm install
   ```

3. **配置签名 (若真机调试)**：
   如果是连接真机，请在 `File -> Project Structure -> Signing Configs` 中勾选 `Automatically generate signature` 进行自动签名。

4. **运行应用**：
   - 打开 DevEco Studio 的虚拟机/真机管理器，启动一个 API 9+ 的手机或平板设备。
   - 点击顶部工具栏的绿色运行按钮 `Run 'entry'` 即可编译并安装应用。
