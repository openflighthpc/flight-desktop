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

if ! yum --enablerepo=epel* --disablerepo=epel-testing* repolist | grep -q ^epel; then
  desktop_stage "Enabling repository: EPEL"
  yum -e0 -y install epel-release
  yum makecache
fi

if ! contains 'Xfce' "${groups[@]}"; then
  desktop_stage "Installing package group: Xfce"
  yum --enablerepo=epel* --disablerepo=epel-testing* -e0 -y groupinstall 'Xfce'
fi

if ! rpm -qa evince | grep -q evince; then
  desktop_stage "Installing package: evince"
  yum -e0 -y install evince
fi

if ! rpm -qa firefox | grep -q firefox; then
  desktop_stage "Installing package: firefox"
  yum -e0 -y install firefox
fi

desktop_stage "Prequisites met"