cmake_minimum_required(VERSION 3.19)
project(tutorials C CXX CUDA)

find_package(AMReX REQUIRED)


include(setup_tutorial.cmake)

add_subdirectory(CNS)
add_subdirectory(HeatEquation)