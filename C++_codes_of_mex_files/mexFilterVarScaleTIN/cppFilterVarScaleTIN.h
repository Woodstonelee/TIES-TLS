#pragma once

#include <stdio.h>
#include <string>
#include <vector>
#include <fstream>
#include <limits>
#include <sstream>
#include <algorithm>

#include <cmath>

#include "mex.h"

#include "MatrixLZ.h"

using namespace std;

//const double MAXGH = 10000;
const unsigned int MAXCHAR = 32767;
const int BLOCKPSIZE = 4000000;

void cppFilterVarScaleTIN (string InPtsPathName, string InPtsFileName,
                           string GroundPtsPathName, string GroundPtsFileName,
                           vector < double >scale, vector < double >door,
                           vector < double >xlim, vector < double >ylim,
                           double &CutH, vector < double >CalCutH,
                           string NonGroundPtsPathName,
                           string NonGroundPtsFileName,
                           string EachScalePathName);
