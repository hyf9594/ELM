# This file is intended to be included by build_model function. Any changes
# to CMAKE variables intended to impact the CMakeLists.txt file that called
# build_model must use PARENT_SCOPE.

# Add INCROOT to path for Depends and Include
set(MINCROOT "")
if (INCROOT)
  list(APPEND CPP_DIRS ${INCROOT})
  set(MINCROOT ${INCROOT})
endif ()

if (USE_ESMF_LIB)
  set(ESMFDIR "esmf")
else()
  set(ESMFDIR "noesmf")
endif()

# Determine whether any C++ code will be included in the build;
# currently, C++ code is included if and only if we're linking to the
# trilinos library or the Albany library.
set(USE_CXX FALSE)
if (USE_TRILINOS OR USE_ALBANY OR USE_KOKKOS)
  set(USE_CXX TRUE)
endif()

if (NOT MOD_SUFFIX)
  set(MOD_SUFFIX "mod")
endif()

# Look for -crm samxx in the CAM_CONFIG_OPTS CIME variable
# If it's found, then enable USE_SAMXX
string(FIND "${CAM_CONFIG_OPTS}" "-crm samxx" HAS_SAMXX)
if (NOT HAS_SAMXX EQUAL -1)
  # The following is for the SAMXX code:
  set(USE_SAMXX TRUE)
endif()

string(FIND "${CAM_CONFIG_OPTS}" "-rrtmgpxx" HAS_RRTMGPXX)
if (NOT HAS_RRTMGPXX EQUAL -1)
  # The following is for the RRTMGPXX code:
  set(USE_RRTMGPXX TRUE)
endif()

# If samxx or rrtmgpxx is being used, then YAKL must be used as well
if (USE_SAMXX OR USE_RRTMGPXX)
    set(USE_YAKL TRUE)
else()
    set(USE_YAKL FALSE)
endif()

# If YAKL is being used, then we need to enable USE_CXX
if (${USE_YAKL})
  set(USE_CXX TRUE)
endif()

#===============================================================================
# set CPP options (must use this before any flags or cflags settings)
#===============================================================================
include(${CASEROOT}/Macros.cmake)

set(CPPDEFS "${CPPDEFS} ${USER_CPPDEFS} -D${OS}")

# SLIBS comes from Macros, so this append must come after Macros are included

if (DEBUG)
  set(CPPDEFS "${CPPDEFS} -DNDEBUG")
endif()

if (USE_ESMF_LIB)
  set(CPPDEFS "${CPPDEFS} -DUSE_ESMF_LIB")
endif()

if (COMP_INTERFACE STREQUAL "nuopc")
  set(CPPDEFS "${CPPDEFS} -DNUOPC_INTERFACE")
else()
  set(CPPDEFS "${CPPDEFS} -DMCT_INTERFACE")
endif()

if (COMPARE_TO_NUOPC)
  set(CPPDEFS "${CPPDEFS} -DCOMPARE_TO_NUOPC")
endif()

if (MPILIB STREQUAL mpi-serial)
  set(CPPDEFS "${CPPDEFS} -DNO_MPI2")
else()
  set(CPPDEFS "${CPPDEFS} -DHAVE_MPI")
endif()

if (PIO_VERSION STREQUAL "1")
  set(CPPDEFS "${CPPDEFS} -DPIO1")
else()
  set(USE_CXX TRUE)
endif()

if (USE_CXX AND NOT SUPPORTS_CXX)
  message(FATAL_ERROR "Fatal attempt to include C++ code on a compiler/machine combo that has not been set up to support C++")
endif()

# Not clear how to escape commas for libraries with their own configure
# script, and they don't need this defined anyway, so leave this out of
# FPPDEFS.
if (HAS_F2008_CONTIGUOUS)
  if (CPRE)
    set(CONTIGUOUS_FLAG "${CPRE}USE_CONTIGUOUS=contiguous,")
  else()
    set(CONTIGUOUS_FLAG "-DUSE_CONTIGUOUS=contiguous,")
  endif()
else()
  if (CPRE)
    set(CONTIGUOUS_FLAG "${CPRE}USE_CONTIGUOUS=")
  else()
    set(CONTIGUOUS_FLAG "-DUSE_CONTIGUOUS=")
  endif()
endif()

