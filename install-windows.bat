@echo off

setlocal

set "CarNDProjectPlatform=x64"
set "CarNDProjectToolset=v141"
set "CarNDProjectBuildType=Debug"

if NOT "%~1"=="" set "CarNDProjectPlatform=%~1"
if NOT "%~2"=="" set "CarNDProjectToolset=%~2"
if NOT "%~3"=="" set "CarNDProjectBuildType=%~3" 

set "VcPkgDir=%USERPROFILE%\Software\vcpkg\vcpkg"
set "VcPkgTriplet=%CarNDProjectPlatform%-windows-%CarNDProjectToolset%"

if defined VCPKG_ROOT_DIR if /i not "%VCPKG_ROOT_DIR%"=="" (
    set "VcPkgDir=%VCPKG_ROOT_DIR%"
)
if defined VCPKG_DEFAULT_TRIPLET if /i not "%VCPKG_DEFAULT_TRIPLET%"=="" (
    set "VcpkgTriplet=%VCPKG_DEFAULT_TRIPLET%"
)
set "VcPkgPath=%VcPkgDir%\vcpkg.exe"

echo. & echo Bootstrapping dependencies for triplet: %VcPkgTriplet% & echo.

rem ==============================
rem Update and Install packages
rem ==============================
call "%VcPkgPath%" update
call "%VcPkgPath%" remove --outdated --recurse
call "%VcPkgPath%" install uwebsockets --triplet %VcPkgTriplet%
call "%VcPkgPath%" integrate project --triplet %VcPkgTriplet%

rem ==============================
rem Configure CMake
rem ==============================

set "VcPkgTripletDir=%VcPkgDir%\installed\%VcPkgTriplet%"

set "CMAKE_PREFIX_PATH=%VcPkgTripletDir%;%CMAKE_PREFIX_PATH%"

echo. & echo Bootstrapping successful for triplet: %VcPkgTriplet% & echo CMAKE_PREFIX_PATH=%CMAKE_PREFIX_PATH% & echo.

endlocal