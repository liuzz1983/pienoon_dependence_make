EXTRA_FLAGS="-O3"

BASE_DIR=`pwd`/../
BASE_BUILD_DIR=`pwd`
DEPENDENCY_DIR=$BASE_DIR/dependencies
LIB_DIR=$BASE_BUILD_DIR/libs

mkdir -p $LIB_DIR

setup_ios() {
  SDK="$1"
  ARCH="$2"
  CARCH="${3:-$2}"
  TYPE="$SDK-$ARCH"
  HOST_FLAGS="-arch $ARCH -miphoneos-version-min=8.0 -isysroot $(xcrun -sdk ${SDK} --show-sdk-path)"
  export CC="$(xcrun -find -sdk ${SDK} cc)"
  export CXX="$(xcrun -find -sdk ${SDK} c++)"
  export CFLAGS="$HOST_FLAGS $EXTRA_FLAGS"
  export CXXFLAGS="$CFLAGS"
  export LDFLAGS="$CFLAGS"
  HOST_CONF="--host=$CARCH-apple-darwin"
}
