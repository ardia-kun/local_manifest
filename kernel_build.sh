# Install dependencies
# -- to be added --

# clone clang and gcc
git clone https://github.com/Nicklas373/aosp-clang -b r412851 clang-llvm
git clone --depth=1 https://github.com/arter97/arm32-gcc.git gcc32
git clone --depth=1 https://github.com/mvaisakh/gcc-arm64.git gcc64

# Apply KernelSU
# -- to be added --

# Build
# Prepare
make -j$(nproc --all) O=out ARCH=arm64 CC=$(pwd)/clang-llvm/bin/clang CROSS_COMPILE=$(pwd)/gcc64/bin/aarch64-linux-android- CLANG_TRIPLE=aarch64-linux-gnu- LLVM_IAS=1 vendor/fog-perf_defconfig
# Execute
make -j$(nproc --all) O=out ARCH=arm64 CC=$(pwd)/clang-llvm/bin/clang CROSS_COMPILE=$(pwd)/gcc64/bin/aarch64-linux-android- CLANG_TRIPLE=aarch64-linux-gnu- LLVM_IAS=1

# Package
git clone --depth=1 https://github.com/alternoegraha/AnyKernel3-680 -b master AnyKernel3
cp -R out/arch/arm64/boot/Image.gz AnyKernel3/Image.gz
# Zip it and upload it
cd AnyKernel3
zip -r Mi680-WeatheringWithYou-test . -x ".git*" -x "README.md" -x "*.zip"
curl -T Mi680-WeatheringWithYou-test.zip https://pixeldrain.com/api/file/
# finish
cd ..
rm -rf out/
echo "Build finished"
