@echo off
if NOT x%DDK_TARGET_OS%==xWinXP goto usage

mkdir E:\dailies\%DATE%
for %%A in (MS32 MS64) do mkdir E:\dailies\%DATE%\%%A
for %%A in (MS32 MS64) do mkdir E:\dailies\%DATE%\%%A\static
for %%A in (MS32 MS64) do mkdir E:\dailies\%DATE%\%%A\dll
for %%A in (source bin32 bin64) do mkdir E:\dailies\%DATE%\examples\%%A
copy libusb\libusb.h E:\dailies\%DATE%\
copy libusb\libusb-1.0.def E:\dailies\%DATE%\
copy examples\*.c E:\dailies\%DATE%\examples\source

set ORG_BUILD_ALT_DIR=%BUILD_ALT_DIR%
set ORG_BUILDARCH=%_BUILDARCH%
set ORG_PATH=%PATH%
set ORG_BUILD_DEFAULT_TARGETS=%BUILD_DEFAULT_TARGETS%

set 386=1
set AMD64=
set BUILD_DEFAULT_TARGETS=-386
set _AMD64bit=
set _BUILDARCH=x86
set PATH=%BASEDIR%\bin\x86;%BASEDIR%\bin\x86\x86

call ddk_build

@echo off
copy Win32\Release\lib\libusb-1.0.lib E:\dailies\%DATE%\MS32\static
copy Win32\Release\examples\lsusb.exe E:\dailies\%DATE%\examples\bin32
copy Win32\Release\examples\xusb.exe E:\dailies\%DATE%\examples\bin32

call ddk_build DLL

@echo off
copy Win32\Release\lib\libusb-1.0.lib E:\dailies\%DATE%\MS32\dll
copy Win32\Release\dll\libusb-1.0.dll E:\dailies\%DATE%\MS32\dll

set 386=
set AMD64=1
set BUILD_DEFAULT_TARGETS=-amd64
set _AMD64bit=true
set _BUILDARCH=AMD64
set PATH=%BASEDIR%\bin\x86\amd64;%BASEDIR%\bin\x86

call ddk_build

@echo off
copy x64\Release\lib\libusb-1.0.lib E:\dailies\%DATE%\MS64\static
copy x64\Release\examples\lsusb.exe E:\dailies\%DATE%\examples\bin64
copy x64\Release\examples\xusb.exe E:\dailies\%DATE%\examples\bin64

call ddk_build DLL

@echo off
copy x64\Release\lib\libusb-1.0.lib E:\dailies\%DATE%\MS64\dll
copy x64\Release\dll\libusb-1.0.dll E:\dailies\%DATE%\MS64\dll

set BUILD_ALT_DIR=%ORG_BUILD_ALT_DIR%
set _BUILDARCH=%ORG_BUILDARCH%
set PATH=%ORG_PATH%
set BUILD_DEFAULT_TARGETS=%ORG_BUILD_DEFAULT_TARGETS%

goto done

:usage
echo must be run in a WXP build environment!

:done