# JGF TODO: replace with findnetcdf
if (NETCDF_C_PATH)
  if (NOT NETCDF_FORTRAN_PATH)
    message(FATAL_ERROR "NETCDF_C_PATH specified without NETCDF_FORTRAN_PATH")
  endif()
  set(NETCDF_SEPARATE TRUE)
  if (NOT INC_NETCDF_C)
    set(INC_NETCDF_C ${NETCDF_C_PATH}/include)
  endif()
  if (NOT INC_NETCDF_FORTRAN)
    set(INC_NETCDF_FORTRAN ${NETCDF_FORTRAN_PATH}/include)
  endif()
  if (NOT LIB_NETCDF_C)
    if (EXISTS ${NETCDF_C_PATH}/lib)
      set(LIB_NETCDF_C ${NETCDF_C_PATH}/lib)
    elseif (EXISTS ${NETCDF_C_PATH}/lib64)
      set(LIB_NETCDF_C ${NETCDF_C_PATH}/lib64)
    else()
      message(FATAL_ERROR "NETCDF_C_PATH does not contain a lib or lib64 directory")
    endif()
  endif()
  if (NOT LIB_NETCDF_FORTRAN)
    if(EXISTS ${NETCDF_FORTRAN_PATH}/lib)
      set(LIB_NETCDF_FORTRAN ${NETCDF_FORTRAN_PATH}/lib)
    elseif(EXISTS ${NETCDF_FORTRAN_PATH}/lib64)
      set(LIB_NETCDF_FORTRAN ${NETCDF_FORTRAN_PATH}/lib64)
    else()
      message(FATAL_ERROR "NETCDF_FORTRAN_PATH does not contain a lib or lib64 directory")
    endif()
  endif()
elseif (NETCDF_FORTRAN_PATH)
  message(FATAL_ERROR "NETCDF_FORTRAN_PATH specified without NETCDF_C_PATH")
elseif (NETCDF_PATH)
  set(NETCDF_SEPARATE FALSE)
  if (NOT INC_NETCDF)
    set(INC_NETCDF ${NETCDF_PATH}/include)
  endif()
  if (NOT LIB_NETCDF)
    if (EXISTS ${NETCDF_PATH}/lib)
      set(LIB_NETCDF ${NETCDF_PATH}/lib)
    elseif(EXISTS ${NETCDF_PATH}/lib64)
      set(LIB_NETCDF ${NETCDF_PATH}/lib64)
    else()
      message(FATAL_ERROR "NETCDF_PATH does not contain a lib or lib64 directory")
    endif()
  endif()
else()
  message(FATAL_ERROR "NETCDF not found: Define NETCDF_PATH or NETCDF_C_PATH and NETCDF_FORTRAN_PATH in config_machines.xml or config_compilers.xml")
endif()

if (MPILIB STREQUAL mpi-serial)
  if (PNETCDF_PATH)
    unset(PNETCDF_PATH)
  endif()
else()
  if (PNETCDF_PATH)
    if (NOT INC_PNETCDF)
      set(INC_PNETCDF ${PNETCDF_PATH}/include)
    endif()
    if (NOT LIB_PNETCDF)
      set(LIB_PNETCDF ${PNETCDF_PATH}/lib)
    endif()
  endif()
endif()

# Set HAVE_SLASHPROC on LINUX systems which are not bluegene or Darwin (OSx)
string(FIND "${CPPDEFS}" "-DLINUX" HAS_DLINUX)
string(FIND "${CPPDEFS}" "DBG" HAS_DBG)
string(FIND "${CPPDEFS}" "Darwin" HAS_DARWIN)
if (NOT HAS_DLINUX EQUAL -1 AND HAS_DBG EQUAL -1 AND HAS_DARWIN EQUAL -1)
  set(CPPDEFS "${CPPDEFS} -DHAVE_SLASHPROC")
endif()

# Atleast on Titan+cray mpi, MPI_Irsends() are buggy, causing hangs during I/O
# Force PIO to use MPI_Isends instead of the default, MPI_Irsends
if (PIO_VERSION STREQUAL 2)
  set(EXTRA_PIO_CPPDEFS "-DUSE_MPI_ISEND_FOR_FC")
else()
  set(EXTRA_PIO_CPPDEFS "-D_NO_MPI_RSEND")
endif()

if (LIB_PNETCDF)
  set(CPPDEFS "${CPPDEFS} -D_PNETCDF")
  set(SLIBS "${SLIBS} -L${LIB_PNETCDF} -lpnetcdf")
endif()

#===============================================================================
# User-specified INCLDIR
#===============================================================================

set(INCLDIR ".")
if (USER_INCLDIR)
  list(APPEND INCLDIR "${USER_INCLDIR}")
endif()

#===============================================================================
# Set compilers
#===============================================================================

if (MPILIB STREQUAL "mpi-serial")
  set(CC ${SCC})
  set(FC ${SFC})
  set(CXX ${SCXX})
  set(MPIFC ${SFC})
  set(MPICC ${SCC})
  set(MPICXX ${SCXX})
else()
  set(CC ${MPICC})
  set(FC ${MPIFC})
  set(CXX ${MPICXX})
  if (MPI_PATH)
    set(INC_MPI ${MPI_PATH}/include)
    set(LIB_MPI ${MPI_PATH}/lib)
  endif()
endif()
set(CSM_SHR_INCLUDE ${INSTALL_SHAREDPATH}/${COMP_INTERFACE}/${ESMFDIR}/${NINST_VALUE}/include)

#===============================================================================
# Set include paths (needed after override for any model specific builds below)
#===============================================================================
list(APPEND INCLDIR "${INSTALL_SHAREDPATH}/include" "${INSTALL_SHAREDPATH}/${COMP_INTERFACE}/${ESMFDIR}/${NINST_VALUE}/include")

if (NOT NETCDF_SEPARATE)
  list(APPEND INCLDIR "${INC_NETCDF}")
