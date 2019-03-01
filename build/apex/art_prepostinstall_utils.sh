#!/system/bin/sh

# Copyright (C) 2019 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

alias log_info="log -t art_apex -p i"
alias log_error="log -t art_apex -p f"

# Set |ARCHES| to a string containing the architectures of the device.
function set_arches {
  # Derive architectures. For now, stop at two.
  local abilist_prop=`getprop ro.product.cpu.abilist`
  local abilist=`echo $abilist_prop | tr "," "\n"`
  ARCHES=""
  for abi in $abilist ; do
    case "$abi" in
      arm64-v8a)
        ARCHES="$ARCHES\narm64"
        ;;
      armeabi-v7a|armeabi)
        ARCHES="$ARCHES\narm"
        ;;
      x86)
        ARCHES="$ARCHES\nx86"
        ;;
      x86_64)
        ARCHES="$ARCHES\nx86_64"
        ;;
      *)
        log_error "Unsupported ABI $abi"
        return 1
        ;;
    esac
  done
  ARCHES=`echo $ARCHES | uniq`
  return 0
}
