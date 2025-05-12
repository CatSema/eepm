#!/bin/sh -x

# It will be run with two args: buildroot spec
BUILDROOT="$1"
SPEC="$2"

PRODUCT=localsend
PRODUCTCUR=localsend_app

. $(dirname $0)/common.sh

move_to_opt /usr/share/localsend_app

add_bin_link_command $PRODUCTCUR
add_bin_link_command $PRODUCT $PRODUCTCUR

add_libs_requires
