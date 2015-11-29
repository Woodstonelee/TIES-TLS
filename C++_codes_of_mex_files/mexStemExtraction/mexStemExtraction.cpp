#define DEBUG

#include "mex.h"
#include "matrix.h"
#include "MatrixLZ.h"

#include <valarray>
#include <algorithm>
#include <fstream>
#include <cmath>
#include <limits>
#include <vector>

using namespace std;
using namespace MatrixLZ;

const int NONSTEMPTSID = 0;

/*=================================================================
 * algorithm revised by Zhan Li, 2010-7, CppStemExtraction add an 
 argument "char *nonstemptsfile", giving the name of file used to 
 output non-stem points, if nonstemptsfile==NULL, do not output 
 non-stem points!
 *=================================================================*/

bool CppStemExtraction(double *x, double *y, double *z, 
					   double minx, double miny, double minz, 
					   double maxx, double maxy, double maxz, 
					   double cellx, double celly, double cellz, 
					   double *voxelarray_yrow, double *voxelarray_xcol, double *voxelarray_zvertica, double *voxelarray_pnum, 
					   double *indexvector, double zflag, double maxstemlength, vector<double> dem, vector<unsigned int> dim_dem, vector<double> deminfo, 
					   char *stemptsfile, char *nonstemptsfile, 
					   size_t np, size_t voxelnum)
{
	//double *testmin, *testmax;
	//testmin=min_element(x, x+np-1);
	//testmax=max_element(x, x+np-1);
	//if ( !(*testmin==minx && *testmax==maxx) )
	//{
	//	mexWarnMsgTxt("The given minimum or maximum of x is not consistent with the actual of given x!");
	//	//return false;
	//}
	//testmin=min_element(y, y+np-1);
	//testmax=max_element(y, y+np-1);
	//if ( !(*testmin==miny && *testmax==maxy) )
	//{
	//	mexWarnMsgTxt("The given minimum or maximum of y is not consistent with the actual of given y!");
	//	//return false;
	//}
	//testmin=min_element(z, z+np-1);
	//testmax=max_element(z, z+np-1);
	//if ( !(*testmin==minz && *testmax==maxz) )
	//{
	//	mexWarnMsgTxt("The given minimum or maximum of z is not consistent with the actual of given z!");
	//	//return false;
	//}

        if (sizeof(int)!=4)
	{
		mexErrMsgTxt("Sorry the current version only support machines with 4-byte int type! We are working to fix this stupid bug...");
		return false;
	}
	
	if ( (maxx-minx)>numeric_limits<int>::max()*cellx )
	{
		mexPrintf("CppStemExtraction ==> x extend exceeds the limits: %f meter\n!", numeric_limits<int>::max()*cellx);
		return false;
	}
	if ( (maxy-miny)>numeric_limits<int>::max()*celly )
	{
		mexPrintf("CppStemExtraction ==> y extend exceeds the limits: %f meter\n!", numeric_limits<int>::max()*celly);
		return false;
	}
	if ( (maxz-minz)>numeric_limits<int>::max()*cellz )
	{
		mexPrintf("CppStemExtraction ==> z extend exceeds the limits: %f meter\n!", numeric_limits<int>::max()*cellz);
		return false;
	}
	
	int xpixelnum, ypixelnum, zpixelnum;
	xpixelnum=static_cast<int>(floor((maxx-minx)/cellx))+1;
	ypixelnum=static_cast<int>(floor((maxy-miny)/celly))+1;
	zpixelnum=static_cast<int>(floor((maxz-minz)/cellz))+1;

	ofstream stemptsfstream, nonstemptsfstream;
	stemptsfstream.open(stemptsfile, ios_base::out);
	if (!stemptsfstream)
	{
		mexErrMsgTxt("StemPtsFile opened failed!");
		return false;
	}
	bool outputnonstempts=false;
	if (nonstemptsfile!=NULL)
	{
		outputnonstempts=true;
		nonstemptsfstream.open(nonstemptsfile, ios_base::out);
		if (!nonstemptsfstream)
		{
			mexErrMsgTxt("NonStemPtsFile opened failed!");
			return false;
		}
		nonstemptsfstream.precision(6);
		nonstemptsfstream<<fixed;

	}

	double currentyrow, currentxcol, nextyrow, nextxcol, currentindex;
	valarray<int> barsection_pnum(zpixelnum);
	barsection_pnum=0;
	valarray<bool> barsection_continuouscount(zpixelnum);
	barsection_continuouscount=false;
	//valarray<bool> voxelarray_continuous(xpixelnum*ypixelnum*zpixelnum);
	//voxelarray_continuous=false;
	valarray<unsigned char> voxelarray_continuous( (xpixelnum*ypixelnum*zpixelnum/8)+1 );
	voxelarray_continuous=0;
	int index_byte, index_bit;
	int continuouscount=0;
	currentyrow=voxelarray_yrow[0];
	currentxcol=voxelarray_xcol[0];
	barsection_pnum[static_cast<int>(voxelarray_zvertica[0]-1)]= static_cast<int>(voxelarray_pnum[0]);
	int belownum, abovenum;
	bool continuousflag;
	belownum=static_cast<int>(zflag/2);
	abovenum=static_cast<int>(zflag-belownum)-1;

	for(size_t vcount=1; vcount<voxelnum; vcount++)
	{
		nextyrow=voxelarray_yrow[vcount];
		nextxcol=voxelarray_xcol[vcount];
		if(currentyrow==nextyrow && currentxcol==nextxcol)
		{
			barsection_pnum[static_cast<int>(voxelarray_zvertica[vcount]-1)] = static_cast<int>(voxelarray_pnum[vcount]);
		}
		else
		{
			for(size_t zcount=belownum; zcount < static_cast<unsigned int>(zpixelnum-abovenum); zcount++)
			{
				continuousflag=true;
				for(int rindex=belownum*(-1); rindex<abovenum+1; rindex++)
				{
					continuousflag= continuousflag && (barsection_pnum[zcount+rindex]);
				}
				if(continuousflag)
				{
					for(int rindex=belownum*(-1); rindex<abovenum+1; rindex++)
					{
						currentindex=(zcount+rindex)*ypixelnum*xpixelnum + (currentxcol-1)*ypixelnum + currentyrow;
						//voxelarray_continuous[ static_cast<unsigned __int32>(currentindex) ]=true;
						index_byte=static_cast<unsigned int>(currentindex)/8;
						index_bit=static_cast<unsigned int>(currentindex) % 8;
						voxelarray_continuous[index_byte]=voxelarray_continuous[index_byte] | ( 1<<( (index_bit-1+8) % 8 ) );
					}
					//zcount += static_cast<unsigned int>(zflag);
				}
				//else
				//{
				//	zcount += 1;
				//}
			}
			currentyrow=nextyrow;
			currentxcol=nextxcol;
			barsection_pnum=0;
			barsection_pnum[static_cast<int>(voxelarray_zvertica[vcount]-1)] = static_cast<int>(voxelarray_pnum[vcount]);
		}
	}

	double topz;
	unsigned int currentxpix, currentypix;
	//topz=maxstemlength+minz;
	stemptsfstream.precision(6);
	stemptsfstream<<fixed;
	if (maxstemlength==mxGetInf())
	{
		for (size_t pcount=0; pcount < np; pcount++)
		{
			currentindex=indexvector[pcount];

			index_byte=static_cast<unsigned int>(currentindex)/8;
			index_bit=static_cast<unsigned int>(currentindex) % 8;

			//currentypix = static_cast<unsigned int>( floor((y[pcount] - deminfo[3]) / deminfo[4]) );
			//currentypix = currentypix>0 ? currentypix : 0;
			//currentypix = currentypix<deminfo[1] ? currentypix : deminfo[1];
			//currentxpix = static_cast<unsigned int>( floor((x[pcount] - deminfo[2]) / deminfo[4]) );
			//currentxpix = currentxpix>0 ? currentxpix : 0;
			//currentxpix = currentxpix<deminfo[0] ? currentypix : deminfo[0];

			if ( ( voxelarray_continuous[index_byte] & (1<<( (index_bit-1+8) % 8 )) ) )
			{
				stemptsfstream<<x[pcount]<<"\t"<<y[pcount]<<"\t"<<z[pcount]<<endl;
			}
			else
			{
				if (outputnonstempts)
				{
					nonstemptsfstream<<x[pcount]<<"\t"<<y[pcount]<<"\t"<<z[pcount]<<"\t"<<NONSTEMPTSID<<endl;
				}
			}
		}
	}
	else
	{
		for (size_t pcount=0; pcount < np; pcount++)
		{
			currentindex=indexvector[pcount];

			index_byte=static_cast<unsigned int>(currentindex)/8;
			index_bit=static_cast<unsigned int>(currentindex) % 8;

			currentypix = static_cast<unsigned int>( floor((y[pcount] - deminfo[3]) / deminfo[4]) );
			currentypix = currentypix>0 ? currentypix : 0;
			currentypix = static_cast<unsigned int>( currentypix<deminfo[1] ? currentypix : deminfo[1] );
			currentxpix = static_cast<unsigned int>( floor((x[pcount] - deminfo[2]) / deminfo[4]) );
			currentxpix = currentxpix>0 ? currentxpix : 0;
			currentxpix = static_cast<unsigned int>( currentxpix<deminfo[0] ? currentypix : deminfo[0] );

			if ( dem[ MatrixLZ::sub2ind(currentypix, currentxpix, dim_dem[0], dim_dem[1], MatrixLZ::ColMajor) ] == deminfo[5] )
			{
				if (outputnonstempts)
				{
					nonstemptsfstream<<x[pcount]<<"\t"<<y[pcount]<<"\t"<<z[pcount]<<"\t"<<NONSTEMPTSID<<endl;
				}
				continue;
			}

			topz=dem[ MatrixLZ::sub2ind(currentypix, currentxpix, dim_dem[0], dim_dem[1], MatrixLZ::ColMajor) ]+maxstemlength;

			if ( ( z[pcount]<=topz ) && ( voxelarray_continuous[index_byte] & (1<<( (index_bit-1+8) % 8 )) ) )
			{
				stemptsfstream<<x[pcount]<<"\t"<<y[pcount]<<"\t"<<z[pcount]<<endl;
			}
			else
			{
				if (outputnonstempts)
				{
					nonstemptsfstream<<x[pcount]<<"\t"<<y[pcount]<<"\t"<<z[pcount]<<"\t"<<NONSTEMPTSID<<endl;
				}
			}
		}
	}

	stemptsfstream.close();
	return true;

}

