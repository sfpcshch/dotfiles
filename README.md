# CachyOS & Linux Dotfiles (Labwc + Noctalia)

## 🚀 Cài đặt nhanh

Mở Terminal và chạy 1 dòng lệnh duy nhất:

```bash
git clone https://github.com/sfpcshch/dotfiles.git ~/dotfiles && cd ~/dotfiles && ./install.sh
```

- **Chỉ triển khai cấu hình (không cài lại gói phần mềm):**
  ```bash
  ./install.sh --no-pkg
  ```

---

## 🖐️ Cử chỉ Bàn rê cảm ứng (Trackpad Gestures)

| Thao tác | Tác vụ | Chi tiết thực thi |
|---|---|---|
| **Vuốt 3 ngón XUỐNG** | **Về Desktop** | Thu nhỏ tất cả cửa sổ để hiện Desktop. Vuốt tiếp xuống vẫn giữ nguyên ở Desktop. |
| **Vuốt 3 ngón LÊN** | **Khôi phục cửa sổ** | Kéo lại toàn bộ các cửa sổ về màn hình khi vừa vuốt xuống. Khi cửa sổ đã mở sẵn, vuốt lên giữ nguyên hiện trạng. |
| **Cuộn 2 ngón** | **Cuộn trang tự nhiên** | Cuộn tự nhiên chuẩn Windows (vuốt 2 ngón lên thì nội dung cuộn xuống). |
| **Chạm 1 ngón** | **Click trái** | Chọn / kích hoạt (Tap-to-click). |
| **Chạm 2 ngón** | **Click phải** | Mở Menu ngữ cảnh chuột phải. |
| **Chạm 3 ngón** | **Chuột giữa** | Mở link tab mới trên trình duyệt, đóng tab nhanh. |
| **Chạm đúp giữ 1 ngón** | **Kéo thả (Drag)** | Kéo di chuyển cửa sổ hoặc bôi đen văn bản. |
| **Chụm 2 ngón (Pinch)** | **Zoom in / out** | Phóng to / thu nhỏ tài liệu, ảnh, trang web. |
| **Chống chạm nhầm** | **Tự khóa khi gõ** | Vô hiệu hóa bàn rê khi gõ phím. |

> [!NOTE]
> Đã tắt toàn bộ cử chỉ 4 ngón và vuốt ngang 3 ngón để chống chạm nhầm và nhảy workspace.

---

## ⌨️ Bảng Phím tắt Hệ thống (Keybindings)

### 1. Quản lý Cửa sổ & Đa nhiệm
| Phím tắt | Chức năng |
|---|---|
| `Win` (Super) | Bật / tắt Start Menu (Launcher) |
| `Win + Tab` | Mở **Task View Thumbnail OSD** (giữ `Win` và bấm `Tab` để duyệt thumbnail, nhả `Win` để vào app) |
| `Alt + Tab` | Chuyển đổi ứng dụng qua lại dạng Thumbnail OSD |
| `Shift + Alt + Tab` | Chuyển lùi về ứng dụng trước đó |
| `Win + D` | Thu nhỏ tất cả cửa sổ để Hiện Desktop (bấm lần nữa để hoàn tác) |
| `Win + Mũi tên Lên` | Phóng to cực đại cửa sổ (Maximize) |
| `Win + Mũi tên Xuống` | Thu nhỏ cửa sổ xuống Taskbar (Iconify) |
| `Win + Mũi tên Trái` | Snap chia nửa màn hình sang bên Trái |
| `Win + Mũi tên Phải` | Snap chia nửa màn hình sang bên Phải |
| `Alt + F4` | Đóng cửa sổ hiện tại |

### 2. Ứng dụng & Tiện ích
| Phím tắt | Chức năng |
|---|---|
| `Win + E` | Mở File Manager (Dolphin) |
| `Win + Enter` hoặc `Win + T` | Mở Terminal (Alacritty) |
| `Win + S` hoặc `Win + R` | Mở thanh tìm kiếm / Chạy lệnh nhanh (Launcher) |
| `Win + I` | Mở Cài đặt hệ thống (Settings) |
| `Win + A` | Mở Action Center / Cài đặt nhanh (Wifi, Bluetooth, Âm lượng...) |
| `Win + N` | Mở Trung tâm Thông báo (Notification Center) |
| `Win + V` | Mở Bảng lịch sử Clipboard |
| `Win + L` | Khóa màn hình (Lock screen) |
| `Ctrl + Shift + Esc` | Mở Trình quản lý tác vụ Task Manager (`btop`) |
| `Print` hoặc `Win + Shift + S` | Chụp ảnh màn hình vùng chọn (Snipping Tool) |
| `Shift + Print` | Chụp toàn màn hình |

### 3. Hình nền & Phím chức năng Fn
| Phím tắt | Chức năng |
|---|---|
| `Win + W` | Chuyển sang hình nền tiếp theo (Wallhaven Toplist tự động) |
| `Win + Shift + W` | Lùi về hình nền trước đó |
| `Fn + F1/F2...` (Âm lượng) | Tăng, giảm, ngắt âm lượng, mic (đồng bộ OSD hiển thị) |
| `Fn + F...` (Độ sáng) | Tăng, giảm độ sáng màn hình (đồng bộ OSD hiển thị) |
| `Fn + Media` | Dừng/Phát nhạc, chuyển bài tiếp theo / bài trước |

---

## 🛠️ Lệnh Tiện ích & Quản trị nhanh

```bash
# Nạp lại cấu hình Labwc ngay lập tức:
labwc --reconfigure

# Khởi động lại dịch vụ nhận diện cử chỉ bàn rê:
systemctl --user restart libinput-gestures.service

# Xem trạng thái dịch vụ cử chỉ bàn rê:
systemctl --user status libinput-gestures.service

# Chuyển đổi giao diện Dark Mode / Light Mode:
noctalia msg theme-mode-toggle

# Đổi hình nền tiếp theo bằng dòng lệnh:
wallpaper-cycle.sh next
```
