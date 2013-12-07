 add_definitions(
	-DGLEW_STATIC
)


include_directories(
	glew-1.10.0/include
)

set(GLEW_SOURCE
	glew-1.10.0/src/glew.c
)

set(GLEW_HEADERS
)



add_library( GLEW_1100 STATIC
	${GLEW_SOURCE}
	${GLEW_INCLUDE}
)

set(EXTRA_LIBS "-framework Cocoa -framework OpenGL -framework IOKit -framework Foundation -framework AppKit")

target_link_libraries(GLEW_1100
	${OPENGL_LIBRARY}
	${EXTRA_LIBS}
)