#!/bin/bash
#configuration file for FW4SPL

echo FW4SPL configuration

echo -e "\033[33;34m"
echo "checking for required programs"
echo -e "\033[33;37m"


command -v git >/dev/null 2>&1 || { echo >&2 "git required but installed.  Aborting."; exit 1; }
command -v cmake >/dev/null 2>&1 || { echo >&2 "cmake required but installed.  Aborting."; exit 1; }
command -v make >/dev/null 2>&1 || { echo >&2 "make required but installed.  Aborting."; exit 1; }

echo -e "\033[33;34m"
echo "Checking version..."
echo -e "\033[33;37m"

rootPath=$(pwd)
latest_version=fw4spl_0.10.2.1
pathExtDeps=""
pathAr=""
pathExtDeps=""
pathExt=""
numberOfCore=$(grep -c ^processor /proc/cpuinfo)

echo -e "\033[33;32m"
echo "FW4SPL auto-configuration tools"
echo "- git found : $(which git)"
echo "- cmake found : $(which cmake)"
echo "- make found : $(which make)"
echo "- root directory : $rootPath"
echo "- lastest version is : $latest_version"
echo "- number of Cores : $numberOfCore"

echo -e "\033[33;37m"


echo -n "\ Are you sure you want to build FW4SPL environement in this directory ($pwd) [y|n] ?"
read continu



if [ "$continu" = "y" ] || [ "$continu" = "Y" ]; then

    echo -e "\033[33;34m"
    echo "Creation of folders..."
    echo -e "\033[33;37m"

    mkdir Src Build Install
    mkdir Build/Debug Build/Release
    mkdir Install/Debug Install/Release

    mkdir Deps
    mkdir Deps/Src Deps/Build Deps/Install Deps/Build/Debug Deps/Build/Release Deps/Install/Debug Deps/Install/Release

    echo -n "Do you want 'Extended' repositories [y|n] ? "
    read extended

    echo -n  "Do you want 'Augmented Reality' repositories [y|n] ?"
    read ar

    echo -e "\033[33;34m"
    echo "cloning repositories..."
    echo -e "\033[33;37m"

    git clone https://github.com/fw4spl-org/fw4spl-deps.git ./Deps/Src/fw4spl-deps
    git clone https://github.com/fw4spl-org/fw4spl.git ./Src/fw4spl

    cd ./Deps/Src/fw4spl-deps
    git checkout $latest_version
    cd ../../..
    cd ./Src/fw4spl
    git checkout $latest_version
    cd ../..

    if [ "$extended" = "y" ] || [ "$extended" = "Y" ]; then
        git clone https://github.com/fw4spl-org/fw4spl-ext-deps.git ./Deps/Src/fw4spl-ext-deps
        git clone https://github.com/fw4spl-org/fw4spl.git ./Src/fw4spl-ext

        pathExtDeps="$rootPath/Deps/Src/fw4spl-ext-deps"
        pathExt="$rootPath/Src/fw4spl-ext"

        cd ./Deps/Src/fw4spl-ext-deps
        git checkout $latest_version
        cd ../../..
        cd ./Src/fw4spl-ext
        git checkout $latest_version
        cd ../..

    fi

    if [ "$ar" = "y" ] || [ "$ar" = "Y" ]; then
        git clone https://github.com/fw4spl-org/fw4spl-ar-deps.git ./Deps/Src/fw4spl-ar-deps
        git clone https://github.com/fw4spl-org/fw4spl-ar.git ./Src/fw4spl-ar

        pathArDeps="$rootPath/Deps/Src/fw4spl-ar-deps"
        pathAr="$rootPath/Src/fw4spl-ar"

        cd ./Deps/Src/fw4spl-ar-deps
        git checkout $latest_version
        cd ../../..
        cd ./Src/fw4spl-ar
        git checkout $latest_version
        cd ../..
    fi

    echo -e "\033[33;34m"
    echo "cmake configuration of dependencies ..."
    echo -e "\033[33;37m"

    echo "fw4spl-ext-deps : $pathExtDeps"
    echo "fw4spl-ar-deps : $pathArDeps"

    cd ./Deps/Build/Debug
    cmake $rootPath/Deps/Src/fw4spl-deps -DCMAKE_INSTALL_PREFIX=$rootPath/Deps/Install/Debug -DCMAKE_BUILD_TYPE=Debug -DADDITIONAL_DEPS="$pathExtDeps;$pathArDeps"

    cd ../Release
    cmake $rootPath/Deps/Src/fw4spl-deps -DCMAKE_INSTALL_PREFIX=$rootPath/Deps/Install/Release -DCMAKE_BUILD_TYPE=Release -DADDITIONAL_DEPS="$pathExtDeps;$pathArDeps"

    #to the root
    cd ../../..

    echo "Configuration done."
    echo -n "Do you want to build [y|n] ?"
    read build

    if [ "$build" = "y" ] || [ "$build" = "Y" ]; then
        cd ./Deps/Build/Debug
        make all -j$numberOfCore
    fi

    echo "done"

else
    exit 0
fi