// mexStemExtraction used in MATLAB:
// SYNTAX: mexStemExtraction (x, y, z, p2rInfo, VoxelArray, IndexVector, zflag, maxstemlength, DEM, DEMInfo, StemPtsFile, NonStemPtsFile)
// INPUT:
//		x, y, z: coordinates of points, column-vector, each is np*1 matrix, np is the number of points.
//		p2rInfo: 3*3 matrix, giving the information of converting points cloud to raster, including:
//			minimum and maximum of x, y, z of all points and cell size along each axis, 
//			[minx, miny, minz; 
//			 maxx, maxy, maxz;
//			 cellx, celly, cellz].
//		VoxelArray: N*4 matrix, N is the number of voxels containing points, 
//			each row of matrix giving the position of this voxel and the number of points in that voxel:
//			[row(y), col(x), vertica(z), point_num]. based from 1.
//			the same row and column have to be in continuous in vector row and col.
//		IndexVector: np*1 matrix, np is the number of points, i.e. the length of x or y or z, 
//			for each point, giving the index in 3D raster of the voxel containing that point. based from 1.
//		zflag: scalar, the threshold of continuous voxel number along z axis used to identify stem voxels.
//		maxstemlength: the maximum stem length, points higher than this value will be removed as crown points.
//		DEM: a 2D matrix giving the height of ground, with cellsize given by p2rInfo, the number of rows and cols are the same with number of rows and cols indicated by VoxelArray
//		DEMInfo: a vector, [ncol, nrow, xllcorner, yllcorner, cellsize, nodata], xllcorner and yllcorner is the coordinate of left low corner of the left low cell, i.e. the minimum coordinates of x and y.  
//		StemPtsFile: a string, giving the stem points file path and name, to be written.
//		NonStemPtsFile: optional, a string, giving the non-stem points file path and name, to be written.
// OUTPUT:
//		None.
// REQUIRED ROUTINES:
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
	// check the number of input and outpu arguments.
	if (nrhs!=11 && nrhs!=12)
	{
		mexErrMsgTxt("11 or 12 input arguments are required!");
	}
	if (nlhs>0)
	{
		mexErrMsgTxt("No output arguments is required!");
	}

	// check the type and element number of input arguments.
	size_t ndim, ndim4, plength[3], ivlength, voxelnum, demrow, demcol;
	const mwSize *dims, *dims4;
	if (!(mxIsNumeric(prhs[0])))
	{
		mexErrMsgTxt("x is not numeric!");
	}
	if (!(mxIsNumeric(prhs[1])))
	{
		mexErrMsgTxt("y is not numeric!");
	}
	if (!(mxIsNumeric(prhs[2])))
	{
		mexErrMsgTxt("z is not numeric!");
	}
	if (!(mxIsNumeric(prhs[3])))
	{
		mexErrMsgTxt("p2rInfo is not numeric!");
	}
	else
	{
		ndim= mxGetNumberOfDimensions(prhs[3]);
		if (ndim!=2)
		{
			mexErrMsgTxt("p2rInfo is not a 2D matrix!");
		}
		else
		{
			/*dims=( const_cast<int*>(mxGetDimensions(prhs[3])) );*/
			dims=( (mxGetDimensions(prhs[3])) );
			if (!(dims[0]==3 && dims[1]==3))
			{
				mexErrMsgTxt("p2rInfo: numbers of elements in dimensions are not right!");
			}
			//mxFree(dims);
		}
	}
	if (!(mxIsNumeric(prhs[4])))
	{
		mexErrMsgTxt("VoxelArray is not numeric!");
	}
	else
	{
		ndim4=mxGetNumberOfDimensions(prhs[4]);
		if (ndim4!=2)
		{
			mexErrMsgTxt("VoxelArray is not a 2D matrix!");
		}
		else
		{
			/*dims4=( const_cast<int*>(mxGetDimensions(prhs[4])) );*/
			dims4=( (mxGetDimensions(prhs[4])) );
			voxelnum=dims4[0];
			if (!(dims4[1]==4))
			{
				mexErrMsgTxt("VoxelArray: columns of VoxelArray is not 4!");
			}
			//mxFree(dims4);
		}
	}
	if (!(mxIsNumeric(prhs[5])))
	{
		mexErrMsgTxt("IndexVector is not numeric!");
	}
	else
	{
		plength[0]=mxGetNumberOfElements(prhs[0]);
		plength[1]=mxGetNumberOfElements(prhs[1]);
		plength[2]=mxGetNumberOfElements(prhs[2]);
		ivlength=mxGetNumberOfElements(prhs[5]);
		if ( !(plength[0]==plength[1] && plength[0]==plength[2] && plength[1]==plength[2]) )
		{
			mexErrMsgTxt("the lengths of x, y, z are not consistent!");
		}
		else if ( !(ivlength==plength[0]) )
		{
			mexErrMsgTxt("the length of IndexVector is not consistent with point number!");
		}
		
	}
	if (!(mxIsNumeric(prhs[6])))
	{
		mexErrMsgTxt("zflag is not numeric!");
	}
	else if ( mxGetNumberOfElements(prhs[6]) != 1)
	{
		mexErrMsgTxt("zflag is not scalar!");
	}
	if (!(mxIsNumeric(prhs[7])))
	{
		mexErrMsgTxt("maxstemlength is not numeric!");
	}
	else if ( mxGetNumberOfElements(prhs[7]) != 1)
	{
		mexErrMsgTxt("maxstemlength is not scalar!");
	}
	if (!(mxIsNumeric(prhs[8])))
	{
		mexErrMsgTxt("DEM is not numeric!");
	}
	else
	{
		ndim4=mxGetNumberOfDimensions(prhs[8]);
		if (ndim4!=2)
		{
			mexErrMsgTxt("DEM is not a 2D matrix!");
		}
		demrow=mxGetM(prhs[8]);
		demcol=mxGetN(prhs[8]);
	}
	if (!(mxIsNumeric(prhs[9])))
	{
		mexErrMsgTxt("DEMInfo is not numeric!");
	}
	else
	{
		if (mxGetNumberOfElements(prhs[9])!=6)
		{
			mexErrMsgTxt("DEMInfo is not a vector of 6 elements!");
		}
	}
	if (!(mxIsChar(prhs[10])))
	{
		mexErrMsgTxt("StemPtsFile name is not a string!");
	}
	if (nrhs>11)
	{
		if (!(mxIsChar(prhs[11])))
		{
			mexErrMsgTxt("NonStemPtsFile name is not a string!");
		}

	}

	double *x, *y, *z;
	double *p2rInfo;
	double minx, miny, minz;
	double maxx, maxy, maxz;
	double cellx, celly, cellz;
	double *VoxelArray;
	double *voxelarray_yrow, *voxelarray_xcol, *voxelarray_zvertica, *voxelarray_pnum;
	double *indexvector;
	double zflag, maxstemlength;
	double *prdem;
	vector<double> dem( demrow*demcol );
	vector<unsigned int> dim_dem(2);
	double *ptrdeminfo;
	vector<double> deminfo(6);
	char *stemptsfile, *nonstemptsfile=NULL;

	x=mxGetPr(prhs[0]);
	y=mxGetPr(prhs[1]);
	z=mxGetPr(prhs[2]);
	p2rInfo=mxGetPr(prhs[3]);
	minx=p2rInfo[0]; maxx=p2rInfo[1]; cellx=p2rInfo[2];
	miny=p2rInfo[3]; maxy=p2rInfo[4]; celly=p2rInfo[5];
	minz=p2rInfo[6]; maxz=p2rInfo[7]; cellz=p2rInfo[8];
	VoxelArray=mxGetPr(prhs[4]);
	voxelarray_yrow=VoxelArray;
	voxelarray_xcol=VoxelArray + voxelnum;
	voxelarray_zvertica=VoxelArray + 2*voxelnum;
	voxelarray_pnum=VoxelArray + 3*voxelnum;
	indexvector=mxGetPr(prhs[5]);
	zflag=mxGetScalar(prhs[6]);
	maxstemlength=mxGetScalar(prhs[7]);
	prdem=mxGetPr(prhs[8]);
	dim_dem[0]=demrow; dim_dem[1]=demcol;
	for (size_t i=0; i<demrow*demcol; i++)
	{
		dem[i]=prdem[i];
	}
	ptrdeminfo=mxGetPr(prhs[9]);
	for (int i=0; i<6; i++)
	{
		deminfo[i]=ptrdeminfo[i];
	}
	stemptsfile=mxArrayToString(prhs[10]);

	if (nrhs>11)
	{
		nonstemptsfile=mxArrayToString(prhs[11]);
	}

	if ( !( CppStemExtraction(x, y, z, 
					   minx, miny, minz, 
					   maxx, maxy, maxz, 
					   cellx, celly, cellz, 
					   voxelarray_yrow, voxelarray_xcol, voxelarray_zvertica, voxelarray_pnum, 
					   indexvector, zflag, maxstemlength, dem, dim_dem, deminfo, 
					   stemptsfile, nonstemptsfile, 
					   ivlength, voxelnum) ) 
		)
	{
		mxFree(stemptsfile);
		mexErrMsgTxt("CppStemExtraction failed!");
	}

	mxFree(stemptsfile);
	if (nrhs>11)
	{
		mxFree(nonstemptsfile);
	}

}
