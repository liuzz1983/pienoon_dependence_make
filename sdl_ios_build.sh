#!/bin/bash

source common.sh 

SDL_PATH=$DEPENDENCY_DIR/sdl/Xcode-iOS/SDL
SRC_PATH=$DEPENDENCY_DIR/sdl

cd $SDL_PATH

#工程的名字 
PROJECT_NAME="SDL.xcodeproj"
#编译target的名字
TARGET_NAME="libSDL"
#LIB名字
STATIC_LIB="libSDL2.a"
#编译路径
# 编译静态库名称路径
BUILING_PATH='tmp'

FINAL_BUILD_PATH="."

FINAL_STATIC_LIB="SDL2.framework"

#如果目标文件不存在则创建
if [ ! -d "${BUILING_PATH}" ]; then
  mkdir -p "${BUILING_PATH}"
fi 

LIBLIST=""
PLATFORMS="armv7 armv7s arm64 x86_64 i386"

for PLATFORM in ${PLATFORMS}; do
  if [[ "${PLATFORM}" == "armv7" ]]; then
    SDK="iphoneos"
    ARCH="armv7"
  elif [[ "${PLATFORM}" == "armv7s" ]]; then
    SDK="iphoneos"
    ARCH="armv7s"
  elif [[ "${PLATFORM}" == "arm64" ]]; then
    SDK="iphoneos"
    ARCH="arm64"
  elif [[ "${PLATFORM}" == "x86_64" ]]; then
    SDK="iphonesimulator"
    ARCH="x86_64"
  else
  	SDK="iphonesimulator"
    ARCH="i386"
  fi

  BUILD_PATH="$BUILING_PATH/$PLATFORM"

  echo $BUILD_PATH
  xcodebuild -project "${PROJECT_NAME}" -target "${TARGET_NAME}" -configuration 'Debug'  \
  	-sdk $SDK CONFIGURATION_BUILD_DIR="${BUILD_PATH}" ARCHS=$ARCH  VALID_ARCHS=$ARCH \
  	IPHONEOS_DEPLOYMENT_TARGET='5.0' clean build

  LIBLIST+="  $BUILD_PATH/$STATIC_LIB"
done

echo $BUILD_LISTS
declare -r TARGETDIR="${LIB_DIR}/sdl.framework"
mkdir -p ${TARGETDIR}/Headers/
cp -rf ${SRC_PATH}/include/* ${TARGETDIR}/Headers/

# 合并不同版本的编译库 
echo $LIBLIST
lipo -create $LIBLIST -output "${TARGETDIR}/sdl"
