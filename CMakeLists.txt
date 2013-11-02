cmake_minimum_required (VERSION 2.6)

project(glfw_test)


find_package(OpenGL REQUIRED)

add_subdirectory(external/glfw-3.0.3)
add_subdirectory(external)

include_directories(
	external/glfw-3.0.3/include/
	external/glew-1.10.0/include/
	external/glm/
	common

)

add_executable(glfw_test
	src/glfw_test.cpp
	common/load_render_shaders.cpp
	common/load_compute_shader.cpp
)

set(GLEW_SOURCE
	external/glew-1.10.0/src/glew.c
	)
	
set(GLEW_INCLUDE
	external/glew-1.10.0/include/GL/glew.h
	)

set(ALL_LIBS
	${OPENGL_LIBRARY}
	glfw
	GLEW_1100

)


target_link_libraries(glfw_test ${ALL_LIBS})