#!/bin/bash

set -e
#Credit to Meghthedev for the initial script 

# init
repo init --depth 1 -u https://github.com/LineageOS/android.git -b lineage-20.0 --git-lfs

# Run inside foss.crave.io devspace
# Remove existing local_manifests
crave run --clean --no-patch -- "rm -rf .repo/local_manifests && \

# sync repo
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags && \ 

# sync tree
git clone -b wip/round-corner-experimentations https://github.com/alternoegraha/device_xiaomi_fog device/xiaomi/fog && \

# clone hardware/xiaomi
git clone https://github.com/LineageOS/android_hardware_xiaomi hardware/xiaomi && \

# Set up build environment
source build/envsetup.sh && \

# Lunch configuration
lunch lineage_fog-userdebug && \

# Build the ROM
mka bacon"

# Pull generated zip files
crave pull out/target/product/*/*.zip
