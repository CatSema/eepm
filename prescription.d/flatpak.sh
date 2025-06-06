#!/bin/sh

SUPPORTEDARCHES=''
DESCRIPTION="Add flatpak support to system"

. $(dirname $0)/common.sh

assure_root

[ "$(epm print info -s)" = "alt" ] || fatal "Only ALTLinux is supported"

# Исправляет ошибку "enabling unprivileged user namespaces" без перезагрузки
a= sysctl -w kernel.unprivileged_userns_clone=1

install_portals=""

while read -r window_manager package ; do
    if epm installed $window_manager </dev/null ; then
        install_portals+=" $package"
    fi
done <<EOF
    plasma5-kwin        plasma5-xdg-desktop-portal-kde
    deepin-kwin2        xdg-desktop-portal-dde
    gnome-shell         xdg-desktop-portal-gnome
    xfwm4               xdg-desktop-portal-gtk
    mate-window-manager xdg-desktop-portal-gtk
    sway                xdg-desktop-portal-wlr
    hyprland            xdg-desktop-portal-hyprland
    muffin              xdg-desktop-portal-xapp
    liblxqt             xdg-desktop-portal-lxqt
    lxde-common         xdg-desktop-portal-gtk
    kwin                xdg-desktop-portal-kde
EOF

epm install --skip-installed $install_portals xdg-desktop-portal

epm install --skip-installed flatpak flatpak-repo-flathub sysctl-conf-userns

if epm installed plasma5-discover ; then
    epm install --skip-installed plasma5-discover-flatpak
fi

if epm installed plasma-discover ; then
    epm install --skip-installed plasma-discover-flatpak
fi

# Без перезагрузки dbus, порталы не заработают
serv dbus reload

# C версии 0.10.0-alt1.1 bubblewrap собирается с опцией priv_mode=none поэтому фикс не нужен
if [ ! $(epm depends bubblewrap | grep sysctl-conf-userns) ]; then
    epm prescription bwrap-fix
fi

echo "You need to log out of the session for flatpak to work."
