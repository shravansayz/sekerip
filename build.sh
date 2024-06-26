# Simple Script for building ROM, Especially Crave.

# Clean all manifest
#rm -rf .repo

# Define variable 
device_codename=RMX1901
rom_name=afterlife
build_type=user
do_cleanremove=no

if [ "$rom_name" = "aicp" ]; then
  rom_manifest="https://github.com/AICP/platform_manifest.git"
  branch_rom="t13.0"
  branch_tree="aicp"
  build_command="make bacon"
  version_android="lineage-20.0"
fi

if [ "$rom_name" = "carbon" ]; then
  rom_manifest="https://github.com/CarbonROM/android.git"
  branch_rom="cr-11.0"
  branch_tree="carbon13"
  build_command="make carbon"
  version_android="lineage-20.0"
fi

if [ "$rom_name" = "afterlife" ]; then
  rom_manifest="https://github.com/AfterLifePrjkt13/android_manifest"
  branch_rom="LTS"
  branch_tree="test"
  build_command="m afterlife"
  version_android="lineage-20.0"
fi

if [ "$rom_name" = "plros" ]; then
  rom_manifest="https://github.com/plros/manifests.git"
  branch_rom="lineage-20.0"
  branch_tree="plros"
  build_command="m bacon"
fi

if [ "$rom_name" = "lmodroid" ]; then
  rom_manifest="https://github.com/burhancodes/lmodroid"
  branch_rom="thirteen"
  branch_tree="lmodroid"
  build_command="m bacon"
  version_android="lineage-20.0"
fi

if [ "$rom_name" = "aosp" ]; then
  rom_manifest="https://github.com/newestzdn/manifest"
  branch_rom="aosp-13"
  branch_tree="void"
  build_command="mka bacon"
  version_android="lineage-20.0"
fi

# Do repo init for rom that we want to build.
repo init -u "${rom_manifest}" -b "${branch_rom}"  --git-lfs --depth=1 --no-repo-verify



# Do remove here before repo sync.
if [ "$do_cleanremove" = "yes" ]; then
 rm -rf system out prebuilts
fi

if [ "$do_smallremove" = "yes" ]; then
 rm -rf out/host prebuilts
fi

# Clone our local manifest.
git clone https://github.com/shravansayz/local_manifest.git --depth 1 -b $branch_tree .repo/local_manifests

# Let's sync!
/opt/crave/resync.sh


# Do lunch
. build/envsetup.sh
lunch "${rom_name}"_"${device_codename}"-user

# Define build username and hostname things, also kernel
export BUILD_USERNAME=ssk
export BUILD_HOSTNAME=crave       
export SKIP_ABI_CHECKS=true
export KBUILD_BUILD_USER=ssk    
export KBUILD_BUILD_HOST=authority
export BUILD_BROKEN_MISSING_REQUIRED_MODULES=true

# Let's start build!
$build_command -j$(nproc --all)
