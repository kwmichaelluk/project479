cmake_minimum_required (VERSION 2.8.11)

project (p479)

set(Boost_USE_STATIC_LIBS OFF) 
set(Boost_USE_MULTITHREADED ON)  
set(Boost_USE_STATIC_RUNTIME OFF) 
find_package(Boost 1.58.0 REQUIRED COMPONENTS filesystem system) 
find_package(PkgConfig REQUIRED)	
find_package(OpenGL REQUIRED)
find_package(GLEW REQUIRED)

pkg_search_module(GLFW REQUIRED glfw3)

include_directories(${Boost_INCLUDE_DIRS} ${GLFW_INCLUDE_DIRS} ${OPENGL_INCLUDE_DIRS} ${GLEW_INCLUDE_DIRS} ${CMAKE_CURRENT_SOURCE_DIR}) 

add_subdirectory (bodies)
add_subdirectory (stage)
add_subdirectory (tools)

add_executable(main main.cpp)

target_link_libraries(main bodies stage tools ${Boost_LIBRARIES} ${OPENGL_LIBRARIES} ${GLEW_LIBRARIES} ${GLFW_STATIC_LIBRARIES})