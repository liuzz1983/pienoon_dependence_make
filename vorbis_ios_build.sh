source common.sh

BUILD_DIR="$BASE_BUILD_DIR/build/vorbis"
SRC_DIR="$DEPENDENCY_DIR/libvorbis"


build() {
	mkdir -p "$BUILD_DIR/$TYPE"
	(
    cd $SRC_DIR
    make clean 2>/dev/null
    sh autogen.sh --disable-shared --enable-static  "$HOST_CONF"
    make
    cp ./lib/.libs/libvorbis.a "$BUILD_DIR/$TYPE"
    #BUILD_LIST_HARFBUZZ+=" $BUILD/$TYPE/libharfbuzz.a"
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
  BUILD_LISTS+=" $BUILD_DIR/$TYPE/libvorbis.a"
  build
done

declare -r TARGETDIR="${LIB_DIR}/vorbis.framework"
mkdir -p ${TARGETDIR}/Headers/
cp -rf ${SRC_DIR}/include/vorbis ${TARGETDIR}/Headers/
echo $BUILD_LISTS

echo $BUILD_LISTS
lipo -create $BUILD_LISTS -output "$TARGETDIR/vorbis"


