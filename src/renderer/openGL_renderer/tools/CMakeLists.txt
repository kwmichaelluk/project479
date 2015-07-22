add_library(tools camera.cpp ini_reader.cpp memmap_reader.cpp shader_utils.cpp)

target_include_directories (tools PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})