else()
  list(APPEND INCLDIR "${INC_NETCDF_C}" "${INC_NETCDF_FORTRAN}")
endif()

foreach(ITEM MOD_NETCDF INC_MPI INC_PNETCDF)
  if (${ITEM})
    list(APPEND INCLDIR "${${ITEM}}")
  endif()
endforeach()

if (NOT MCT_LIBDIR)
  set(MCT_LIBDIR "${INSTALL_SHAREDPATH}/lib")
endif()

if (PIO_LIBDIR)
  if (PIO_VERSION STREQUAL ${PIO_VERSION_MAJOR})
    list(APPEND INCLDIR "${PIO_INCDIR}")
    set(SLIBS "${SLIBS} -L${PIO_LIBDIR}")
  else()
    # If PIO_VERSION_MAJOR doesnt match, build from source
    unset(PIO_LIBDIR)
  endif()
endif()
if (NOT PIO_LIBDIR)
  set(PIO_LIBDIR "${INSTALL_SHAREDPATH}/lib")
endif()

if (NOT GPTL_LIBDIR)
  set(GPTL_LIBDIR "${INSTALL_SHAREDPATH}/lib")
endif()

if (NOT GLC_DIR)
  set(GLC_DIR "${EXEROOT}/glc")
endif()

if (NOT CISM_LIBDIR)
  set(CISM_LIBDIR "${GLC_DIR}/lib")
endif()

if (NOT GLCROOT)
  # Backwards compatibility
  set(GLCROOT "${CIMEROOT}/../components/cism")
endif()

list(APPEND INCLDIR "${INSTALL_SHAREDPATH}/include")

string(FIND "${CAM_CONFIG_OPTS}" "-cosp" HAS_COSP)
if (NOT HAS_COSP EQUAL -1)
  # The following is for the COSP simulator code:
  set(USE_COSP TRUE)
endif()

# System libraries (netcdf, mpi, pnetcdf, esmf, etc.)
if (NOT SLIBS)
  if (NOT NETCDF_SEPARATE)
    set(SLIBS "-L${LIB_NETCDF} -lnetcdff -lnetcdf")
  else()
    set(SLIBS "-L${LIB_NETCDF_FORTRAN} -L${LIB_NETCDF_C} -lnetcdff -lnetcdf")
  endif()
endif()

if (LAPACK_LIBDIR)
  set(SLIBS "${SLIBS} -L${LAPACK_LIBDIR} -llapack -lblas")
endif()

if (LIB_MPI)
  if (NOT MPI_LIB_NAME)
    set(SLIBS "${SLIBS} -L${LIB_MPI} -lmpi")
  else()
    set(SLIBS "${SLIBS} -L${LIB_MPI} -l${MPI_LIB_NAME}")
  endif()
endif()

# Add libraries and flags that we need on the link line when C++ code is included
if (USE_CXX)
  if (CXX_LIBS)
    set(SLIBS "${SLIBS} ${CXX_LIBS}")
  endif()

  if (CXX_LDFLAGS)
    set(LDFLAGS "${LDFLAGS} ${CXX_LDFLAGS}")
  endif()
endif()

# Decide whether to use a C++ or Fortran linker, based on whether we
# are using any C++ code and the compiler-dependent CXX_LINKER variable
if (USE_CXX AND CXX_LINKER STREQUAL "CXX")
  set(LD "CXX")
else()
  set(LD "Fortran")
  # Remove arch flag if it exists, it break fortran linking
  string(REGEX REPLACE "-arch[^ ]+" "" LDFLAGS "${LDFLAGS}")
endif()

if (NOT IO_LIB_SRCROOT)
  if (PIO_VERSION STREQUAL 2)
    # This is a pio2 library
    set(PIOLIB "${PIO_LIBDIR}/libpiof.a ${PIO_LIBDIR}/libpioc.a")
    set(PIOLIBNAME "-lpiof -lpioc")
    set(PIO_SRC_DIR "${CIMEROOT}/src/externals/pio2")
  else()
    # This is a pio1 library
    set(PIOLIB "${PIO_LIBDIR}/libpio.a")
    set(PIOLIBNAME "-lpio")
    if (NOT EXISTS "${CIMEROOT}/src/externals/pio1/pio")
      set(PIO_SRC_DIR "${CIMEROOT}/src/externals/pio1")
    else()
      set(PIO_SRC_DIR "${CIMEROOT}/src/externals/pio1/pio")
    endif()
  endif()
else()
  set(IO_LIB_SRC_DIR "IO_LIB_v${PIO_VERSION}_SRCDIR")
  set(PIO_SRC_DIR "${IO_LIB_SRCROOT}/${IO_LIB_SRC_DIR}")
endif()

set(MCTLIBS "${MCT_LIBDIR}/libmct.a ${MCT_LIBDIR}/libmpeu.a")

set(GPTLLIB "${GPTL_LIBDIR}/libgptl.a")

#------------------------------------------------------------------------------
# Set key cmake vars
#------------------------------------------------------------------------------
set(CMAKE_EXE_LINKER_FLAGS "${LDFLAGS}" PARENT_SCOPE)
