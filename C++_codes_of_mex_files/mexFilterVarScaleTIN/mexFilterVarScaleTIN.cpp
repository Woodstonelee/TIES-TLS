#include "cppFilterVarScaleTIN.h"

/*
 mexFilterVarScaleTIN(InPtsPathName, InPtsFileName, 
					  GroundPtsPathName, GroundPtsFileName, 
					  scale, door, 
					  xlim, ylim, 
					  CutH, CalCutH, 
					  NonGroundPtsPathName, NonGroundPtsFileName, 
					  EachScalePathName)
 INPUT: 
	InPtsPathName, InPtsFileName: both strings, the path and file name of the input point clouds.
		Format: no header, in each line: x y z
	GroundPtsPathName, GroundPtsFileName: both strings, the path and file anme of the output ground points.
		Format: no header, in each line: x y z
	scale: N-length vector, the cell size at each scale, N is the number of scales.
	door: N-length vector, the distance threshold used to select ground points at each scale, N is the number of scales.
	xlim, ylim: both two-length vectors, the extent of x and y in the rasterization.
	CutH: scalar, the cut height used to exclude non-ground points. If it is designated, it will be used. If it is empty or NaN, CalCutH must be given to determine the CutH.
	CalCutH: two-length vector, [ThicknessZ, Coefficient], ThicknessZ is used to stratify the points into layers across the Z axis. Coefficient is used to determine the CutH with the point distribution from all the layers.
	NonGroundPtsPathName, NonGroundPtsFileName: both strings, the path and file name of the output non-ground points.
		Format: no header, in each line: x y z
	EachScalePathName: the path of directory for the files of remaining points in each iterations.

 OUTPUT:

 REQUIRED ROUTINES:

 */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
	// check the number of arguments.
	if (nrhs<9)
	{
		mexErrMsgTxt("mexFilterVarScaleTIN: At least 9 arguments are required as inputs!");
	}
	if (nrhs>13)
	{
		mexErrMsgTxt("mexFilterVarScaleTIN: At most 13 arguments are required as inputs!");
	}
	if (nlhs>1)
	{
		mexErrMsgTxt("mexFilterVarScaleTIN: at most 1 output argument is allowed!");
	}

	// get the values of input arguments and assign them to C++ styled variables such as string, vector and so on.
	char *tempptrchar;
	int strlen;
	string InPtsPathName, InPtsFileName, GroundPtsPathName, GroundPtsFileName;
	string NonGroundPtsPathName("\0"), NonGroundPtsFileName("\0"), EachScalePathName("\0");
	double *tempptrdbl;
	int NumElem;
	vector<double> scale, door, xlim, ylim, CalCutH;
	double CutH;
	if (nrhs>8)
	{
		if (!mxIsChar(prhs[0]))
		{
			mexErrMsgTxt("mexFilterVarScaleTIN: InPtsPathName is not a string!");
		}
		else
		{
			//strlen = (int)mxGetNumberOfElements(prhs[0]) + 1;
			//tempptrchar = new char[strlen];
			//mxGetString(prhs[0], tempptrchar, strlen);
			//InPtsPathName.assign(tempptrchar);
			//delete [] tempptrchar;

			tempptrchar = mxArrayToString(prhs[0]);
			InPtsPathName.assign(tempptrchar);
			mxFree(tempptrchar);
		}

		if (!mxIsChar(prhs[1]))
		{
			mexErrMsgTxt("mexFilterVarScaleTIN: InPtsFileName is not a string!");
		}
		else
		{
			//strlen = (int)mxGetNumberOfElements(prhs[1]) + 1;
			//tempptrchar = new char[strlen];
			//mxGetString(prhs[1], tempptrchar, strlen);
			//InPtsFileName.assign(tempptrchar);
			//delete [] tempptrchar;

			tempptrchar = mxArrayToString(prhs[1]);
			InPtsFileName.assign(tempptrchar);
			mxFree(tempptrchar);
		}

		if (!mxIsChar(prhs[2]))
		{
			mexErrMsgTxt("mexFilterVarScaleTIN: GroundPtsPathName is not a string!");
		}
		else
		{
			//strlen = (int)mxGetNumberOfElements(prhs[2]) + 1;
			//tempptrchar = new char[strlen];
			//mxGetString(prhs[2], tempptrchar, strlen);
			//GroundPtsPathName.assign(tempptrchar);
			//delete [] tempptrchar;

			tempptrchar = mxArrayToString(prhs[2]);
			GroundPtsPathName.assign(tempptrchar);
			mxFree(tempptrchar);
		}

		if (!mxIsChar(prhs[3]))
		{
			mexErrMsgTxt("mexFilterVarScaleTIN: GroundPtsFileName is not a string!");
		}
		else
		{
			//strlen = (int)mxGetNumberOfElements(prhs[3]) + 1;
			//tempptrchar = new char[strlen];
			//mxGetString(prhs[3], tempptrchar, strlen);
			//GroundPtsFileName.assign(tempptrchar);
			//delete [] tempptrchar;

			tempptrchar = mxArrayToString(prhs[3]);
			GroundPtsFileName.assign(tempptrchar);
			mxFree(tempptrchar);
		}

		if (!mxIsNumeric(prhs[4]))
		{
			mexErrMsgTxt("mexFilterVarScaleTIN: scale is not numeric!");
		}
		else
		{
			NumElem = (int)mxGetNumberOfElements(prhs[4]);
			scale.assign(NumElem, 0);
			tempptrdbl = mxGetPr(prhs[4]);
			for (int i=0; i<NumElem; i++)
			{
				scale[i] = tempptrdbl[i];
			}
		}

		if (!mxIsNumeric(prhs[5]))
		{
			mexErrMsgTxt("mexFilterVarScaleTIN: door is not numeric!");
		}
		else
		{
			NumElem = (int)mxGetNumberOfElements(prhs[5]);
			door.assign(NumElem, 0);
			tempptrdbl = mxGetPr(prhs[5]);
			for (int i=0; i<NumElem; i++)
			{
				door[i] = tempptrdbl[i];
			}
		}

		if (!mxIsNumeric(prhs[6]))
		{
			mexErrMsgTxt("mexFilterVarScaleTIN: xlim is not numeric!");
		}
		else
		{
			NumElem = (int)mxGetNumberOfElements(prhs[6]);
			xlim.assign(NumElem, 0);
			tempptrdbl = mxGetPr(prhs[6]);
			for (int i=0; i<NumElem; i++)
			{
				xlim[i] = tempptrdbl[i];
			}
		}

		if (!mxIsNumeric(prhs[7]))
		{
			mexErrMsgTxt("mexFilterVarScaleTIN: ylim is not numeric!");
		}
		else
		{
			NumElem = (int)mxGetNumberOfElements(prhs[7]);
			ylim.assign(NumElem, 0);
			tempptrdbl = mxGetPr(prhs[7]);
			for (int i=0; i<NumElem; i++)
			{
				ylim[i] = tempptrdbl[i];
			}
		}

		if (!mxIsNumeric(prhs[8]))
		{
			mexErrMsgTxt("mexFilterVarScaleTIN: CutH is not numeric!");
		}
		else
		{
			NumElem = (int)mxGetNumberOfElements(prhs[8]);
			if (NumElem>1)
			{
				mexErrMsgTxt("mexFilterVarScaleTIN: CutH is not scalar!");
			}
			tempptrdbl = mxGetPr(prhs[8]);
			if (mxIsEmpty(prhs[8]) || mxIsNaN(*tempptrdbl))
			{
				CutH = numeric_limits<double>::quiet_NaN();
				if (nrhs<9)
				{
					mexErrMsgTxt("mexFilterVarScaleTIN: CutH is empty or NaN, CalCutH must be given to determine the CutH!");
				}
			}
			else
			{
				CutH = tempptrdbl[0];
			}
		}
	}
	if (nrhs>9)
	{
		if (!mxIsNumeric(prhs[9]))
		{
			mexErrMsgTxt("mexFilterVarScaleTIN: CalCutH is not numeric!");
		}
		else
		{
			NumElem = (int)mxGetNumberOfElements(prhs[9]);
			if (NumElem!=2)
			{
				mexErrMsgTxt("mexFilterVarScaleTIN: CalCutH must be a two-elements vector, one is cell size along the Z axis and the other is the coefficient.");
			}
			tempptrdbl = mxGetPr(prhs[9]);
			CalCutH.assign(NumElem, 0);
			if (mxIsEmpty(prhs[8]) || mxIsNaN(tempptrdbl[0]) || mxIsNaN(tempptrdbl[1]))
			{
				for (int i=0; i<NumElem; i++)
				{
					CalCutH[i] = numeric_limits<double>::quiet_NaN();
				}
			}
			else
			{
				for (int i=0; i<NumElem; i++)
				{
					CalCutH[i] = tempptrdbl[i];
				}
			}
		}
	}
	if (nrhs>10)
	{
		if (nrhs<12)
		{
			mexErrMsgTxt("mexFilterVarScaleTIN: NonGroundPtsPathName and NonGroundPtsFileName must be both given!");
		}

		if (!( mxIsEmpty(prhs[10])||mxIsEmpty(prhs[11]) ))
		{
			if (!mxIsChar(prhs[10]))
			{
				mexErrMsgTxt("mexFilterVarScaleTIN: NonGroundPtsPathName is not a string!");
			}
			else
			{
				//strlen = (int)mxGetNumberOfElements(prhs[10]) + 1;
				//tempptrchar = new char[strlen];
				//mxGetString(prhs[10], tempptrchar, strlen);
				//NonGroundPtsPathName.assign(tempptrchar);
				//delete [] tempptrchar;

				tempptrchar = mxArrayToString(prhs[10]);
				NonGroundPtsPathName.assign(tempptrchar);
				mxFree(tempptrchar);
			}

			if (!mxIsChar(prhs[11]))
			{
				mexErrMsgTxt("mexFilterVarScaleTIN: NonGroundPtsFileName is not a string!");
			}
			else
			{
				//strlen = (int)mxGetNumberOfElements(prhs[11]) + 1;
				//tempptrchar = new char[strlen];
				//mxGetString(prhs[11], tempptrchar, strlen);
				//NonGroundPtsFileName.assign(tempptrchar);
				//delete [] tempptrchar;

				tempptrchar = mxArrayToString(prhs[11]);
				NonGroundPtsFileName.assign(tempptrchar);
				mxFree(tempptrchar);
			}
		}
	}
	if (nrhs>12)
	{
		if (!mxIsEmpty(prhs[12]))
		{
			if (!mxIsChar(prhs[12]))
			{
				mexErrMsgTxt("mexFilterVarScaleTIN: EachScalePathName is not a string!");
			}
			else
			{
				//strlen = (int)mxGetNumberOfElements(prhs[12]) + 1;
				//tempptrchar = new char[strlen];
				//mxGetString(prhs[12], tempptrchar, strlen);
				//EachScalePathName.assign(tempptrchar);
				//delete [] tempptrchar;

				tempptrchar = mxArrayToString(prhs[12]);
				EachScalePathName.assign(tempptrchar);
				mxFree(tempptrchar);
			}
		}
	}

	cppFilterVarScaleTIN(InPtsPathName, InPtsFileName, 
						  GroundPtsPathName, GroundPtsFileName, 
						  scale, door, 
						  xlim, ylim, 
						  CutH, CalCutH, 
						  NonGroundPtsPathName, NonGroundPtsFileName, 
						  EachScalePathName);

	if (nlhs>0)
	{
		plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
		tempptrdbl = mxGetPr(plhs[0]);
		tempptrdbl[0] = CutH;
	}
}
