#!/bin/bash

usage() {
	echo "Usage: $0 GIT_REF OUTDIR TARGET_CPU TOOLCHAIN_DIR BINUTILS_PREFIX [GN_ARGLIST]"
	echo
	echo "GITREF is the git reference in v8's git to checkout and build, ideally a tag like 7.2.502.24"
	echo "OUTDIR is the name of the folder in the mount point where the shared library will be created (ie x86.release)"
	echo "TARGET_CPU is the v8 cpu arg (ie x86, arm, arm64, ...)"
	echo "TOOLCHAIN_DIR is the name of the folder in NDK_HOME/toolchains where your ar and strip are located"
	echo "BINUTILS_PREFIX is the prefix of all commands in TOOLCHAIN_DIR/prebuilt/linux-x86_64/bin (ie i686-linux)"
	echo "GN_ARGLIST is an optional list of GN config args as one (!) string, ie \"neon=false is_debug=true\""
	echo
}

if [ ! -n "$5" ]; then
	usage
	exit 1
fi

echo "ANDROID NDK HOME $NDK_HOME"

GN_ARGS="is_debug=false is_clang=true is_component_build=true target_os=\"android\" v8_enable_i18n_support=false v8_target_cpu=\"$3\" target_cpu=\"$3\" host_cpu=\"x64\" v8_use_snapshot=true v8_use_external_startup_data=false is_official_build=true use_thin_lto=false symbol_level=0"
#GN_ARGS="is_debug=false is_clang=true is_component_build=true target_os=\"android\" v8_enable_i18n_support=false v8_target_cpu=\"$3\" target_cpu=\"$3\" host_cpu=\"x64\" v8_use_snapshot=true android_ndk_root=\"$NDK_HOME\" android_ndk_version=\"r19\" android_ndk_major_version=19"

if [ -n "$6" ]; then
        GN_ARGS="$GN_ARGS $6"
fi

echo "GN_ARGS $GN_ARGS"

cd /usr/local/src/v8

#git fetch

#git checkout $1

#gclient sync --nohooks

rm -r out.gn/$2

# ../../../third_party/android_tools/ndk/toolchains/$4/prebuilt/linux-x86_64/bin/$5-strip --strip-debug libv8.a && \

gn gen out.gn/$2 --args="$GN_ARGS" && ninja -C out.gn/$2 d8 && pushd . && \
    cd out.gn/$2/obj/ && \
    ../../../third_party/android_tools/ndk/toolchains/$4/prebuilt/linux-x86_64/bin/$5-ar rcvs libv8.a v8_base/*.o v8_libbase/*.o v8_libsampler/*.o v8_snapshot/*.o v8_libplatform/*.o v8_libsampler/*.o && \
    mkdir /output/$2 && \
    cp libv8.a /output/$2 && \
    popd && rm -r out.gn/$2    
