#!/bin/bash

TOP_DIR=`realpath ${BASH_SOURCE%/*}`
OLD_XA=xamarin.android-8.3.3-2.pkg
NEW_XA=xamarin.android-9.0.0-17.pkg
SLN=TheLittleThingsPlayground.sln
CSPROJ=TheLittleThingsPlayground.Android/TheLittleThingsPlayground.Android.csproj
XAML=TheLittleThingsPlayground/Views/AboutPage.xaml
PACKAGE_NAME=com.xamarin.TheLittleThingsPlayground
INSTALL_TARGETS=Install,_Run

if [ ! -f $OLD_XA ]; then
   wget https://bosstoragemirror.azureedge.net/wrench/monodroid-mavericks-d15-7/df/dffc591202713c2ef7cbba8e371779cf445444f3/xamarin.android-8.3.3-2.pkg
else
   echo "$OLD_XA already downloaded.";
fi

if [ ! -f $NEW_XA ]; then
   wget https://bosstoragemirror.azureedge.net/wrench/monodroid-mavericks-d15-8/df/dfb09269d7791c51e68f0eb2b4341960b2cb3ea4/xamarin.android-9.0.0-17.pkg
else
   echo "$NEW_XA already downloaded.";
fi

adb uninstall $PACKAGE_NAME

sudo installer -pkg $OLD_XA -target /

cd $TOP_DIR/../TheLittleThingsPlayground/
git clean -dxf
msbuild $SLN /t:Restore
msbuild $CSPROJ /t:$INSTALL_TARGETS /bl:$TOP_DIR/first.binlog
touch $XAML
msbuild $CSPROJ /t:$INSTALL_TARGETS /p:EmbedAssembliesIntoApk=True /p:AndroidUseSharedRuntime=False /bl:$TOP_DIR/second.binlog
cd $TOP_DIR

sudo installer -pkg $NEW_XA -target /

cd $TOP_DIR/../TheLittleThingsPlayground/
touch $XAML
msbuild $CSPROJ /t:$INSTALL_TARGETS /bl:$TOP_DIR/third.binlog
cd $TOP_DIR