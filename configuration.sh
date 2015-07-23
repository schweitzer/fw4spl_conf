#!/bin/bash
#configuration file for FW4SPL

echo FW4SPL configuration


echo -n "Are you sure you want to build FW4SPL environement in this directory [y|n] ?"
read continu

latest_version=fw4spl_0.10.2.1
pathExtDeps=""
pathAr=""
pathExtDeps=""
pathExt=""
numberofCore=grep -c ^processor /proc/cpuinfo

if [ "$continu" = "y" ] || [ "$continu" = "Y" ]; then

    echo "Creation of folders ..."

    mkdir Src Build Install
    mkdir Build/Debug Build/Release
    mkdir Install/Debug Install/Release

    mkdir BinPkgs
    mkdir BinPkgs/Src BinPkgs/Build BinPkgs/Install BinPkgs/Build/Debug BinPkgs/Build/Release BinPkgs/Install/Debug BinPkgs/Install/Release

    echo -n "Do you want 'Extended' repositories [y|n] ? "
    read extended

    echo -n "Do you want 'Augmented Reality' repositories [y|n] ?"
    read ar

    echo "cloning repositories..."

    git clone https://github.com/fw4spl-org/fw4spl-deps.git ./BinPkgs/Src/fw4spl-deps
    git clone https://github.com/fw4spl-org/fw4spl.git ./Src/fw4spl

    cd ./BinPkgs/Src/fw4spl-deps
    git checkout $latest_version
    cd ../../..
    cd ./Src/fw4spl
    git checkout $latest_version
    cd ../..

    if [ "$extended" = "y" ] || [ "$extended" = "Y" ]; then
        git clone https://github.com/fw4spl-org/fw4spl-ext-deps.git ./BinPkgs/Src/fw4spl-ext-deps
        git clone https://github.com/fw4spl-org/fw4spl.git ./Src/fw4spl-ext

        pathExtDeps=./BinPkgs/Src/fw4spl-ext-deps
        pathExt=./Src/fw4spl-ext

        cd ./BinPkgs/Src/fw4spl-ext-deps
        git checkout $latest_version
        cd ../../..
        cd ./Src/fw4spl-ext
        git checkout $latest_version
        cd ../..

    fi

    if [ "$ar" = "y" ] || [ "$ar" = "Y" ]; then
        git clone https://github.com/fw4spl-org/fw4spl-ar-deps.git ./BinPkgs/Src/fw4spl-ar-deps
        git clone https://github.com/fw4spl-org/fw4spl-ar.git ./Src/fw4spl-ar

        pathArDeps=./BinPkgs/Src/fw4spl-ar-deps
        pathAr=./Src/fw4spl-ar

        cd ./BinPkgs/Src/fw4spl-ar-deps
        git checkout $latest_version
        cd ../../..
        cd ./Src/fw4spl-ar
        git checkout $latest_version
        cd ../..
    fi

    echo "cmake configuration of dependencies ..."

    cd ./BinPkgs/Build/Debug
    cmake ../../Src/fw4spl-deps -DCMAKE_INSTALL_PREFIX=../Install/Debug -DCMAKE_BUILD_TYPE=Debug
    -DADDITIONAL_PROJECTS=$pathExtDeps;$pathArDeps

    cd ../Release
    cmake ../../Src/fw4spl-deps -DCMAKE_INSTALL_PREFIX=../Install/Release -DCMAKE_BUILD_TYPE=Release
    -DADDITIONAL_PROJECTS=$pathExtDeps;$pathArDeps

    

    #to the root
    cd ../../..


    echo "done"

else
    exit 0
fi
