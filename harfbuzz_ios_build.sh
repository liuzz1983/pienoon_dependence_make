#git submodule update --init

source common.sh

HARFBUZZ="$DEPENDENCY_DIR/harfbuzz"
FREETYPE2="$DEPENDENCY_DIR/freetype"

BUILD="$BASE_BUILD_DIR/build/harfbuzz"


BUILD_LIST_FREETYE=""
BUILD_LIST_HARFBUZZ=""

build_harfbuzz() {

  mkdir -p "$BUILD/$TYPE"
  (
    cd $FREETYPE2
    export CFLAGS="-c $CFLAGS"
    make clean 2>/dev/null
    sh autogen.sh
    make setup ansi
    make
    cp objs/libfreetype.a "$BUILD/$TYPE"
    #BUILD_LIST_FREETYE+=" $BUILD/$TYPE/libfreetype.a"
  )

  (
    cd $HARFBUZZ
    export FREETYPE_CFLAGS="-I$FREETYPE2/include"
    export FREETYPE_LIBS="-L$FREETYPE2/objs -lfreetype"
    make clean 2>/dev/null
    sh autogen.sh --disable-shared --enable-static --with-glib=no --with-coretext=no "$HOST_CONF"
    make
    cp src/.libs/libharfbuzz.a "$BUILD/$TYPE"
    #BUILD_LIST_HARFBUZZ+=" $BUILD/$TYPE/libharfbuzz.a"
  )
}

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
  BUILD_LIST_FREETYE+=" $BUILD/$TYPE/libfreetype.a"
  BUILD_LIST_HARFBUZZ+=" $BUILD/$TYPE/libharfbuzz.a"

  #build_harfbuzz
done


declare -r FREETTPE_TARGETDIR="${LIB_DIR}/freetype.framework"
mkdir -p ${FREETTPE_TARGETDIR}/Headers/
cp -rf ${FREETYPE2}/include/* ${FREETTPE_TARGETDIR}/Headers/

declare -r HARFBUZZ_TARGETDIR="${LIB_DIR}/harfbuzz.framework"
mkdir -p ${HARFBUZZ_TARGETDIR}/Headers/
cp -rf  ${HARFBUZZ}/src/*.h ${HARFBUZZ_TARGETDIR}/Headers/


echo $BUILD_LIST_FREETYE
lipo -create $BUILD_LIST_FREETYE -output "$FREETTPE_TARGETDIR/freetype"
echo $BUILD_LIST_HARFBUZZ
lipo -create $BUILD_LIST_HARFBUZZ -output "$HARFBUZZ_TARGETDIR/harfbuzz"



