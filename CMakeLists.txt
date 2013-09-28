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

set(ALL_LIBS
	glfw
	${GLFW_LIBRARIES}
	GLEW_1100
)

target_link_libraries( GLEW_1100
	${OPENGL_LIBRARY}
	${EXTRA_LIBS}
)

target_link_libraries(glfw_test ${ALL_LIBS})