#include "mexDetEstCircle_Complete.h"

// mexDetEstCircle used in MATLAB: detect a circle and estimate its center position and radius from a horizontal section of stem points by Hough Transform.
// SYNTAX: [detectedcircle, mapfinalHTcircle, iterationdata, ArcInfo, finalx, finaly, DebugInfo] = mexDetEstCircle(x, y, cellsize, maxR, sigmacoef, epsion, maxIter, minnumfit)
// INPUT:
//		x, y: the x, y coordinates of points, both NumPoints*1 matrices.
//		scanpos: [scanpos_x, scanpos_y, scanpos_z], the scan position in the same coordinate system as the coordinate system of given x and y.
// OUTPUT:
//		detectedcircle: [yc, xc, r], in unit of meter.
//		mapfinalHTcircle: [yc, xc, r], in unit of meter.
//		iterationdata: [iterativecount, centerchange, radiuschange, number_of_points_in_circle_fitting_finally]
//		ArcInfo: [StartAngle, EndAngle, ArcAngle]
//		finalx, finaly: optional, the points selected out for circle fitting finally after all iterations. 
//		DebugInfo: optional, the sigma of radius of circle estimated in last iteration.
// REQUIRED ROUTINES:
//		None.
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
	// check the number of input and output arguments.
	if (nrhs != 8)
	{
		mexErrMsgTxt("mexDetEstCircle_Complete: 8 input arguments are required!");
	}
	if (nlhs != 4 && nlhs!=6 && nlhs!=7)
	{
		mexErrMsgTxt("mexDetEstCircle_Complete: 4 or 6 or 7 output arguments required!");
	}
	
	// check the type of input arguments.
	if (!(mxIsNumeric(prhs[0])))
	{
		mexErrMsgTxt("mexDetEstCircle_Complete: x is not numeric!");
	}
	if (!(mxIsNumeric(prhs[1])))
	{
		mexErrMsgTxt("mexDetEstCircle_Complete: y is not numeric!");
	}
	if (!(mxIsNumeric(prhs[2])))
	{
		mexErrMsgTxt("mexDetEstCircle_Complete: cellsize is not numeric!");
	}
	if (!(mxIsNumeric(prhs[3])))
	{
		mexErrMsgTxt("mexDetEstCircle_Complete: maxR is not numeric!");
	}
	if (!(mxIsNumeric(prhs[4])))
	{
		mexErrMsgTxt("mexDetEstCircle_Complete: sigmacoef is not numeric!");
	}
	if (!(mxIsNumeric(prhs[5])))
	{
		mexErrMsgTxt("mexDetEstCircle_Complete: epsion is not numeric!");
	}
	if (!(mxIsNumeric(prhs[6])))
	{
		mexErrMsgTxt("mexDetEstCircle_Complete: maxIter is not numeric!");
	}
	if (!(mxIsNumeric(prhs[7])))
	{
		mexErrMsgTxt("mexDetEstCircle_Complete: minnumfit is not numeric!");
	}

	unsigned int num_points;
	num_points=mxGetNumberOfElements(prhs[0]);
	if (mxGetNumberOfElements(prhs[1])!=num_points)
	{
		mexErrMsgTxt("mexDetEstCircle_Complete: x and y do not have the same length!");
	}

	// get data from mxArray and assign it to c++ style variables.
	double *pt_x, *pt_y;
	pt_x=mxGetPr(prhs[0]);
	pt_y=mxGetPr(prhs[1]);
	vector<double> x(num_points), y(num_points), detectedcircle, mapfinalHTcircle, iterationdata, ArcInfo;
	double cellsize, epsion;
	unsigned int maxR, sigmacoef, maxIter, minnumfit;
	for (unsigned int i=0; i<num_points; i++)
	{
		x[i]=pt_x[i];
		y[i]=pt_y[i];
	}
	cellsize=mxGetScalar(prhs[2]);
	maxR=static_cast<unsigned int>(mxGetScalar(prhs[3]));
	sigmacoef=static_cast<unsigned int>(mxGetScalar(prhs[4]));
	epsion=mxGetScalar(prhs[5]);
	maxIter=static_cast<unsigned int>(mxGetScalar(prhs[6]));
	minnumfit=static_cast<unsigned int>(mxGetScalar(prhs[7]));

	vector<double> finalx, finaly, TotalOHCx, TotalOHCy;
	vector<double> DebugInfo;
	finalx.clear();
	finaly.clear();
	if ( !( CppDetEstCircle4(x, y, 
		cellsize, maxR, sigmacoef, 
		epsion, maxIter, minnumfit,  
		detectedcircle, mapfinalHTcircle, iterationdata, 
		ArcInfo, 
		finalx, finaly, 
		DebugInfo)
		) )
	{
		mexErrMsgTxt("mexDetEstCircle_Complete: C++ style function: CppDetEstCircle failed!");
	}

	plhs[0]=mxCreateDoubleMatrix(1, detectedcircle.size(), mxREAL);
	plhs[1]=mxCreateDoubleMatrix(1, mapfinalHTcircle.size(), mxREAL);
	plhs[2]=mxCreateDoubleMatrix(1, iterationdata.size(), mxREAL);
	double *tempGetPr;
	tempGetPr=mxGetPr(plhs[0]);
	for (unsigned int i=0; i<detectedcircle.size(); i++)
	{
		tempGetPr[i]=detectedcircle[i];
	}
	tempGetPr=mxGetPr(plhs[1]);
	for (unsigned int i=0; i<mapfinalHTcircle.size(); i++)
	{
		tempGetPr[i]=mapfinalHTcircle[i];
	}
	tempGetPr=mxGetPr(plhs[2]);
	for (unsigned int i=0; i<iterationdata.size(); i++)
	{
		tempGetPr[i]=iterationdata[i];
	}

	plhs[3]=mxCreateDoubleMatrix(1, ArcInfo.size(), mxREAL);
	tempGetPr=mxGetPr(plhs[3]);
	for (unsigned int i=0; i<ArcInfo.size(); i++)
	{
		tempGetPr[i]=ArcInfo[i];
	}

	if (nlhs>=6)
	{
		plhs[4]=mxCreateDoubleMatrix(finalx.size(), 1, mxREAL);
		plhs[5]=mxCreateDoubleMatrix(finaly.size(), 1, mxREAL);
		tempGetPr=mxGetPr(plhs[4]);
		for (unsigned int i=0; i<finalx.size(); i++)
		{
			tempGetPr[i]=finalx[i];
		}
		tempGetPr=mxGetPr(plhs[5]);
		for (unsigned int i=0; i<finaly.size(); i++)
		{
			tempGetPr[i]=finaly[i];
		}
	}

	if (nlhs>=7)
	{
		plhs[6]=mxCreateDoubleMatrix(DebugInfo.size(), 1, mxREAL);
		tempGetPr=mxGetPr(plhs[6]);
		for (unsigned int i=0; i<DebugInfo.size(); i++)
		{
			tempGetPr[i]=DebugInfo[i];
		}
	}

}
