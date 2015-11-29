#include "cppFilterVarScaleTIN.h"

void cppFilterVarScaleTIN(string InPtsPathName, string InPtsFileName, 
						  string GroundPtsPathName, string GroundPtsFileName, 
						  vector<double> scale, vector<double> door, 
						  vector<double> xlim, vector<double> ylim, 
						  double &CutH, vector<double> CalCutH, 
						  string NonGroundPtsPathName, string NonGroundPtsFileName, 
						  string EachScalePathName)
{
	/*
	// sample codes of executing DelaunayTri and pointLocation
	mxArray *lhs[1], *rhs[2];
	rhs[0] = mxCreateDoubleMatrix(3, 1, mxREAL);
	rhs[1] = mxCreateDoubleMatrix(3, 1, mxREAL);
	double *temp;
	temp = mxGetPr(rhs[0]);
	temp[0] = 1.5; temp[1] = 4.6; temp[2] = 7;
	temp = mxGetPr(rhs[1]);
	temp[0] = 3.2; temp[1] = 9.2; temp[2] = 2.5;
	mexCallMATLABWithTrap(1, lhs, 2, rhs, "DelaunayTri");
	mxDestroyArray(rhs[0]);
	mxDestroyArray(rhs[1]);
	rhs[0] = lhs[0];
	rhs[1] = mxCreateDoubleMatrix(1, 2, mxREAL);
	temp = mxGetPr(rhs[1]);
	temp[0] = 5.5; temp[1] = 7.8;
	mexCallMATLABWithTrap(1, plhs, 2, rhs, "pointLocation");
	*/

	string strErrMsg;
	string filesep = "/"; /* for Linux: "/"; for windows: "\\" */

	bool OutNonGroundPtsFlag = false, OutEachScaleFlag = false;
	ofstream NonGroundPtsFile;
	if (NonGroundPtsFileName != "\0")
	{
		OutNonGroundPtsFlag = true;
		string tempstring;
		/*if ( NonGroundPtsPathName[NonGroundPtsPathName.size()-1] == backslashstr[0] )
		{
			tempstring.clear();
			tempstring = NonGroundPtsPathName + NonGroundPtsFileName;
		}
		else*/
		{
			tempstring.clear();
			tempstring = NonGroundPtsPathName + filesep + NonGroundPtsFileName;
		}
		
		NonGroundPtsFile.open(tempstring.c_str(), ios_base::out);
		if (!NonGroundPtsFile)
		{
			strErrMsg.clear();
			strErrMsg = "mexFilterVarScaleTIN, failed to open the file of non-ground points: \"" + tempstring + "\".";
			mexErrMsgTxt(strErrMsg.c_str());
		}
	}
	if (EachScalePathName != "\0")
	{
		OutEachScaleFlag = true;
	}
	else
	{
		EachScalePathName = GroundPtsPathName;
	}

	// Check the length of scale and door. They must be the same. 
	if (scale.size()!=door.size())
	{
		mexErrMsgTxt("mexFilterVarScaleTIN: the lengths of scale and door are not compatible!");
	}
	if (xlim.size()!=2)
	{
		mexErrMsgTxt("mexFilterVarScaleTIN: xlim does not contain two elements!");
	}
	if (ylim.size()!=2)
	{
		mexErrMsgTxt("mexFilterVarScaleTIN: ylim does not contain two elements!");
	}

	/*ifstream InPtsFile;
	InPtsFile.open(InPtsFileName.c_str(), ios_base::in);
	if (!InPtsFile)
	{
		strErrMsg.clear();
		strErrMsg = "mexFilterVarScaleTIN: failed to open the file: \"" + InPtsFileName + "\".";
		mexErrMsgTxt(strErrMsg.c_str());
	}
	InPtsFile.close();*/

	string OldPtsFileName, NewPtsFileName; // the files of extracted ground points in the previous (Old) and the current (New) scales respectively.
	ifstream OldPtsFile;
	ofstream NewPtsFile;
	OldPtsFileName = InPtsPathName + filesep + InPtsFileName;
	int xnum, ynum; // the column (ynum) and row (xnum) counts of the grid rasterized in the given cell size.
	double **GroundGridX, **GroundGridY, **GroundGridZ; // the 2D arrays record the x, y and z of the lowest point in each cell.
	mxArray *mxLowestPtsX, *mxLowestPtsY, *mxLowestPtsZ; // these arrays record the x, y and z of all the lowest point. they are used in calling MATLAB function "DelaunayTri"
	double *ptrdblLowestPtsX, *ptrdblLowestPtsY, *ptrdblLowestPtsZ;
	int ValidLPNum; // the number of all the lowest points.
	int TotalPtsNum, BlockNum, BlockSize;

	char linestr[MAXCHAR];
	istringstream linestringstream;
	double tempx, tempy, tempz;
	int tempxi, tempyi; //, tempzi;
	stringstream tempstringstream;

	for (int si=0; si<(int)scale.size(); si++)
	{
		OldPtsFile.open(OldPtsFileName.c_str(), ios_base::in);
		if (!OldPtsFile)
		{
			strErrMsg.clear();
			strErrMsg = "mexFilterVarScaleTIN, during search lowest point: failed to open the file: \"" + OldPtsFileName + "\".";
			mexErrMsgTxt(strErrMsg.c_str());
		}

		// calculate the number of rows and columns
		xnum = static_cast<int>((xlim[1] - xlim[0]) / scale[si]) + 1;
		ynum = static_cast<int>((ylim[1] - ylim[0]) / scale[si]) + 1;

		// allocate memory for three 2D arrays storing the x, y and z of the lowest point in each cell.
		GroundGridX = new double*[xnum];
		if (GroundGridX==NULL)
		{
			mexErrMsgTxt("mexFilterVarScaleTIN: No enough memory!");
		}
		GroundGridY = new double*[xnum];
		if (GroundGridY==NULL)
		{
			delete [] GroundGridX;
			mexErrMsgTxt("mexFilterVarScaleTIN: No enough memory!");
		}
		GroundGridZ = new double*[xnum];
		if (GroundGridZ==NULL)
		{
			delete [] GroundGridX;
			delete [] GroundGridY;
			mexErrMsgTxt("mexFilterVarScaleTIN: No enough memory!");
		}
		for (int i=0; i<xnum; i++)
		{
			GroundGridX[i] = new double[ynum];
			GroundGridY[i] = new double[ynum];
			GroundGridZ[i] = new double[ynum];
			if (GroundGridX[i]==NULL || GroundGridY[i]==NULL || GroundGridZ[i]==NULL)
			{
				mexErrMsgTxt("mexFilterVarScaleTIN: No enough memory!");
			}
		}

		// initialize the three 2D arrays with infinity
		for (int i=0; i<xnum; i++)
		{
			for (int j=0; j<ynum; j++)
			{
				GroundGridX[i][j] = numeric_limits<double>::infinity();
				GroundGridY[i][j] = numeric_limits<double>::infinity();
				GroundGridZ[i][j] = numeric_limits<double>::infinity();
			}
		}
		
		ValidLPNum = 0;
		TotalPtsNum = 0;
		// find the lowest point in each cell.
		while(1)
		{
			OldPtsFile.getline(linestr, MAXCHAR);
			if (!OldPtsFile)
			{
				break;
			}
			linestringstream.clear();
			linestringstream.str(linestr);
			linestringstream>>tempx>>tempy>>tempz;
			tempxi = static_cast<int>( (tempx - xlim[0]) / scale[si] );
			tempyi = static_cast<int>( (tempy - ylim[0]) / scale[si] );
			TotalPtsNum += 1;

			if ( tempz < GroundGridZ[tempxi][tempyi] )
			{
				if ( GroundGridZ[tempxi][tempyi] == numeric_limits<double>::infinity() )
				{
					ValidLPNum += 1;
				}
				GroundGridX[tempxi][tempyi] = tempx;
				GroundGridY[tempxi][tempyi] = tempy;
				GroundGridZ[tempxi][tempyi] = tempz;
			}
		}

		mxLowestPtsX = mxCreateDoubleMatrix(ValidLPNum, 1, mxREAL);
		if (mxLowestPtsX==NULL)
		{
			mexErrMsgTxt("mexFilterVarScaleTIN: No enough memory!");
		}
		mxLowestPtsY = mxCreateDoubleMatrix(ValidLPNum, 1, mxREAL);
		if (mxLowestPtsY==NULL)
		{
			mxDestroyArray(mxLowestPtsX);
			mexErrMsgTxt("mexFilterVarScaleTIN: No enough memory!");
		}
		mxLowestPtsZ = mxCreateDoubleMatrix(ValidLPNum, 1, mxREAL);
		if (mxLowestPtsZ==NULL)
		{
			mxDestroyArray(mxLowestPtsX);
			mxDestroyArray(mxLowestPtsY);
			mexErrMsgTxt("mexFilterVarScaleTIN: No enough memory!");
		}
		ptrdblLowestPtsX = mxGetPr(mxLowestPtsX);
		ptrdblLowestPtsY = mxGetPr(mxLowestPtsY);
		ptrdblLowestPtsZ = mxGetPr(mxLowestPtsZ);
		int temp = 0;
		double MaxLPZ = -1*numeric_limits<double>::infinity(), MinLPZ = numeric_limits<double>::infinity();
		for (int i=0; i<xnum; i++)
		{
			for (int j=0; j<ynum; j++)
			{
				if ( GroundGridZ[i][j] == numeric_limits<double>::infinity() )
				{
					continue;
				}
				ptrdblLowestPtsX[temp] = GroundGridX[i][j];
				ptrdblLowestPtsY[temp] = GroundGridY[i][j];
				ptrdblLowestPtsZ[temp] = GroundGridZ[i][j];

				if ( ptrdblLowestPtsZ[temp] > MaxLPZ )
				{
					MaxLPZ = ptrdblLowestPtsZ[temp];
				}
				if ( ptrdblLowestPtsZ[temp] < MinLPZ )
				{
					MinLPZ = ptrdblLowestPtsZ[temp];
				}

				temp += 1;				
			}
		}
		// Create the TIN using all the lowest points.
		mxArray *plhsTIN[1], *prhsTIN[2];
		prhsTIN[0] = mxLowestPtsX;
		prhsTIN[1] = mxLowestPtsY;
		mexCallMATLABWithTrap(1, plhsTIN, 2, prhsTIN, "DelaunayTri");

		// In the last (minimum) grid scale, calculate the cut height of the ground points.
		if (si == (int)scale.size()-1)
		{
			if ( isnan(CutH) )
			{
				if ( isnan(CalCutH[0]) || isnan(CalCutH[1]) )
				{
					mexErrMsgTxt("mexFilterVarScaleTIN: either CutH or CalCutH must be numeric values, not NaN, not empty or not Inf.");
				}
				double cellsizeZ = CalCutH[0], multiplier = CalCutH[1];
				int LayerNum = static_cast<int>((MaxLPZ - MinLPZ) / cellsizeZ) + 1;
				vector<int> LayerHist(LayerNum);
				for (int i=0; i<ValidLPNum; i++)
				{
					LayerHist[static_cast<int>( (ptrdblLowestPtsZ[i] - MinLPZ) / cellsizeZ )] += 1;
				}
				vector<int>::iterator iterMaxLayer;
				iterMaxLayer = max_element(LayerHist.begin(), LayerHist.end());
				CutH = (1 + multiplier) * ( iterMaxLayer - LayerHist.begin() ) * cellsizeZ + MinLPZ;
			}
		}

		// Look through all the points in the old file, extract the ground points and write them into NewPtsFile.
		tempstringstream.clear();
		tempstringstream<<EachScalePathName<<filesep<<"scale_"<<scale[si]<<"_"<<InPtsFileName;
		NewPtsFileName.clear();
		getline(tempstringstream, NewPtsFileName);
		if (si == (int)scale.size()-1)
		{
			NewPtsFileName = GroundPtsPathName + filesep + GroundPtsFileName;
		}

		NewPtsFile.open(NewPtsFileName.c_str(), ios_base::out);
		if (!NewPtsFile)
		{
			strErrMsg.clear();
			strErrMsg = "mexFilterVarScaleTIN, failed to open the newly created file: \"" + NewPtsFileName + "\".";
			mexErrMsgTxt(strErrMsg.c_str());
		}
		NewPtsFile.precision(6);
		OldPtsFile.clear();
		OldPtsFile.seekg(0, ios_base::beg);

		mxArray *plhspL[1], *prhspL[3], *mxTIN;
		double *ptrdblQueryPX, *ptrdblQueryPY, *ptrdblQueryPZ, *ptrdblSI, *ptrdblTIN;
		int SI, TriVertex[3], TriNum;
		double planeA, planeB, planeC, planeD, NormalDist;
		mxTIN = mxGetProperty(plhsTIN[0], 0, "Triangulation");
		ptrdblTIN = mxGetPr(mxTIN);
		TriNum = (int)mxGetM(mxTIN);

		prhspL[0] = plhsTIN[0];

		// Divide the whole points into multiple blocks. Call the MATLAB function "pointLocation" block by block so as to shorten the processing time.
		BlockNum = TotalPtsNum / BLOCKPSIZE + 1;
		BlockSize = BLOCKPSIZE;
		prhspL[1] = mxCreateDoubleMatrix(BlockSize, 1, mxREAL);
		prhspL[2] = mxCreateDoubleMatrix(BlockSize, 1, mxREAL);
		ptrdblQueryPX = mxGetPr(prhspL[1]);
		ptrdblQueryPY = mxGetPr(prhspL[2]);
		ptrdblQueryPZ = new double [BlockSize];
		for (int i=0; i<BlockNum; i++)
		{
			if (i == BlockNum-1)
			{
				BlockSize = TotalPtsNum % BLOCKPSIZE;
				mxDestroyArray(prhspL[1]);
				mxDestroyArray(prhspL[2]);
				delete [] ptrdblQueryPZ;
				prhspL[1] = mxCreateDoubleMatrix(BlockSize, 1, mxREAL);
				if (prhspL[1]==NULL)
				{
					mexErrMsgTxt("mexFilterVarScaleTIN: No enough memory!");
				}
				prhspL[2] = mxCreateDoubleMatrix(BlockSize, 1, mxREAL);
				if (prhspL[2]==NULL)
				{
					mxDestroyArray(prhspL[1]);
					mexErrMsgTxt("mexFilterVarScaleTIN: No enough memory!");
				}
				ptrdblQueryPX = mxGetPr(prhspL[1]);
				ptrdblQueryPY = mxGetPr(prhspL[2]);
				ptrdblQueryPZ = new double [BlockSize];
			}
			
			for (int j=0; j<BlockSize; j++)
			{
				OldPtsFile.getline(linestr, MAXCHAR);
				/*if (!OldPtsFile)
				{
					break;
				}*/
				linestringstream.clear();
				linestringstream.str(linestr);
				linestringstream>>ptrdblQueryPX[j]>>ptrdblQueryPY[j]>>ptrdblQueryPZ[j];
			}
			mexCallMATLABWithTrap(1, plhspL, 3, prhspL, "pointLocation");
			ptrdblSI = mxGetPr(plhspL[0]);
			for (int j=0; j<BlockSize; j++)
			{
				if (mxIsNaN(ptrdblSI[j]))
				{
					// this point is outside the TIN, not in any triangular.
					continue;
				}
				else
				{
					// get the vertices of the triangular in which this point locate.
					SI = static_cast<int>( (ptrdblSI[j]) - 1 );
					TriVertex[0] = (int)ptrdblTIN[ MatrixLZ::sub2ind(SI, 0, TriNum, 3, MatrixLZ::ColMajor) ];
					TriVertex[1] = (int)ptrdblTIN[ MatrixLZ::sub2ind(SI, 1, TriNum, 3, MatrixLZ::ColMajor) ];
					TriVertex[2] = (int)ptrdblTIN[ MatrixLZ::sub2ind(SI, 2, TriNum, 3, MatrixLZ::ColMajor) ];

					planeA = ( ptrdblLowestPtsY[TriVertex[1]-1] - ptrdblLowestPtsY[TriVertex[0]-1] )*( ptrdblLowestPtsZ[TriVertex[2]-1] - ptrdblLowestPtsZ[TriVertex[0]-1] ) 
						- ( ptrdblLowestPtsY[TriVertex[2]-1] - ptrdblLowestPtsY[TriVertex[0]-1] )*( ptrdblLowestPtsZ[TriVertex[1]-1] - ptrdblLowestPtsZ[TriVertex[0]-1] );
					planeB = ( ptrdblLowestPtsX[TriVertex[1]-1] - ptrdblLowestPtsX[TriVertex[0]-1] )*( ptrdblLowestPtsZ[TriVertex[2]-1] - ptrdblLowestPtsZ[TriVertex[0]-1] ) 
						- ( ptrdblLowestPtsX[TriVertex[2]-1] - ptrdblLowestPtsX[TriVertex[0]-1] )*( ptrdblLowestPtsZ[TriVertex[1]-1] - ptrdblLowestPtsZ[TriVertex[0]-1] );
					planeB *= -1;
					planeC = ( ptrdblLowestPtsX[TriVertex[1]-1] - ptrdblLowestPtsX[TriVertex[0]-1] )*( ptrdblLowestPtsY[TriVertex[2]-1] - ptrdblLowestPtsY[TriVertex[0]-1] ) 
						- ( ptrdblLowestPtsX[TriVertex[2]-1] - ptrdblLowestPtsX[TriVertex[0]-1] )*( ptrdblLowestPtsY[TriVertex[1]-1] - ptrdblLowestPtsY[TriVertex[0]-1] );
					planeD = planeA*ptrdblLowestPtsX[TriVertex[0]-1] + planeB*ptrdblLowestPtsY[TriVertex[0]-1] + planeC*ptrdblLowestPtsZ[TriVertex[0]-1];
					planeD *= -1;

					tempx = ptrdblQueryPX[j];
					tempy = ptrdblQueryPY[j];
					tempz = ptrdblQueryPZ[j];

					NormalDist = fabs(planeA*tempx + planeB*tempy + planeC*tempz + planeD);
					NormalDist = NormalDist / sqrt( planeA*planeA + planeB*planeB + planeC*planeC);

					if (si==(int)scale.size()-1)
					{
						if (NormalDist<door[si] && tempz<CutH)
						{
							NewPtsFile<<tempx<<"\t"<<tempy<<"\t"<<tempz<<endl;
						}
						else
						{
							if (OutNonGroundPtsFlag)
							{
								NonGroundPtsFile<<tempx<<"\t"<<tempy<<"\t"<<tempz<<endl;
							}
						}
					}
					else
					{
						if (NormalDist<door[si])
						{
							NewPtsFile<<tempx<<"\t"<<tempy<<"\t"<<tempz<<endl;
						}
						else
						{
							if (OutNonGroundPtsFlag)
							{
								NonGroundPtsFile<<tempx<<"\t"<<tempy<<"\t"<<tempz<<endl;
							}
						}
					}
				}
			}
			mxDestroyArray(plhspL[0]);
		}
		mxDestroyArray(prhspL[1]);
		mxDestroyArray(prhspL[2]);
		delete [] ptrdblQueryPZ;
		mxDestroyArray(mxTIN);

		OldPtsFile.close();
		NewPtsFile.close();

		// free the memory of the three 2D arrays
		for (int i=0; i<xnum; i++)
		{
			delete [] GroundGridX[i];
			delete [] GroundGridY[i];
			delete [] GroundGridZ[i];
		}
		delete [] GroundGridX;
		delete [] GroundGridY;
		delete [] GroundGridZ;

		mxDestroyArray(mxLowestPtsX);
		mxDestroyArray(mxLowestPtsY);
		mxDestroyArray(mxLowestPtsZ);
		mxDestroyArray(plhsTIN[0]);

		if ( (!OutEachScaleFlag)&&(si>0) )
		{
			if ( !remove(OldPtsFileName.c_str()) )
			{
			}	
		}

		OldPtsFileName = NewPtsFileName;
	}

	if (OutNonGroundPtsFlag)
	{
		NonGroundPtsFile.close();
	}	
}
