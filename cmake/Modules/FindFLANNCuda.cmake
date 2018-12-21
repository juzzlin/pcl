###############################################################################
# Find FLANN
#
# This sets the following variables:
# FLANN_CUDA_FOUND - True if FLANN was found.
# FLANN_CUDA_INCLUDE_DIRS - Directories containing the FLANN include files.
# FLANN_CUDA_LIBRARIES - Libraries needed to use FLANN.
# FLANN_CUDA_DEFINITIONS - Compiler flags for FLANN.
# If FLANN_CUDA_USE_STATIC is specified and then look for static libraries ONLY else
# look for shared ones

if(FLANN_CUDA_USE_STATIC)
  set(FLANN_CUDA_RELEASE_NAME flann_cuda_s)
  set(FLANN_CUDA_DEBUG_NAME flann_cuda_s-gd)
else(FLANN_CUDA_USE_STATIC)
  set(FLANN_CUDA_RELEASE_NAME flann_cuda)
  set(FLANN_CUDA_DEBUG_NAME flann_cuda-gd)
endif(FLANN_CUDA_USE_STATIC)

find_package(PkgConfig QUIET)
if (FLANN_CUDA_FIND_VERSION)
    pkg_check_modules(PC_FLANN flann>=${FLANN_CUDA_FIND_VERSION})
else(FLANN_CUDA_FIND_VERSION)
    pkg_check_modules(PC_FLANN flann)
endif(FLANN_CUDA_FIND_VERSION)

set(FLANN_CUDA_DEFINITIONS ${PC_FLANN_CUDA_CFLAGS_OTHER})

find_path(FLANN_CUDA_INCLUDE_DIR flann/flann.hpp
          HINTS ${PC_FLANN_CUDA_INCLUDEDIR} ${PC_FLANN_CUDA_INCLUDE_DIRS} "${FLANN_CUDA_ROOT}" "$ENV{FLANN_CUDA_ROOT}"
          PATHS "$ENV{PROGRAMFILES}/Flann" "$ENV{PROGRAMW6432}/Flann" 
          PATH_SUFFIXES include)

find_library(FLANN_CUDA_LIBRARY
             NAMES ${FLANN_CUDA_RELEASE_NAME}
             HINTS ${PC_FLANN_CUDA_LIBDIR} ${PC_FLANN_CUDA_LIBRARY_DIRS} "${FLANN_CUDA_ROOT}" "$ENV{FLANN_CUDA_ROOT}"
             PATHS "$ENV{PROGRAMFILES}/Flann" "$ENV{PROGRAMW6432}/Flann" 
	     PATH_SUFFIXES lib)

find_library(FLANN_CUDA_LIBRARY_DEBUG 
             NAMES ${FLANN_CUDA_DEBUG_NAME} ${FLANN_CUDA_RELEASE_NAME}
	     HINTS ${PC_FLANN_CUDA_LIBDIR} ${PC_FLANN_CUDA_LIBRARY_DIRS} "${FLANN_CUDA_ROOT}" "$ENV{FLANN_CUDA_ROOT}"
	     PATHS "$ENV{PROGRAMFILES}/Flann" "$ENV{PROGRAMW6432}/Flann" 
	     PATH_SUFFIXES lib)

if(NOT FLANN_CUDA_LIBRARY_DEBUG)
  set(FLANN_CUDA_LIBRARY_DEBUG ${FLANN_CUDA_LIBRARY})
endif(NOT FLANN_CUDA_LIBRARY_DEBUG)

set(FLANN_CUDA_INCLUDE_DIRS ${FLANN_CUDA_INCLUDE_DIR})
set(FLANN_CUDA_LIBRARIES optimized ${FLANN_CUDA_LIBRARY} debug ${FLANN_CUDA_LIBRARY_DEBUG})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(FLANN DEFAULT_MSG FLANN_CUDA_LIBRARY FLANN_CUDA_INCLUDE_DIR)

mark_as_advanced(FLANN_CUDA_LIBRARY FLANN_CUDA_LIBRARY_DEBUG FLANN_CUDA_INCLUDE_DIR)

if(FLANN_CUDA_FOUND)
  message(STATUS "FLANN CUDA found (include: ${FLANN_CUDA_INCLUDE_DIRS}, lib: ${FLANN_CUDA_LIBRARIES})")
  if(FLANN_CUDA_USE_STATIC)
    add_definitions(-DFLANN_CUDA_STATIC)
  endif(FLANN_CUDA_USE_STATIC)
endif(FLANN_CUDA_FOUND)
