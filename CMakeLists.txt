 project(setup-maxscale-repo)
cmake_minimum_required(VERSION 2.8)

include(macros.cmake)

set_variables()
set_maxscale_version()

# Installation directory
set(INSTALL_DIR "/usr/local/skysql/maxscale/" CACHE PATH "MaxScale tests installation directory.")
set(CMAKE_INSTALL_PREFIX "${INSTALL_DIR}" CACHE INTERNAL "Prefix prepended to install directories." FORCE)

aux_source_directory(. SRC_LIST)

install(FILES setup_maxscale_repos.sh  DESTINATION repo-setup PERMISSIONS WORLD_READ WORLD_EXECUTE OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE)
install(FILES maxscale.repo.template  DESTINATION repo-setup)
install(FILES maxscale.repo.suse13.template  DESTINATION repo-setup)
install(FILES maxscale.repo.sles11.template  DESTINATION repo-setup)
install(FILES maxscale.repo.sles12.template  DESTINATION repo-setup)
install(FILES maxscale.list.template  DESTINATION repo-setup)



# See if we are on a RPM-capable or DEB-capable system
find_program(RPMBUILD rpmbuild)
find_program(DEBBUILD dpkg-buildpackage)

if(NOT ( ${RPMBUILD} STREQUAL "RPMBUILD-NOTFOUND" ) )
  message(STATUS "Generating RPM packages")
  set(CPACK_GENERATOR "${CPACK_GENERATOR};RPM;TGZ")
endif()

if(NOT ( ${DEBBUILD} STREQUAL "DEBBUILD-NOTFOUND" ) )
  set(CPACK_GENERATOR "${CPACK_GENERATOR};DEB;TGZ")
  execute_process(COMMAND dpgk --print-architecture OUTPUT_VARIABLE DEB_ARCHITECTURE)
  set(CPACK_DEBIAN_PACKAGE_ARCHITECTURE ${DEB_ARCHITECTURE})
  set (CPACK_DEBIAN_PACKAGE_SHLIBDEPS OFF)
  set(CPACK_DEBIAN_PACKAGE_DEPENDS "bash, sed")
  message(STATUS "Generating DEB packages for ${DEB_ARCHITECTURE}")
endif()

set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "setup-maxscale-repo")
set(CPACK_PACKAGE_VERSION_MAJOR "${MAXSCALE_VERSION_MAJOR}")
set(CPACK_PACKAGE_VERSION_MINOR "${MAXSCALE_VERSION_MINOR}")
set(CPACK_PACKAGE_VERSION_PATCH "${MAXSCALE_VERSION_PATCH}")
set(CPACK_PACKAGE_CONTACT "MariaDB Corporation Ab")
set(CPACK_PACKAGE_FILE_NAME "setup-maxscale-repo-${MAXSCALE_VERSION}")
set(CPACK_PACKAGE_NAME "setup-maxscale-repo")
set(CPACK_PACKAGE_VENDOR "MariaDB Corporation Ab")
set(CPACK_PACKAGE_DESCRIPTION_FILE ${CMAKE_SOURCE_DIR}/README)
set(CPACK_PACKAGING_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")
set(CPACK_RPM_PACKAGE_NAME "setup-maxscale-repo")
set(CPACK_RPM_PACKAGE_VENDOR "MariaDB Corporation Ab")
set(CPACK_RPM_PACKAGE_LICENSE "GPLv2")
include(CPack)

