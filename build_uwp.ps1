function BuildForUWP($platform, $vcpkgPath, $runMsbuild) {

    $buildDirectory = "build_uwp_${platform}"
    mkdir $buildDirectory -Force -ErrorAction Stop | Out-Null
    cd $buildDirectory
    pwd

    if ($platform -eq "x86") {
        $msbuildPlatform = "Win32"
    } else {
        $msbuildPlatform = $platform # x64/ARM/ARM64
    }

    cmake -ErrorAction Stop `
          -G "Visual Studio 16 2019" `
          -A $msbuildPlatform `
          -D CMAKE_SYSTEM_NAME=WindowsStore `
          -D CMAKE_SYSTEM_VERSION=10.0 `
          -D CMAKE_BUILD_TYPE=Release `
          -D CMAKE_INSTALL_PREFIX=install `
          -D INSTALL_C_EXAMPLES=ON `
          -D INSTALL_PYTHON_EXAMPLES=OFF `
          -D BUILD_ANDROID_PROJECTS=OFF `
          -D BUILD_ANDROID_EXAMPLES=OFF `
          -D BUILD_DOCS=OFF `
          -D BUILD_WITH_DEBUG_INFO=OFF `
          -D BUILD_EXAMPLES=OFF `
          -D BUILD_TESTS=OFF `
          -D BUILD_PERF_TESTS=OFF `
          -D BUILD_JAVA=OFF `
          -D BUILD_opencv_apps=OFF `
          -D BUILD_opencv_datasets=OFF `
          -D BUILD_opencv_gapi=OFF `
          -D BUILD_opencv_java_bindings_generator=OFF `
          -D BUILD_opencv_js=OFF `
          -D BUILD_opencv_python2=OFF `
          -D BUILD_opencv_python3=OFF `
          -D BUILD_opencv_python_bindings_generator=OFF `
          -D BUILD_opencv_python_tests=OFF `
          -D BUILD_opencv_ts=OFF `
          -D BUILD_opencv_world=ON `
          -D WITH_MSMF=OFF `
          -D WITH_MSMF_DXVA=OFF `
          -D WITH_QT=OFF `
          -D WITH_TESSERACT=ON `
          -D Tesseract_INCLUDE_DIR="${vcpkgPath}/installed/${platform}-windows-static/include/tesseract" `
          -D Tesseract_LIBRARY="${vcpkgPath}/installed/${platform}-windows-static/lib/tesseract41.lib" `
          -D Lept_LIBRARY="${vcpkgPath}/installed/${platform}-windows-static/lib/leptonica-1.78.0.lib" `
          -D OPENCV_ENABLE_NONFREE=ON `
          -D OPENCV_EXTRA_MODULES_PATH=../opencv_contrib/modules `
          -D BUILD_SHARED_LIBS=ON ../opencv 

    if ($runMsbuild) {
        # Developer Powershell for VS 2019 
        # Path: C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe -noe -c "&{Import-Module """C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"""; Enter-VsDevShell cebe9bd5}"
        # WorkDir: C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\

        msbuild INSTALL.vcxproj /t:build /p:configuration=Release /p:platform=$msbuildPlatform -maxcpucount
        ls
    }

    cd ..
}


# Entry point
If ((Resolve-Path -Path $MyInvocation.InvocationName).ProviderPath -eq $MyInvocation.MyCommand.Path) {

  ##### Change here #####
  $platform = "x64"
  #$platform = "x86"
  #$platform = "ARM"
  #$platform = "ARM64"

  BuildForUWP $platform $vcpkgPath $FALSE
}