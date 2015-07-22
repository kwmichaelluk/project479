add_library(bodies cube.cpp objloader.cpp spheres.cpp texture.cpp walls.cpp)

target_include_directories (bodies PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})