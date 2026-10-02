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
- **Lưu cấu hình thực tế từ máy ngược vào repo:**
  ```bash
  ./install.sh --save
  ```


---

## ⌨️ Bảng Phím tắt Hệ thống (Keybindings)

### 1. Quản lý Cửa sổ & Đa nhiệm
| Phím tắt | Chức năng |
|---|---|
| `Win` (Super) / `Win + Space` | Bật / tắt Start Menu (Launcher kèm ô tìm kiếm) |
| `Win + Tab` | Mở **Task View Thumbnail OSD** (giữ `Win` và bấm `Tab` để duyệt thumbnail, nhả `Win` để vào app) |
| `Alt + Tab` | Chuyển đổi ứng dụng qua lại dạng Thumbnail OSD |
| `Shift + Alt + Tab` | Chuyển lùi về ứng dụng trước đó |
| `Win + D` | Thu nhỏ tất cả cửa sổ để Hiện Desktop (bấm lần nữa để hoàn tác) |
| `Win + F` | Bật / tắt chế độ Toàn màn hình (Fullscreen) |
| `Win + Q` hoặc `Alt + F4` | Đóng cửa sổ hiện tại nhanh bằng tay trái |
| `Win + Mũi tên Lên` | Phóng to cực đại cửa sổ (Maximize) |
| `Win + Mũi tên Xuống` | Thu nhỏ cửa sổ xuống Taskbar (Iconify) |
| `Win + Mũi tên Trái` | Snap chia nửa màn hình sang bên Trái |
| `Win + Mũi tên Phải` | Snap chia nửa màn hình sang bên Phải |

### 2. Ứng dụng & Tiện ích
| Phím tắt | Chức năng |
|---|---|
| `Win + B` | Mở Trình duyệt Web (Brave Browser) |
| `Win + E` | Mở File Manager (Dolphin) |
| `Win + Enter` hoặc `Win + T` | Mở Terminal (Alacritty) |
| `Win + S` hoặc `Win + I` | Mở Cài đặt hệ thống & Giao diện (Noctalia Settings) |
| `Win + R` | Mở hộp thoại chạy lệnh / Launcher |
| `Win + A` | Mở Action Center / Cài đặt nhanh (Wifi, Bluetooth, Âm lượng...) |
| `Win + N` | Mở Trung tâm Thông báo (Notification Center) |
| `Win + V` | Mở Bảng lịch sử Clipboard |
| `Win + L` | Khóa màn hình (Lock screen) |
| `Win + X` | Mở Bảng Nguồn điện (Tắt máy, Khởi động lại...) |
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

# Chuyển đổi giao diện Dark Mode / Light Mode:
noctalia msg theme-mode-toggle

# Đổi hình nền tiếp theo bằng dòng lệnh:
wallpaper-cycle.sh next
```
