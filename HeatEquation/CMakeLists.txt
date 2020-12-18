cmake_minimum_required(VERSION 3.19)

project(HeatEquation C CXX CUDA)

find_package(AMReX REQUIRED)

# List of source files
set(_sources main.cpp myfunc.cpp myfunc.H mykernel.H)
list(TRANSFORM _sources PREPEND "Source/")

# List of input files
file( GLOB_RECURSE _input_files LIST_DIRECTORIES false Exec/input* )

setup_tutorial(_sources _input_files
			   BASE_NAME HeatEquation
			   )