//
//  load_compute_shader.cpp
//  glfw_test
//
//  Created by NANCY CHEN on 13-10-11.
//  Copyright (c) 2013 University of British Columbia. All rights reserved.
//


#include <stdio.h>
#include <string>
#include <vector>
#include <iostream>
#include <fstream>
#include <algorithm>
using namespace std;

#include <stdlib.h>
#include <string.h>

#include <GL/glew.h>

#include "load_compute_shader.hpp"

GLuint LoadComputeProgram(const char * compute_file_path){
    // Create the shaders
	GLuint ComputeShaderID = glCreateShader(GL_COMPUTE_SHADER);
	
	// Read the Compute Shader code from the file
	std::string ComputeShaderCode;
	std::ifstream ComputeShaderStream(compute_file_path, std::ios::in);
	if(ComputeShaderStream.is_open()){
		std::string Line = "";
		while(getline(ComputeShaderStream, Line))
			ComputeShaderCode += "\n" + Line;
		ComputeShaderStream.close();
	}else{
		printf("Impossible to open %s. Are you in the right directory ? Don't forget to read the FAQ !\n", compute_file_path);
		return 0;
	}
    
	GLint Result = GL_FALSE;
	int InfoLogLength;
    
	// Compile Compute Shader
	printf("Compiling shader : %s\n", compute_file_path);
	char const * ComputeSourcePointer = ComputeShaderCode.c_str();
	glShaderSource(ComputeShaderID, 1, &ComputeSourcePointer , NULL);
	glCompileShader(ComputeShaderID);
    
	// Check Copmute Shader
	glGetShaderiv(ComputeShaderID, GL_COMPILE_STATUS, &Result);
	glGetShaderiv(ComputeShaderID, GL_INFO_LOG_LENGTH, &InfoLogLength);
	if ( InfoLogLength > 0 ){
		std::vector<char> ComputeShaderErrorMessage(InfoLogLength+1);
		glGetShaderInfoLog(ComputeShaderID, InfoLogLength, NULL, &ComputeShaderErrorMessage[0]);
		printf("%s\n", &ComputeShaderErrorMessage[0]);
	}
    
   
    
	// Link the program
	printf("Linking program\n");
	GLuint ComputePrograMID = glCreateProgram();
	glAttachShader(ComputePrograMID, ComputeShaderID);
	glLinkProgram(ComputePrograMID);
    
	// Check the program
	glGetProgramiv(ComputePrograMID, GL_LINK_STATUS, &Result);
	glGetProgramiv(ComputePrograMID, GL_INFO_LOG_LENGTH, &InfoLogLength);
	if ( InfoLogLength > 0 ){
		std::vector<char> ProgramErrorMessage(InfoLogLength+1);
		glGetProgramInfoLog(ComputePrograMID, InfoLogLength, NULL, &ProgramErrorMessage[0]);
		printf("%s\n", &ProgramErrorMessage[0]);
	}
    
	glDeleteShader(ComputeShaderID);
    
	return ComputePrograMID;
}
