# 🪟 Windows-Style Wayland Dotfiles

> Cấu hình **Labwc + Noctalia** thuần Wayland mang lại trải nghiệm chuẩn Windows 10/11: nhẹ mượt (~500MB RAM DE), tự trích xuất màu Material You từ hình nền và thiết kế **Unbreakable** cho mọi bản phân phối Linux.

---

## ⚡ Cài đặt nhanh

Tương thích tự động: **Arch / CachyOS**, **Fedora**, **Debian / Ubuntu**.

```bash
git clone git@github.com:sfpcshch/dotfiles.git ~/dotfiles && cd ~/dotfiles && ./install.sh
```

- **Chỉ triển khai cấu hình (bỏ qua bước cài gói):**
  ```bash
  ./install.sh --no-pkg
  ```

---

## ⌨️ Phím tắt chuẩn Windows

| Phím tắt | Tác vụ |
|---|---|
| `Win` hoặc `Win + Space` | Mở Start Menu / Launcher tìm kiếm |
| `Win + X` | Menu Nguồn (Tắt máy, Khởi động lại, Khóa màn hình) |
| `Win + D` | Thu nhỏ tất cả cửa sổ về Desktop (bấm lại để hoàn tác) |
| `Win + A` | Quick Settings (Wi-Fi, Bluetooth, Âm lượng, Độ sáng) |
| `Win + N` | Trung tâm Thông báo (Notification Center) |
| `Win + V` | Lịch sử Clipboard |
| `Win + E` | File Explorer (Dolphin dark theme) |
| `Win + Shift + S` hoặc `Print` | Snipping Tool (Chụp ảnh vùng chọn vào clipboard) |
| `Ctrl + Shift + Esc` | Task Manager (`btop`) |
| `Win + Mũi tên` | Aero Snap chia đôi màn hình / Phóng to cực đại |
| `Win + Tab` | Task View Thumbnail OSD (duyệt thumbnail trực quan) |
| `Win + W` / `Win + Shift + W` | Đổi hình nền tiếp theo / lùi lại (Wallhaven Toplist) |

---

## 🖐️ Cử chỉ Touchpad 3 ngón

- **Vuốt 3 ngón XUỐNG**: Thu nhỏ toàn bộ cửa sổ để **Hiện Desktop** (Show Desktop).
- **Vuốt 3 ngón LÊN**: **Khôi phục** lại toàn bộ các cửa sổ về vị trí cũ.
- *(Các thao tác cuộn tự nhiên 2 ngón, tap-to-click, pinch zoom hoạt động mặc định như Windows).*

---

## 💎 Điểm nổi bật
- **Zero Latency**: Aero Snap không độ trễ (`delay=0`), cuộn mượt 120Hz/VRR.
- **Tự đồng bộ Theme**: Bảng màu hệ thống (GTK, Qt6, KDE, Titlebar) tự động trích xuất theo hình nền từ Wallhaven.
- **Unbreakable**: Toàn bộ script bọc guard an toàn, không hardcode đường dẫn, tự động thích ứng khi chuyển distro.
