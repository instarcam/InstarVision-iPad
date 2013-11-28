#!/bin/bash

SDKVERSION="7.0"

ARCHS="armv7 armv7s i386"

DEVELOPER=`xcode-select -print-path`

ROOTDIR="${PWD}"

BUILDDIR="build-ios"
rm -r $BUILDDIR
mkdir $BUILDDIR

########################################

for ARCH in ${ARCHS}
do
if [ "${ARCH}" == "i386" ];
then
PLATFORM="iPhoneSimulator"
EXTRA_CONFIG="--arch=i386 --disable-asm --enable-cross-compile --target-os=darwin --cpu=i386"
EXTRA_CFLAGS="-arch i386"
EXTRA_LDFLAGS="-I${DEVELOPER}/Platforms/${PLATFORM}.platform/Developer/SDKs/${PLATFORM}${SDKVERSION}.sdk/usr/lib -mfpu=neon"
elif [ "${ARCH}" == "armv7s" ];
then
PLATFORM="iPhoneOS"
EXTRA_CONFIG="--arch=arm --target-os=darwin --enable-cross-compile --cpu=cortex-a9 --disable-armv5te"
EXTRA_CFLAGS="-w -arch ${ARCH} -mfpu=neon"
EXTRA_LDFLAGS="-mfpu=neon"
elif [ "${ARCH}" == "armv7" ];
then
PLATFORM="iPhoneOS"
EXTRA_CONFIG="--arch=arm --target-os=darwin --enable-cross-compile --cpu=cortex-a8 --disable-armv5te"
EXTRA_CFLAGS="-w -arch ${ARCH} -mfpu=neon"
EXTRA_LDFLAGS="-mfpu=neon"
else
PLATFORM="iPhoneOS"
EXTRA_CONFIG="--arch=arm --target-os=darwin --enable-cross-compile --cpu=cortex-a9 --disable-armv5te"
EXTRA_CFLAGS="-w -arch ${ARCH} -mfpu=neon"
EXTRA_LDFLAGS="-mfpu=neon"
fi

mkdir "${BUILDDIR}/${ARCH}"

./configure --prefix="${BUILDDIR}/${ARCH}" --disable-ffmpeg --disable-ffplay --disable-ffprobe --disable-ffserver --disable-iconv --disable-bzlib --disable-devices --enable-avresample --sysroot="${DEVELOPER}/Platforms/${PLATFORM}.platform/Developer/SDKs/${PLATFORM}${SDKVERSION}.sdk" --cc="${DEVELOPER}/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang" --as='/usr/local/bin/gas-preprocessor.pl' --extra-cflags="${EXTRA_CFLAGS} -miphoneos-version-min=${SDKVERSION} -I${OUTPUTDIR}/include" --extra-ldflags="-arch ${ARCH} ${EXTRA_LDFLAGS} -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/${PLATFORM}.platform/Developer/SDKs/${PLATFORM}${SDKVERSION}.sdk -miphoneos-version-min=${SDKVERSION}" ${EXTRA_CONFIG} --enable-pic --extra-cxxflags="$CPPFLAGS -isysroot ${DEVELOPER}/Platforms/${PLATFORM}.platform/Developer/SDKs/${PLATFORM}${SDKVERSION}.sdk"

make && make install && make clean

done

mkdir "${BUILDDIR}/universal"
mkdir "${BUILDDIR}/universal/lib"

cd "${ROOTDIR}/${BUILDDIR}/armv7/lib"
for file in *.a
do

cd "${ROOTDIR}/${BUILDDIR}"
xcrun -sdk iphoneos lipo -output universal/lib/$file  -create -arch armv7 armv7/lib/$file -arch armv7s armv7s/lib/$file -arch i386 i386/lib/$file
echo "Universal $file created."

done

cd "${ROOTDIR}/${BUILDDIR}"

cp -a "armv7s/include" "universal"

echo "Done."