
source common.sh

SRC_PATH=$DEPENDENCY_DIR/motive
IOS_CMAKE=`pwd`/ios.cmake

cp cmake/motive_cmakelists.txt $SRC_PATH/CMakeLists.txt

cd $SRC_PATH
BUILD_LISTS=""
platforms="SIMULATOR SIMULATOR64 OS"
for platform in $platforms ; do 
	working_path=$SRC_PATH/$platform
	(
	mkdir $platform
	cd $working_path
	cmake .. -DCMAKE_TOOLCHAIN_FILE=$IOS_CMAKE -DIOS_PLATFORM=$platform
	make -j4
	)
	BUILD_LISTS+=" $working_path/libmotive.a"

done

echo $BUILD_LISTS
declare -r TARGETDIR="${LIB_DIR}/motive.framework"
mkdir -p ${TARGETDIR}/Headers/
cp -rf ${SRC_PATH}/include/* ${TARGETDIR}/Headers/

lipo -create $BUILD_LISTS -output "$TARGETDIR/motive"

