#!/bin/bash
# =============================================================================
# Copyright (C) 2019-present Alces Flight Ltd.
#
# This file is part of Flight Desktop.
#
# This program and the accompanying materials are made available under
# the terms of the Eclipse Public License 2.0 which is available at
# <https://www.eclipse.org/legal/epl-2.0>, or alternative license
# terms made available by Alces Flight Ltd - please direct inquiries
# about licensing to licensing@alces-flight.com.
#
# Flight Desktop is distributed in the hope that it will be useful, but
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR
# IMPLIED INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OR CONDITIONS
# OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY OR FITNESS FOR A
# PARTICULAR PURPOSE. See the Eclipse Public License 2.0 for more
# details.
#
# You should have received a copy of the Eclipse Public License 2.0
# along with Flight Desktop. If not, see:
#
#  https://opensource.org/licenses/EPL-2.0
#
# For more information on Flight Desktop, please visit:
# https://github.com/alces-flight/flight-desktop
# ==============================================================================
contains() {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}

IFS=$'\n' groups=(
  $(
    yum grouplist hidden | \
      sed '/^Installed Groups:/,$!d;/^Available Groups:/,$d;/^Installed Groups:/d;s/^[[:space:]]*//'
  )
)

desktop_stage "Prerequisite: polkit policies"
if ! [ -f /etc/polkit-1/localauthority/10-vendor.d/20-flight-desktop-gnome.pkla ]; then
  desktop_miss 'Configuration: polkit policies'
fi

desktop_stage "Prerequisite: X Window System"
if ! contains 'X Window System' "${groups[@]}"; then
  desktop_miss 'Package group: X Window System'
fi

desktop_stage "Prerequisite: Fonts"
if ! contains 'Fonts' "${groups[@]}"; then
  desktop_miss 'Package group: Fonts'
fi

desktop_stage "Prerequisite: GNOME"
if ! contains 'GNOME' "${groups[@]}"; then
  desktop_miss 'Package group: GNOME'
fi

desktop_stage "Prerequisite: evince"
if ! rpm -qa evince | grep -q evince; then
  desktop_miss 'Package: evince'
fi

desktop_stage "Prerequisite: firefox"
if ! rpm -qa firefox | grep -q firefox; then
  desktop_miss 'Package: firefox'
fi