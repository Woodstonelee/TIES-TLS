#include "mexDetEstCircle_Half.h"

// the gate of mexw32: mexFunction
// mexDetEstCircle used in MATLAB: detect a circle and estimate its center position and radius from a horizontal section of stem points by Hough Transform.
// SYNTAX: [detectedcircle, mapfinalHTcircle, iterationdata, ArcInfo, finalx, finaly, TotalOHCx, TotalOHCy, DebugInfo] = mexDetEstCircle(x, y, cellsize, maxR, sigmacoef, epsion, maxIter, minnumfit, scanpos)
// INPUT:
//              x, y: the x, y coordinates of points, both NumPoints*1 matrices.
//              scanpos: [scanpos_x, scanpos_y, scanpos_z], the scan position in the same coordinate system as the coordinate system of given x and y.
// OUTPUT:
//              detectedcircle: [yc, xc, r], in unit of meter.
//              mapfinalHTcircle: [yc, xc, r], in unit of meter.
//              iterationdata: [iterativecount, centerchange, radiuschange, number_of_points_in_circle_fitting_finally]
//              ArcInfo: [StartAngle, EndAngle, ArcAngle]
//              finalx, finaly: optional, the points selected out for circle fitting finally after all iterations. 
//              TotalOHCx, TotalOHCy: optional, the points outside half circle detected in last iteration. 
//              DebugInfo: optional, the sigma of radius of circle estimated in last iteration. 
// REQUIRED ROUTINES:
//              None.
void
mexFunction (int nlhs, mxArray * plhs[], int nrhs, const mxArray * prhs[])
{
  // check the number of input and output arguments.
  if (nrhs != 9) {
    mexErrMsgTxt ("9 input arguments are required!");
  }
  if (nlhs != 4 && nlhs != 6 && nlhs != 8 && nlhs != 9) {
    mexErrMsgTxt ("4 or 6 or 8 or 9 output arguments required!");
  }
  // check the type of input arguments.
  if (!(mxIsNumeric (prhs[0]))) {
    mexErrMsgTxt ("x is not numeric!");
  }
  if (!(mxIsNumeric (prhs[1]))) {
    mexErrMsgTxt ("y is not numeric!");
  }
  if (!(mxIsNumeric (prhs[2]))) {
    mexErrMsgTxt ("cellsize is not numeric!");
  }
  if (!(mxIsNumeric (prhs[3]))) {
    mexErrMsgTxt ("maxR is not numeric!");
  }
  if (!(mxIsNumeric (prhs[4]))) {
    mexErrMsgTxt ("sigmacoef is not numeric!");
  }
  if (!(mxIsNumeric (prhs[5]))) {
    mexErrMsgTxt ("epsion is not numeric!");
  }
  if (!(mxIsNumeric (prhs[6]))) {
    mexErrMsgTxt ("maxIter is not numeric!");
  }
  if (!(mxIsNumeric (prhs[7]))) {
    mexErrMsgTxt ("minnumfit is not numeric!");
  }
  if (!(mxIsNumeric (prhs[8]))) {
    mexErrMsgTxt ("scanpos is not numeric!");
  } else {
    if (mxGetNumberOfElements (prhs[8]) != 3) {
      mexErrMsgTxt ("scanpos is not vector with 3 elements!");
    }
  }

  unsigned int num_points;
  num_points = mxGetNumberOfElements (prhs[0]);
  if (mxGetNumberOfElements (prhs[1]) != num_points) {
    mexErrMsgTxt ("x and y do not have the same length!");
  }
  // get data from mxArray and assign it to c++ style variables.
  double *pt_x, *pt_y;
  pt_x = mxGetPr (prhs[0]);
  pt_y = mxGetPr (prhs[1]);
  vector < double >x (num_points), y (num_points), detectedcircle,
    mapfinalHTcircle, iterationdata, ArcInfo;
  double cellsize, epsion;
  unsigned int maxR, sigmacoef, maxIter, minnumfit;
  for (unsigned int i = 0; i < num_points; i++) {
    x[i] = pt_x[i];
    y[i] = pt_y[i];
  }
  cellsize = mxGetScalar (prhs[2]);
  maxR = static_cast < unsigned int >(mxGetScalar (prhs[3]));
  sigmacoef = static_cast < unsigned int >(mxGetScalar (prhs[4]));
  epsion = mxGetScalar (prhs[5]);
  maxIter = static_cast < unsigned int >(mxGetScalar (prhs[6]));
  minnumfit = static_cast < unsigned int >(mxGetScalar (prhs[7]));

  vector < double >scanpos (3);
  double *ptr_scanpos;
  ptr_scanpos = mxGetPr (prhs[8]);
  for (unsigned int i = 0; i < 3; i++) {
    scanpos[i] = ptr_scanpos[i];
  }

  vector < double >finalx, finaly, TotalOHCx, TotalOHCy;
  vector < double >DebugInfo;
  finalx.clear ();
  finaly.clear ();
  if (!(CppDetEstCircle3 (x, y,
                          cellsize, maxR, sigmacoef,
                          epsion, maxIter, minnumfit,
                          scanpos,
                          detectedcircle, mapfinalHTcircle, iterationdata,
                          ArcInfo,
                          finalx, finaly, TotalOHCx, TotalOHCy, DebugInfo)
      )) {
    mexErrMsgTxt ("C++ style function: CppDetEstCircle failed!");
  }

  plhs[0] = mxCreateDoubleMatrix (1, detectedcircle.size (), mxREAL);
  plhs[1] = mxCreateDoubleMatrix (1, mapfinalHTcircle.size (), mxREAL);
  plhs[2] = mxCreateDoubleMatrix (1, iterationdata.size (), mxREAL);
  double *tempGetPr;
  tempGetPr = mxGetPr (plhs[0]);
  for (unsigned int i = 0; i < detectedcircle.size (); i++) {
    tempGetPr[i] = detectedcircle[i];
  }
  tempGetPr = mxGetPr (plhs[1]);
  for (unsigned int i = 0; i < mapfinalHTcircle.size (); i++) {
    tempGetPr[i] = mapfinalHTcircle[i];
  }
  tempGetPr = mxGetPr (plhs[2]);
  for (unsigned int i = 0; i < iterationdata.size (); i++) {
    tempGetPr[i] = iterationdata[i];
  }

  plhs[3] = mxCreateDoubleMatrix (1, ArcInfo.size (), mxREAL);
  tempGetPr = mxGetPr (plhs[3]);
  for (unsigned int i = 0; i < ArcInfo.size (); i++) {
    tempGetPr[i] = ArcInfo[i];
  }

  if (nlhs >= 6) {
    plhs[4] = mxCreateDoubleMatrix (finalx.size (), 1, mxREAL);
    plhs[5] = mxCreateDoubleMatrix (finaly.size (), 1, mxREAL);
    tempGetPr = mxGetPr (plhs[4]);
    for (unsigned int i = 0; i < finalx.size (); i++) {
      tempGetPr[i] = finalx[i];
    }
    tempGetPr = mxGetPr (plhs[5]);
    for (unsigned int i = 0; i < finaly.size (); i++) {
      tempGetPr[i] = finaly[i];
    }
  }

  if (nlhs >= 8) {
    plhs[6] = mxCreateDoubleMatrix (TotalOHCx.size (), 1, mxREAL);
    plhs[7] = mxCreateDoubleMatrix (TotalOHCy.size (), 1, mxREAL);
    tempGetPr = mxGetPr (plhs[6]);
    for (unsigned int i = 0; i < TotalOHCx.size (); i++) {
      tempGetPr[i] = TotalOHCx[i];
    }
    tempGetPr = mxGetPr (plhs[7]);
    for (unsigned int i = 0; i < TotalOHCy.size (); i++) {
      tempGetPr[i] = TotalOHCy[i];
    }
  }

  if (nlhs >= 9) {
    plhs[8] = mxCreateDoubleMatrix (DebugInfo.size (), 1, mxREAL);
    tempGetPr = mxGetPr (plhs[8]);
    for (unsigned int i = 0; i < DebugInfo.size (); i++) {
      tempGetPr[i] = DebugInfo[i];
    }
  }

}
