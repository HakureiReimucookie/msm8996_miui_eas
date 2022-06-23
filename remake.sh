yellow='\033[0;33m'
white='\033[0m'
red='\033[0;31m'
gre='\e[0;32m'
echo -e ""
echo -e "$gre ====================================\n\n Kernel building program !\n\n ===================================="
Start=$(date +"%s")
export ARCH=arm64
export SUBARCH=arm64
export CROSS_COMPILE="/home/lee/gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-"
#export CROSS_COMPILE_ARM32="/home/lee/gcc-arm-10.3-2021.07-x86_64-arm-none-linux-gnueabihf/bin/arm-none-linux-gnueabihf-"
echo -e "$yellow Running make clean before compiling ? \n$white"
echo -n "Enter your choice, 1 or 2 :"
read clean
echo -e "$white"
if [ $clean == 1 ]; then
echo -e "$yellow Remake Now ! \n$white"
make O=out mrproper
elif [ $clean == 2 ]; then
echo -e "$yellow Just Running ! \n$white"
fi
make O=out capricorn_defconfig
export KBUILD_BUILD_HOST="ryzen"
export KBUILD_BUILD_USER="lee"
make O=out -j12
time=$(date +"%d-%m-%y")
End=$(date +"%s")
Diff=$(($End - $Start))
cp ./out/arch/arm64/boot/Image.gz-dtb ./build/Image.gz-dtb
cp ./out/crypto/ansi_cprng.ko ./build/modules/ansi_cprng.ko
cp ./out/drivers/video/backlight/backlight.ko ./build/modules/backlight.ko
cp ./out/net/bridge/br_netfilter.ko ./build/modules/br_netfilter.ko
cp ./out/drivers/video/backlight/generic_bl.ko ./build/modules/generic_bl.ko
cp ./out/drivers/video/backlight/lcd.ko ./build/modules/lcd.ko
cp ./out/drivers/mmc/card/mmc_block_test.ko ./build/modules/mmc_block_test.ko
cp ./out/drivers/mmc/card/mmc_test.ko ./build/modules/mmc_test.ko
cp ./out/drivers/char/rdbg.ko ./build/modules/rdbg.ko
cp ./out/drivers/spi/spidev.ko ./build/modules/spidev.ko
cp ./out/block/test-iosched.ko ./build/modules/test-iosched.ko
cp ./out/drivers/scsi/ufs/ufs_test.ko ./build/modules/ufs_test.ko
cp ./out/drivers/net/wireless/ath/wil6210/wil6210.ko ./build/modules/wil6210.ko
cp ./out/drivers/staging/qcacld-2.0/wlan.ko ./build/modules/wlan.ko
zimage=./out/arch/arm64/boot/Image.gz-dtb
if ! [ -a $zimage ];
then
echo -e "$red << Failed to compile zImage, fix the errors first >>$white"
else
cd ./build
rm *.zip > /dev/null 2>&1
echo -e "$yellow\n Build succesful, generating flashable zip now \n $white"
zip -r Capricorn-MIUI-N-$time.zip * > /dev/null
End=$(date +"%s")
Diff=$(($End - $Start))
echo -e "$yellow $KERNEL_DIR/build/Capricorn-MIUI-N.zip \n$white"
echo -e "$gre << Build completed in $(($Diff / 60)) minutes and $(($Diff % 60)) seconds, variant($qc) >> \n $white"
fi
