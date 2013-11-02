cmake_minimum_required (VERSION 2.6)

project(glfw_test)

find_package(OpenGL REQUIRED)


SOURCE_GROUP(common REGULAR_EXPRESSION ".*/common/.*" )

add_subdirectory(external/glfw-3.0.3)

include_directories(
	external/glfw-3.0.3/include/
	external/glew-1.10.0/include/
	external/glm/
)

add_executable(glfw_test
	src/glfw_test.cpp
	common/load_render_shaders.h
	common/load_compute_shader.h
	common/load_render_shaders.cpp
	common/load_compute_shader.cpp
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

set_target_properties(glfw_test PROPERTIES XCODE_ATTRIBUTE_CONFIGURATION_BUILD_DIR "${CMAKE_CURRENT_SOURCE_DIR}")
