#!/bin/sh

PKGNAME=yandex-telemost
SUPPORTEDARCHES="x86_64"
DESCRIPTION='Yandex telemost from the official site'
URL="https://www.commfort.com/ru/article-commfort-linux.shtml"

. $(dirname $0)/common.sh

warn_version_is_not_supported

VERSION="1.0.0"
PKGURL="https://telemost.yandex.ru/download-desktop"

install_pack_pkgurl $VERSION
