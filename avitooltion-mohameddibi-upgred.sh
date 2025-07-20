#!/bin/bash

# سكربت تحديث متكامل لتوزيعة wolf-mohamed-AVITOOLTION-arch-linux

set -e

echo "===== بدء تحديث النظام wolf-mohamed-AVITOOLTION ====="
echo "التاريخ: $(date)"
echo ""

# تحديث قواعد بيانات الحزم
echo "تحديث قواعد بيانات pacman..."
sudo pacman -Sy --noconfirm

# تحديث الحزم الأساسية
echo "تحديث الحزم الأساسية..."
sudo pacman -Syu --noconfirm

# تنظيف كاش الحزم القديمة
echo "تنظيف كاش الحزم القديمة..."
sudo pacman -Sc --noconfirm

# تحديث paru (إذا مثبت)
if command -v paru &> /dev/null
then
    echo "تحديث paru AUR helper..."
    paru -Syu --noconfirm
fi

# تحديث حزم Python المهمة (في بيئة system-wide أو virtualenv حسب الإعداد)
echo "تحديث حزم Python المهمة..."
python3 -m pip install --upgrade pip setuptools wheel
python3 -m pip install --upgrade tensorflow torch torchvision torchaudio transformers opencv-python openai whisper

# تحديث أدوات Kali و Parrot و BlackArch (إن وجدت)
echo "تحديث أدوات Kali و Parrot و BlackArch (إن وجدت)..."

if [ -d /usr/share/kali-tools ]; then
    echo "تحديث Kali tools..."
    sudo apt update && sudo apt upgrade -y
fi

if [ -d /usr/share/parrot-tools ]; then
    echo "تحديث Parrot tools..."
    sudo parrot-upgrade
fi

if command -v pacman &> /dev/null; then
    echo "تحديث BlackArch tools..."
    sudo pacman -Syu --noconfirm
fi

# تحديث إعدادات الأمان (firewall, SELinux)
echo "إعادة تحميل إعدادات الحماية..."
sudo systemctl restart firewalld || echo "firewalld غير مثبت"
sudo setenforce 1 || echo "SELinux غير مفعل أو غير مثبت"

# تحديث واجهات التحكم الصوتي والذكاء الاصطناعي (Mycroft AI)
echo "تحديث Mycroft AI وبرامج الذكاء الاصطناعي..."
# هنا يمكنك إضافة أوامر خاصة بتحديث Mycroft AI إن وجدت

# تحديث متصفح Tor وبرامج VPN
echo "تحديث متصفح Tor وبرامج VPN..."
sudo systemctl restart tor || echo "tor غير مثبت"
sudo systemctl restart openvpn || echo "OpenVPN غير مثبت"
sudo systemctl restart wg-quick@wg0 || echo "WireGuard غير مثبت"

# تنظيف النظام النهائي
echo "تنظيف ملفات مؤقتة..."
sudo journalctl --vacuum-time=7d

echo ""
echo "===== تم تحديث النظام بنجاح! ====="
echo "تاريخ الانتهاء: $(date)"
