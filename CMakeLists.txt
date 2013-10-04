cmake_minimum_required (VERSION 2.6)

project(glfw_test)

find_package(OpenGL REQUIRED)


add_subdirectory(external/glfw-3.0.3)

include_directories(
	external/glfw-3.0.3/include/
	external/glew-1.10.0/include/
	external/glm/
)

add_executable(glfw_test
	src/glfw_test.cpp
)

set(GLEW_SOURCE
	external/glew-1.10.0/src/glew.c
)

add_library( GLEW_1100 STATIC
	${GLEW_SOURCE}
)



target_link_libraries( GLEW_1100
	${OPENGL_LIBRARY}
	${EXTRA_LIBS}
)

#GLEW libraries
add_library(glew_static STATIC IMPORTED)
set_target_properties(glew_static PROPERTIES
    IMPORTED_LOCATION external/glew-1.10.0-win32/glew-1.10.0/lib/Release/Win32/glew32.lib)

set(ALL_LIBS
	glfw
	${GLFW_LIBRARIES}
	glew_static
	
)

target_link_libraries(glfw_test ${ALL_LIBS})