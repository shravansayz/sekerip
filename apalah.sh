# Simple Script for building ROM, Especially Crave.

# Clean all manifest
#rm -rf .repo

# Define variable 
do_cleanremove=no

# Do repo init for rom that we want to build.
repo init -u https://github.com/Havoc-OS-Revived/android_manifest -b eleven  --git-lfs --depth=1 --no-repo-verify

# Remove tree before cloning our manifest.
rm -rf device vendor kernel packages/apps/Settings

# Do remove here before repo sync.
if [ "$do_cleanremove" = "yes" ]; then
 rm -rf system out prebuilts external hardware packages
fi

if [ "$do_smallremove" = "yes" ]; then
 rm -rf out/host prebuilts
fi

# Let's sync!
/opt/crave/resync.sh

# Clone our dt, vt and kt
rm -rf device/xiaomi kernel/xiaomi vendor/xiaomi
git clone --depth=1 https://github.com/zaidanprjkt/device_xiaomi_juice -b havoc device/xiaomi/juice
git clone --depth=1 https://github.com/stormbreaker-project/kernel_poco_citrus kernel/xiaomi/juice
git clone --depth=1 https://github.com/zaidanprjkt/android_vendor_xiaomi_juice -b eleven vendor/xiaomi/juice

# Do lunch
. build/envsetup.sh
lunch havoc_juice-user

rm -rf packages/apps/Settings
git clone --depth=1 https://github.com/newestzdn/settings-havoc packages/apps/Settings

# Define build username and hostname things, also kernel
export BUILD_USERNAME=zaidan
export BUILD_HOSTNAME=authority
export SKIP_ABI_CHECKS=true
export KBUILD_BUILD_USER=zaidan    
export KBUILD_BUILD_HOST=authority
export BUILD_BROKEN_MISSING_REQUIRED_MODULES=true

# Let's start build!
m bacon -j$(nproc --all)
