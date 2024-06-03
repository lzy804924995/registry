if(EXISTS "${CURRENT_INSTALLED_DIR}/share/libressl/copyright"
    OR EXISTS "${CURRENT_INSTALLED_DIR}/share/boringssl/copyright")
    message(FATAL_ERROR "Can't build openssl if libressl/boringssl is installed. Please remove libressl/boringssl, and try install openssl again if you need it.")
endif()

if (VCPKG_TARGET_IS_LINUX)
    message(WARNING
[[openssl currently requires the following library from the system package manager:
    linux-headers
It can be installed on alpine systems via apk add linux-headers.]]
    )
endif()

set(OPENSSL_VERSION 1.1.1)

vcpkg_download_distfile(
    ARCHIVE
    URLS "https://codeload.github.com/lzy804924995/openssl/tar.gz/refs/tags/openssl-3.3.0"
    FILENAME "openssl-3.3.0.tar.gz"
    SHA512 42cc11475d8b31706ec151c9aed0178e17b788c6b38636ae1cde363872139ed85f5b9efd0c75012f4d6f15ec8100e1afe5d528e72b88a5d3dea4125c9b0804aa
)

vcpkg_find_acquire_program(PERL)
get_filename_component(PERL_EXE_PATH ${PERL} DIRECTORY)
vcpkg_add_to_path("${PERL_EXE_PATH}")

if(VCPKG_TARGET_IS_UWP)
    include("${CMAKE_CURRENT_LIST_DIR}/uwp/portfile.cmake")
    include("${CMAKE_CURRENT_LIST_DIR}/install-pc-files.cmake")
elseif(VCPKG_TARGET_IS_WINDOWS AND NOT VCPKG_TARGET_IS_MINGW)
    include("${CMAKE_CURRENT_LIST_DIR}/windows/portfile.cmake")
    include("${CMAKE_CURRENT_LIST_DIR}/install-pc-files.cmake")
else()
    include("${CMAKE_CURRENT_LIST_DIR}/unix/portfile.cmake")
endif()

configure_file("${CMAKE_CURRENT_LIST_DIR}/vcpkg-cmake-wrapper.cmake.in" "${CURRENT_PACKAGES_DIR}/share/${PORT}/vcpkg-cmake-wrapper.cmake" @ONLY)
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
