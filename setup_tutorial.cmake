#
# Function to setup the tutorials
#
function (setup_tutorial _srcs  _inputs)

   cmake_parse_arguments( "" "HAS_FORTRAN_MODULES"
      "BASE_NAME;RUNTIME_SUBDIR;EXTRA_DEFINITIONS" "" ${ARGN} )

   if (_BASE_NAME)
      set(_base_name ${_BASE_NAME})
   else ()
      string(REGEX REPLACE ".*Tutorials/" "" _base_name ${CMAKE_CURRENT_LIST_DIR})
      string(REPLACE "/" "_" _base_name ${_base_name})
   endif ()

   # Prepend "Tutorial_" to base name
   set(_base_name "Tutorial_${_base_name}")

   if (_RUNTIME_SUBDIR)
      set(_exe_dir ${CMAKE_CURRENT_BINARY_DIR}/${_RUNTIME_SUBDIR})
   else ()
      set(_exe_dir ${CMAKE_CURRENT_BINARY_DIR})
   endif ()

   set( _exe_name  ${_base_name} )

   add_executable( ${_exe_name} )

   target_sources( ${_exe_name} PRIVATE ${${_srcs}} )

   set_target_properties( ${_exe_name} PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${_exe_dir} )

   if (_EXTRA_DEFINITIONS)
      target_compile_definitions(${_exe_name} PRIVATE ${_EXTRA_DEFINITIONS})
   endif ()

   # Find out which include directory is needed
   set(_includes ${${_srcs}})
   list(FILTER _includes INCLUDE REGEX "\\.H$")
   foreach(_item IN LISTS _includes)
      get_filename_component( _include_dir ${_item} DIRECTORY)
      target_include_directories( ${_exe_name} PRIVATE  ${_include_dir} )
   endforeach()

   if (_HAS_FORTRAN_MODULES)
      target_include_directories(${_exe_name}
         PRIVATE
         ${CMAKE_CURRENT_BINARY_DIR}/mod_files)
      set_target_properties( ${_exe_name}
         PROPERTIES
         Fortran_MODULE_DIRECTORY
         ${CMAKE_CURRENT_BINARY_DIR}/mod_files )
   endif ()

   target_link_libraries( ${_exe_name} AMReX::amrex )

   set_target_properties( ${_exe_name}
      PROPERTIES
      CUDA_SEPARABLE_COMPILATION ON      # This adds -dc
      )

   if(CMAKE_CUDA_COMPILER)
      get_target_property(_sources ${_exe_name} SOURCES)
      list(FILTER _sources INCLUDE REGEX "\\.cpp$")
      set_source_files_properties(${_sources} PROPERTIES LANGUAGE CUDA )

      if(MSVC)
         set(_cuda_msvc   "$<AND:$<COMPILE_LANGUAGE:CUDA>,$<CXX_COMPILER_ID:MSVC>>")
         set(_condition  "$<VERSION_LESS:$<CXX_COMPILER_VERSION>,19.26>")

         target_compile_options( ${_exe_name} PRIVATE
            "-Xcompiler=$<${_cuda_msvc}:$<IF:${_condition},/experimental:preprocessor,/Zc:preprocessor>>"
         )
      endif ()
   endif()

   if (${_inputs})
      file( COPY ${${_inputs}} DESTINATION ${_exe_dir} )
   endif ()

endfunction ()