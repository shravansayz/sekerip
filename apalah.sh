# Simple Script for building ROM, Especially Crave.

# Clean all manifest
#rm -rf .repo

# Define variable 
do_cleanremove=no

# Do repo init for rom that we want to build.
repo init -u https://github.com/Havoc-OS-Revived/android_manifest -b eleven  --git-lfs --depth=1 --no-repo-verify

git clone -b droid https://github.com/shravansayz/local_manifests .repo/local_manifests

# Do remove here before repo sync.
if [ "$do_cleanremove" = "yes" ]; then
 rm -rf system out prebuilts external hardware
fi

if [ "$do_smallremove" = "yes" ]; then
 rm -rf out/host prebuilts
fi

# Let's sync!
/opt/crave/resync.sh

# Clone our dt, vt and kt

# Do lunch
. build/envsetup.sh
lunch havoc_RMX1901-user


# Define build username and hostname things, also kernel
export BUILD_USERNAME=SHRAVAN
export BUILD_HOSTNAME=authority
export SKIP_ABI_CHECKS=true
export KBUILD_BUILD_USER=SHRAVAN   
export KBUILD_BUILD_HOST=authority
export BUILD_BROKEN_MISSING_REQUIRED_MODULES=true

# Let's start build!
m bacon -j$(nproc --all)
