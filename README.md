# CachyOS & Linux Desktop Dotfiles
> **Giao diện tinh gọn, siêu nhẹ và hiện đại kết hợp giữa Labwc (Wayland Compositor), Noctalia Desktop Shell, nút tiêu đề chuẩn macOS Traffic Lights, phím tắt quen thuộc chuẩn Windows và bộ gõ tiếng Việt Fcitx5.**

---

## ✨ Tính năng nổi bật của Setup này
1. **Thanh tiêu đề chuẩn macOS (`noctalia-macos`):**
   - Thanh tiêu đề mỏng nhẹ (24px).
   - 3 nút bấm tròn 🔴🟡🟢 sắc nét (đường kính 17px chuẩn vector SVG).
   - Nút đỏ đóng cửa sổ cách đều mép trên và mép phải đúng 5px đối xứng hoàn hảo.
   - Nút xanh hover icon tam giác đối đỉnh ◢ ◤ đặc trưng của macOS.
2. **Thanh tác vụ Noctalia Shell:**
   - Trong suốt mờ nhẹ (translucent 0.75) thấy mờ mờ hình nền phía sau.
   - Phân biệt rõ rệt giữa app đã tắt (mờ 60%) và app đang chạy / minimize (sáng 100%).
3. **Phím tắt quen thuộc chuẩn Windows 10/11:**
   - `Win` (Super): Bật/tắt Start Menu.
   - `Win + D`: Thu nhỏ tất cả cửa sổ để hiện Desktop (bấm lần nữa hoàn tác).
   - `Win + E`: Mở File Manager (Dolphin).
   - `Win + A`: Mở Action Center / Quick Settings.
   - `Win + N`: Mở bảng Thông báo Notifications.
   - `Win + V`: Bảng lịch sử Clipboard.
   - `Win + Shift + S` hoặc `Print`: Chụp ảnh màn hình vùng chọn.
   - `Win + Mũi tên`: Phóng to, thu nhỏ, chia nửa màn hình (Snap).
   - `Alt + F4`: Đóng cửa sổ.
   - `Ctrl + Shift + Esc`: Task Manager (`btop`).
4. **Hệ thống Hình nền tự động Wallhaven (0 MB RAM):**
   - Tự động kéo ảnh nền Toplist chất lượng cao từ Wallhaven.
   - Phím tắt `Win + W`: Đổi sang hình nền tiếp theo ngay lập tức.
   - Phím tắt `Win + Shift + W`: Quay lại hình nền trước.
5. **Bộ gõ tiếng Việt Fcitx5:**
   - Chạy chế độ Pure Wayland mượt mà, gõ tiếng Việt chuẩn xác trong mọi ứng dụng Qt/GTK/Electron/Terminal.

---

## 🚀 Cách kéo và cài đặt 1-Chạm trên máy mới

Khi cài lại CachyOS (hoặc bất kỳ distro Arch-based nào), bạn chỉ cần mở Terminal lên và chạy **1 dòng lệnh duy nhất**:

```bash
git clone https://github.com/sfpcshch/dotfiles.git ~/dotfiles && cd ~/dotfiles && ./install.sh
```

*(Script sẽ tự động kiểm tra cài đủ các gói phần mềm cần thiết, tự sao lưu cấu hình cũ, triển khai theme và phím tắt, bạn không cần phải tự gõ thêm bất kỳ lệnh nào nữa!)*

### Tùy chọn cài đặt:
- **Chỉ triển khai cấu hình (không cài lại phần mềm):**
  ```bash
  ./install.sh --no-pkg
  ```

---

## 📤 Cách lưu trữ lên GitHub cá nhân của bạn ngay bây giờ

Để bạn có thể kéo về bất cứ lúc nào từ internet:

1. Vào [GitHub](https://github.com) tạo một repository mới tên là `dotfiles` (để chế độ **Public** hoặc **Private** tuỳ bạn).
2. Chạy 2 lệnh sau trên terminal của máy này:
   ```bash
   cd ~/dotfiles
   git remote add origin https://github.com/sfpcshch/dotfiles.git
   git push -u origin main
   ```
*(Hoặc dùng SSH nếu đã thêm SSH key: `git remote set-url origin git@github.com:sfpcshch/dotfiles.git`)*

---

## 📂 Cấu trúc thư mục

```text
dotfiles/
├── install.sh                  # Script cài đặt tự động 1 chạm
├── README.md                   # Tài liệu hướng dẫn
├── packages/
│   ├── cachyos-packages.txt    # Danh sách gói phần mềm cho Arch / CachyOS
│   └── generic-packages.txt    # Danh sách gói phần mềm cho Debian / Fedora
├── config/
│   ├── labwc/                  # rc.xml, autostart, environment, menu.xml
│   ├── noctalia/               # config.toml
│   ├── environment.d/          # im.conf
│   ├── fcitx5/                 # Cấu hình bộ gõ tiếng Việt
│   └── alacritty/              # Cấu hình terminal
├── bin/                        # toggle-desktop.sh, wallpaper-*.sh
└── themes/
    └── noctalia-macos/         # themerc + 16 vector SVG macOS buttons
```
