The C++ code files in this folder are written by Zhan Li from 2010 to 2011.
All the codes were debugged in MATLAB2009 on a Windows system. 
All the code was also test in MATLAB2011a on a Unix/Linux system in 2012

The C++ code files in each subfolder are used to create a individual mex... (... denotes a string indicating operation system) file that can be called in MATLAB.
Use the following steps to create mex file in MATLAB:
1. Open MATLAB and in the command line:
> mex -setup
Then you will be prompted to setup the C++ compiler the MATLAB will use to compile C++ files. Choose one compiler available listed on the screen. Any complier should work.
2. Change the working directory to the folder where the C++ code files are.
3. In the command line:
> mex -I"[the path of MATLAB2009HeaderFiles]" -output [the name of the mex file without extention name] [list of all the C++ files used to create the mex file]
Example, in the folder of "mexDetEstCircle_Half"
> mex -I"/net/casfsb/vol/ssrchome/active_users/zhanli86/TIES-TLS/C++_codes_of_mex_files/MATLAB2009HeaderFiles" -output test cppDetEstCircle_Half.cpp mexDetEstCircle_Half.cpp

Note: the header files ("matrix.h" and "mex.h") in the folder "MATLAB2009HeaderFiles" are from MATLAB2009. Ideally the header files from the MATLAB after version 2009 should also work. You can simply drop the option "-I" in the mex command then you will use the header files from your current MATLAB. In case the output mex file doesn't work, please return back to the version2009 header files.
Usually these two files are in this folder:
[Path of MATLAB installation]\extern\include

If you use compilers other than the MATLAB command "mex", for example Visual Studio, two extra things need to be done:
1. Include the header files ("matrix.h" and "mex.h") from MATLAB in your own compiler.
2. You might need to add the .def file in each subfolder to tell the compiler to export DLL (i.e. the mex file is the name which the DLL is called in MATLAB)

Thank you for using these files.
The following referrence should be included. You are appreciated. Also more information about the input parameters can be found in the following paper.
Huang, H., Li, Z., Gong, P., Cheng, X., Clinton, N., Cao, C., Ni, W., and Wang, L., 2011. Automated Methods for Measuring DBH and Tree Heights with a Commercial Scanning LiDAR, Photogrammetric Engineering & Remote Sensing, 77 (3): 219-227.