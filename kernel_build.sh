TIMESTAMP=$(date +%s)

# Install dependencies
sudo apt update && sudo apt install -y bc cpio nano bison ca-certificates curl flex gcc git libc6-dev libssl-dev openssl python-is-python3 ssh wget zip zstd sudo make clang gcc-arm-linux-gnueabi software-properties-common build-essential libarchive-tools gcc-aarch64-linux-gnu

# clone clang and gcc
git clone https://github.com/Nicklas373/aosp-clang -b r412851 clang-llvm

# Set kbuild
KBUILD_BUILD_USER=alternoegraha
KBUILD_BUILD_HOST=localhost

# Apply KernelSU
curl -LSs "https://raw.githubusercontent.com/tiann/KernelSU/main/kernel/setup.sh" | bash -
cd KernelSU && git rev-list --count HEAD
cd ..
patch -p1 < ksu_patches/KernelSU.patch
patch -p1 < ksu_patches/KernelSU_umount.patch

# Build
# Prepare
make -j$(nproc --all) O=out ARCH=arm64 CC=$(pwd)/clang-llvm/bin/clang CROSS_COMPILE=aarch64-linux-gnu- CLANG_TRIPLE=aarch64-linux-gnu- LLVM_IAS=1 vendor/fog-perf_defconfig
# Execute
make -j$(nproc --all) O=out ARCH=arm64 CC=$(pwd)/clang-llvm/bin/clang CROSS_COMPILE=aarch64-linux-gnu- CLANG_TRIPLE=aarch64-linux-gnu- LLVM_IAS=1

# Package
git clone --depth=1 https://github.com/alternoegraha/AnyKernel3-680 -b master AnyKernel3
cp -R out/arch/arm64/boot/Image.gz AnyKernel3/Image.gz
# Zip it and upload it
cd AnyKernel3
zip -r Mi680-WeatheringWithYou-"$TIMESTAMP"-testing . -x ".git*" -x "README.md" -x "*.zip"
curl -T Mi680-WeatheringWithYou-"$TIMESTAMP"-testing.zip https://pixeldrain.com/api/file/
# finish
cd ..
rm -rf out/ AnyKernel3/ drivers/kernelsu KernelSU/
echo "Build finished"
