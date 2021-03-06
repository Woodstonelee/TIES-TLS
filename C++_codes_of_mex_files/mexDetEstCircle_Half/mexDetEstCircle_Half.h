#pragma once

#include <stdio.h>

#undef DEBUG
#define MATLABPRINT

#define PI 3.1415926

#include <vector>
#include <algorithm>
#include <numeric>
#include <functional>
#include <fstream>
#include <cmath>
#include <limits>

#include "mex.h"
#include "matrix.h"

#include "MatrixLZ.h"

using namespace std;

bool CppDetEstCircle3 (vector < double >x, vector < double >y,
                       double cellsize, unsigned int maxR,
                       unsigned int sigmacoef, double epsion,
                       unsigned int maxIter, unsigned int minnumfit,
                       vector < double >ScanPos,
                       vector < double >&detectedcircle,
                       vector < double >&mapfinalHTcircle,
                       vector < double >&iterationdata,
                       vector < double >&ArcInfo, vector < double >&finalx,
                       vector < double >&finaly, vector < double >&TotalOHCx,
                       vector < double >&TotalOHCy,
                       vector < double >&DebugInfo);
