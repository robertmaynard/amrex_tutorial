cmake_minimum_required(VERSION 3.19)

project(tutorial C CXX CUDA)

find_package(AMReX REQUIRED)

# List of source files
set(_sources main.cpp myfunc.cpp myfunc.H mykernel.H)
list(TRANSFORM _sources PREPEND "Source/")


add_executable( Basic_HeatEquation_EX2_C )
target_sources( Basic_HeatEquation_EX2_C PRIVATE ${_sources} )
target_compile_features(Basic_HeatEquation_EX2_C PUBLIC cxx_std_17 cuda_std_17)

target_link_libraries(Basic_HeatEquation_EX2_C PRIVATE AMReX::amrex )

set_target_properties( Basic_HeatEquation_EX2_C
  PROPERTIES
  CUDA_SEPARABLE_COMPILATION ON
  )

set_source_files_properties(${_sources} PROPERTIES LANGUAGE CUDA )

if(MSVC)
  set(_cuda_msvc   "$<AND:$<COMPILE_LANGUAGE:CUDA>,$<CXX_COMPILER_ID:MSVC>>")
  set(_condition  "$<VERSION_LESS:$<CXX_COMPILER_VERSION>,19.26>")

  target_compile_options( Basic_HeatEquation_EX2_C PRIVATE
    "-Xcompiler=$<${_cuda_msvc}:$<IF:${_condition},/experimental:preprocessor,/Zc:preprocessor>>")
endif()