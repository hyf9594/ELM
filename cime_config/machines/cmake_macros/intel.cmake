string(APPEND CFLAGS " -fp-model precise -std=gnu99")
if (compile_threaded)
  string(APPEND CFLAGS   " -qopenmp")
  string(APPEND CXXFLAGS " -qopenmp")
  string(APPEND FFLAGS   " -qopenmp")
  string(APPEND LDFLAGS  " -qopenmp")
endif()
if (NOT DEBUG)
  string(APPEND CFLAGS   " -O2 -debug minimal")
  string(APPEND CXXFLAGS " -O2")
  string(APPEND FFLAGS   " -O2 -debug minimal")
endif()
if (DEBUG)
  string(APPEND CFLAGS   " -O0 -g")
  string(APPEND CXXFLAGS " -O0 -g")
  string(APPEND FFLAGS   " -O0 -g -check uninit -check bounds -check pointers -fpe0 -check noarg_temp_created -init=snan,arrays")
endif()
string(APPEND CXXFLAGS " -fp-model source")
string(APPEND CPPDEFS " -DFORTRANUNDERSCORE -DNO_R16 -DCPRINTEL")
string(APPEND CXX_LDFLAGS " -cxxlib")
set(CXX_LINKER "FORTRAN")
string(APPEND FC_AUTO_R8 " -r8")
string(APPEND FFLAGS " -convert big_endian -assume byterecl -ftz -traceback -assume realloc_lhs -fp-model source")
string(APPEND FFLAGS_NOOPT " -O0")
string(APPEND FIXEDFLAGS " -fixed -132")
string(APPEND FREEFLAGS " -free")
set(HAS_F2008_CONTIGUOUS "TRUE")
set(MPICC "mpicc")
set(MPICXX "mpicxx")
set(MPIFC "mpif90")
set(SCC "icc")
set(SCXX "icpc")
set(SFC "ifort")
set(SUPPORTS_CXX "TRUE")
