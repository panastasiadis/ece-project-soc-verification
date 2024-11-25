# Verifying a System-on-chip design using CAD tools 
This repository is about the main project of the course "VLSI System Design".  This course is a part of the undergraduate studies of University of Thessally - ECE Department located in Volos, Greece.

Link to the Department's official site: https://www.e-ce.uth.gr/?lang=en

## Repository Overview 

This repository contains the following parts of the project.

    1. Verilog design with Testbenches
    2. Tcl scripts, necessary to automate the process of passing the design through the CAD tools
    3. Report and presentation in greek language
    4. Files necessary for the tools to function properly (such as .synopsys_dc.setup for the Design Compiler)  

## Author

My name is Panagiotis Anastasiadis and this project was assigned to me during the time of my undergraduate studies and the enrollment of course "VLSI System Design".

#### Please consider the following:

 If there are any sights of bad practices or ambiguities regarding the file structure, code quality, the general development of the projects or the entire repo management, please mind that this work attempt to strictly focus on the course nature and fit the requirements for the assignment set by it. Also, consider the lack of expertise or experience that comes along during the time of the undergraduate studies. 

**In any case, this project was made on the purpose of learning to use the industrial CAD Tools and also the concepts of soc verification.**

## Project Overview

This project mainly focuses on the certain flow that a design has to go through rather than the concept of the verilog design itself. For this reason, 2 IP cores were downloaded from https://opencores.org a **PID Controller IP Core** and a **PWM IP Core** and "glue verilog" was written additionally, in order for the two modules to be connected to each other. Thus, the very simple use of the completed system is to convert a user-input duty cycle(%) in clock cycles through the PID Controller and pass the output result in the PWM Generator.

Following the course instructions, the project starts with verilog design and goes through Synthesis, DFT, Floorplan Design, Clock - Tree Synthesis, Placement, Routing and STA sign-off stages.

The industrial tools used for this project, were acquired by the University with academic licence from their respective companies and are the following:

    Cadence INCISIVE
    
    Synopsys Design Compiler
    
    Synopsys TetraMAX
    
    Cadence INNOVUS
 
 
