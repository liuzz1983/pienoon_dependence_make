
source common.sh

SRC_PATH=$DEPENDENCY_DIR/audio_engine
IOS_CMAKE=`pwd`/ios.cmake

cp cmake/audio_cmakelists.txt $SRC_PATH/CMakeLists.txt

cd $SRC_PATH
BUILD_LISTS=""
platforms="SIMULATOR SIMULATOR64 OS"
for platform in $platforms ; do 
	BUILING_PATH=$SRC_PATH/$platform
	(
	mkdir $platform
	cd $BUILING_PATH
	cmake .. -DCMAKE_TOOLCHAIN_FILE=$IOS_CMAKE -DIOS_PLATFORM=$platform
	make -j4
	)
	BUILD_LISTS+=" $BUILING_PATH/libpindrop.a"

done

echo $BUILD_LISTS
declare -r TARGETDIR="${LIB_DIR}/pindrop.framework"
mkdir -p ${TARGETDIR}/Headers/
cp -rf ${SRC_PATH}/include/* ${TARGETDIR}/Headers/

lipo -create $BUILD_LISTS -output "$TARGETDIR/pindrop"

