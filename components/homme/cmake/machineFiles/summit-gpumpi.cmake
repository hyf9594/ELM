#interactive job
#bsub -W 2:00 -nnodes 1 -P cli115 -Is /bin/bash


#SET (HOMMEXX_MPI_ON_DEVICE FALSE CACHE BOOL "")
SET (HOMMEXX_CUDA_MAX_WARP_PER_TEAM "16" CACHE STRING  "")

#SET (NETCDF_DIR $ENV{OLCF_NETCDF_FORTRAN_ROOT} CACHE FILEPATH "")
#SET (NetCDF_Fortran_PATH "/sw/summit/spack-envs/base/opt/linux-rhel8-ppc64le/gcc-7.5.0/netcdf-fortran-4.4.5-e2hkh7w3253wz5uubjxbbvh56a7xjl7n" CACHE STRING "")
#SET(NetCDF_C_LIBRARY "/sw/summit/spack-envs/base/opt/linux-rhel8-ppc64le/gcc-7.5.0/netcdf-c-4.8.0-pwi4jbrnwv4lrrjxdu5czbos5uvvjgvr/lib" CACHE STRING "")
#SET(NetCDF_C_INCLUDE_DIR "/sw/summit/spack-envs/base/opt/linux-rhel8-ppc64le/gcc-7.5.0/netcdf-c-4.8.0-pwi4jbrnwv4lrrjxdu5czbos5uvvjgvr/include" CACHE STRING "")

SET(BUILD_HOMME_WITHOUT_PIOLIBRARY TRUE CACHE BOOL "")

SET(HOMME_FIND_BLASLAPACK TRUE CACHE BOOL "")

SET(WITH_PNETCDF FALSE CACHE FILEPATH "")

SET(USE_QUEUING FALSE CACHE BOOL "")

SET(BUILD_HOMME_PREQX_KOKKOS TRUE CACHE BOOL "")
SET(BUILD_HOMME_THETA_KOKKOS TRUE CACHE BOOL "")
#SET(HOMME_ENABLE_COMPOSE TRUE CACHE BOOL "")
SET(HOMME_ENABLE_COMPOSE FALSE CACHE BOOL "")

#SET (HOMMEXX_BFB_TESTING TRUE CACHE BOOL "")

SET(USE_TRILINOS OFF CACHE BOOL "")

SET(Kokkos_ENABLE_OPENMP OFF CACHE BOOL "")
SET(Kokkos_ENABLE_CUDA ON CACHE BOOL "")
SET(Kokkos_ENABLE_CUDA_LAMBDA ON CACHE BOOL "")
SET(Kokkos_ARCH_VOLTA70 ON CACHE BOOL "")
SET(Kokkos_ENABLE_EXPLICIT_INSTANTIATION OFF CACHE BOOL "")

SET(CMAKE_C_COMPILER "mpicc" CACHE STRING "")
SET(CMAKE_Fortran_COMPILER "mpifort" CACHE STRING "")
SET(CMAKE_CXX_COMPILER "${CMAKE_CURRENT_SOURCE_DIR}/../../externals/kokkos/bin/nvcc_wrapper" CACHE STRING "")

set (ENABLE_OPENMP OFF CACHE BOOL "")
set (ENABLE_COLUMN_OPENMP OFF CACHE BOOL "")
set (ENABLE_HORIZ_OPENMP OFF CACHE BOOL "")

set (HOMME_TESTING_PROFILE "dev" CACHE STRING "")

set (USE_NUM_PROCS 4 CACHE STRING "")

#set (OPT_FLAGS "-mcpu=power9 -mtune=power9" CACHE STRING "")
SET (USE_MPI_OPTIONS "--bind-to core" CACHE FILEPATH "")
