
source common.sh

BUILD_DIR="$BASE_BUILD_DIR/build/ogg"
SRC_DIR="$DEPENDENCY_DIR/libogg"

build_audio() {
	mkdir -p "$BUILD_DIR/$TYPE"
	(
    cd $SRC_DIR
    make clean 2>/dev/null
    sh autogen.sh --disable-shared --enable-static  "$HOST_CONF"
    make
    cp ./src/.libs/libogg.a "$BUILD_DIR/$TYPE"
  )
}

BUILD_LISTS=""
PLATFORMS="armv7 armv7s arm64 x86_64 i386"
for PLATFORM in ${PLATFORMS}; do
  if [[ "${PLATFORM}" == "armv7" ]]; then
    SDK="iphoneos"
    ARCH="armv7"
    CARCH="arm"
  elif [[ "${PLATFORM}" == "armv7s" ]]; then
    SDK="iphoneos"
    ARCH="armv7s"
    CARCH="arm"
  elif [[ "${PLATFORM}" == "arm64" ]]; then
    SDK="iphoneos"
    ARCH="arm64"
    CARCH="arm"
  elif [[ "${PLATFORM}" == "x86_64" ]]; then
    SDK="iphonesimulator"
    ARCH="x86_64"
    CARCH=""
  else
    SDK="iphonesimulator"
    ARCH="i386"
    CARCH=""
  fi
  
  setup_ios $SDK $ARCH $CARCH
  BUILD_LISTS+=" $BUILD_DIR/$TYPE/libogg.a"
  build_audio
done

declare -r TARGETDIR="${LIB_DIR}/ogg.framework"
mkdir -p ${TARGETDIR}/Headers/
cp -rf ${SRC_DIR}/include/ogg ${TARGETDIR}/Headers/
echo $BUILD_LISTS
lipo -create $BUILD_LISTS -output "$TARGETDIR/ogg"


