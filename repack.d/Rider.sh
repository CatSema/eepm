#!/bin/sh -x

# It will be run with two args: buildroot spec
BUILDROOT="$1"
SPEC="$2"

PRODUCT=rider
PRODUCTCUR=JetBrains.Rider
PRODUCTSUBDIR="JetBrains Rider"

. $(dirname $0)/common.sh

subst "s|^Group:.*|Group: Development/Tools|" $SPEC
#subst "s|^License: unknown$|License: GPLv2|" $SPEC
subst "s|^URL:.*|URL: https://www.jetbrains.com/rider/|" $SPEC
subst "s|^Summary:.*|Summary: A cross-platform IDE for .NET and game developers|" $SPEC

# move_to_opt can't expand wildcard if path with spaces
VERSION=$(grep "^Version:" $SPEC | sed -e "s|Version: ||")
move_to_opt "/$PRODUCTSUBDIR-$VERSION" || fatal

add_bin_link_command $PRODUCT $PRODUCTDIR/bin/$PRODUCT.sh
add_bin_link_command $PRODUCTCUR $PRODUCT

cat <<EOF | create_file /usr/share/applications/$PRODUCT.desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=JetBrains.Rider
Comment=IDE for .NET and game developers
Exec=$PRODUCT %f
Icon=$PRODUCT
Terminal=false
StartupNotify=true
StartupWMClass=jetbrains-rider
Categories=Development;IDE
EOF

install_file $PRODUCTDIR/bin/$PRODUCT.png /usr/share/pixmaps/$PRODUCT.png
install_file $PRODUCTDIR/bin/$PRODUCT.svg /usr/share/pixmaps/$PRODUCT.svg

exit
# kind of hack
subst 's|%dir "'$PRODUCTDIR'/"||' $SPEC
subst 's|%dir "'$PRODUCTDIR'/bin/"||' $SPEC
subst 's|%dir "'$PRODUCTDIR'/lib/"||' $SPEC
subst 's|%dir "'$PRODUCTDIR'/plugins/"||' $SPEC

pack_dir $PRODUCTDIR/
pack_dir $PRODUCTDIR/bin/
pack_dir $PRODUCTDIR/lib/
pack_dir $PRODUCTDIR/plugins/
