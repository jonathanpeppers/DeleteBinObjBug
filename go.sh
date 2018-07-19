#!/bin/bash

OLD_XA=xamarin.android-8.3.3-2.pkg
NEW_XA=xamarin.android-9.0.0-17.pkg

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

sudo installer -pkg $OLD_XA -target /

cd ../TheLittleThingsPlayground/
git clean -dxf
msbuild TheLittleThingsPlayground.sln /t:Restore,Install
cd ../DeleteBinObjBug

sudo installer -pkg $NEW_XA -target /

cd ../TheLittleThingsPlayground/
git clean -dxf
msbuild TheLittleThingsPlayground.sln /t:Restore,Install
cd ../DeleteBinObjBug