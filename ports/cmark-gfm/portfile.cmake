vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO github/cmark-gfm
    REF "${VERSION}"
    SHA512 435298fcf782dfc5b64c578ac839759b9d5cd0c08eb90d6702f26278062a0f4887c65c18e89e2c9f6be23f10dd835c769a7e0f8c934be068b6754dcca30cdd7c
    HEAD_REF master
    PATCHES
        msvc-shared-library.patch
        add-feature-tools.patch
        install.patch
        msvc-utf8.patch
        name-suffixes.patch
)

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "static" CMARK_STATIC)
string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" CMARK_SHARED)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        tools BUILD_TOOLS
)

vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        ${FEATURE_OPTIONS}
        -DCMARK_TESTS=OFF
        -DCMARK_SHARED=${CMARK_SHARED}
        -DCMARK_STATIC=${CMARK_STATIC}
)

vcpkg_cmake_install()

vcpkg_fixup_pkgconfig()
vcpkg_copy_pdbs()
vcpkg_cmake_config_fixup(
    CONFIG_PATH share/unofficial-cmark-gfm
    PACKAGE_NAME unofficial-cmark-gfm
)

if ("tools" IN_LIST FEATURES)
    vcpkg_copy_tools(TOOL_NAMES cmark-gfm SEARCH_DIR "${CURRENT_PACKAGES_DIR}/tools/cmark-gfm" AUTO_CLEAN)
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include" "${CURRENT_PACKAGES_DIR}/debug/share")

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
