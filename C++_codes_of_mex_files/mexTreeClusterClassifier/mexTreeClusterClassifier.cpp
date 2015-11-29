#define DEBUG

#include <vector>
#include <algorithm>
#include <cmath>
#include <fstream>

#include "mex.h"
#include "matrix.h"

#include "MatrixLZ.h"
#include "kdtree_common.h"
#include "kdtree_common.cc"

using namespace std;

bool CppRasterize2d(vector<double> x, vector<double> y, 
					double cellx, double celly, 
					vector<unsigned int> &dim_img, vector<int> &IndexVector, 
					vector<unsigned int> &img_np)
					//vector<double> &xcol, vector<double> &yrow, vector<unsigned int> &cell_np)
{
	if (x.size()!=y.size())
	{
		return false;
	}

	double minx, miny, maxx, maxy;
	minx=*(min_element(x.begin(), x.end()));
	maxx=*(max_element(x.begin(), x.end()));
	miny=*(min_element(y.begin(), y.end()));
	maxy=*(max_element(y.begin(), y.end()));

	dim_img.assign(2,0);
	dim_img[0]=static_cast<unsigned int>(floor((maxy-miny)/celly))+1;
	dim_img[1]=static_cast<unsigned int>(floor((maxx-minx)/cellx))+1;

	unsigned int xpixel, ypixel;
	IndexVector.assign(x.size(), -1);
	img_np.assign(dim_img[0]*dim_img[1], 0);
	for (unsigned int i=0; i<x.size(); i++)
	{
		xpixel=static_cast<unsigned int>(floor((x[i]-minx)/cellx));
		ypixel=static_cast<unsigned int>(floor((y[i]-miny)/celly));
		IndexVector[i] = static_cast<int>( MatrixLZ::sub2ind(ypixel, xpixel, dim_img[0], dim_img[1], MatrixLZ::ColMajor) );
		img_np[ IndexVector[i] ] += 1;
	}

	//unsigned int **image;
	//image=new unsigned int*[dim_img[0]];
	//for (unsigned int i=0; i<dim_img[0]; i++)
	//{
	//	image[i]=new unsigned int[dim_img[1]];
	//	for (unsigned int j=0; j<dim_img[1]; j++)
	//	{
	//		image[i][j]=0;
	//	}
	//}

	//unsigned int xpixel, ypixel;
	//IndexVector.assign(x.size(), -1);
	//for (unsigned int i=0; i<x.size(); i++)
	//{
	//	xpixel=static_cast<unsigned int>(floor((x[i]-minx)/cellx));
	//	ypixel=static_cast<unsigned int>(floor((y[i]-miny)/celly));
	//	image[ypixel][xpixel] += 1;
	//	IndexVector[i] = static_cast<int>( MatrixLZ::sub2ind(ypixel, xpixel, dim_img[0], dim_img[1], MatrixLZ::ColMajor) );
	//}
	//xcol.assign(dim_img[0]*dim_img[1], -1);
	//yrow.assign(dim_img[0]*dim_img[1], -1);
	//cell_np.assign(dim_img[0]*dim_img[1], 0);
	//int nonzerocount=0;
	//for (unsigned int i=0; i<dim_img[0]; i++)
	//{
	//	for (unsigned int j=0; j<dim_img[1]; j++)
	//	{
	//		if (image[i][j]>0)
	//		{
	//			xcol[nonzerocount]=static_cast<double>(i);
	//			yrow[nonzerocount]=static_cast<double>(j);
	//			cell_np[nonzerocount]=image[i][j];
	//			nonzerocount++;
	//		}
	//	}
	//}
	//xcol.erase(xcol.begin()+nonzerocount, xcol.end());
	//yrow.erase(yrow.begin()+nonzerocount, yrow.end());
	//cell_np.erase(cell_np.begin()+nonzerocount, cell_np.end());

	//for (unsigned int i=0; i<dim_img[0]; i++)
	//{
	//	delete [] image[i];
	//}
	//delete [] image;

	return true;
}

Tree *CTCC_buildkdtree(double *reference, unsigned int npoints)
{
	//double *reference;
	//reference=new double[xcol.size()*2];
	//for (unsigned int i=0; i<xcol.size(); i++)
	//{
	//	reference[i]=xcol[i];
	//	reference[i+xcol.size()]=yrow[i];
	//}
	int *index;
	index=new int[npoints];
	for (unsigned int i=0; i<npoints; i++)
	{
		index[i]=i;
	}
	Tree *kdtree;
	if ( (kdtree = build_kdtree(reference,npoints,2,index,npoints,0))==NULL )
	{
		delete [] index;
#ifdef DEBUG
		mexPrintf("CTCC_buildkdtree ==> Not enough free memory to build k-D tree\n");
#endif
		return NULL;
	} 
	else 
	{
		kdtree->dims = 2;
		delete [] index;
		return kdtree;
	}

}

bool CppTreeClusterClassifier(vector<double> x, vector<double> y, vector<double> z, 
							  double cellsize, double CutoffDis, unsigned int minpoints, 
							  char *TtableFileName, char *arrTFileName)
{
	vector<unsigned int> dim_img;
	vector<int> IndexVector;
	//vector<double> xcol, yrow;
	//vector<unsigned int> cell_np;
	vector<unsigned int> img_np;

	if ( !( 
		CppRasterize2d(x, y, cellsize, cellsize, dim_img, IndexVector, img_np)
		//CppRasterize2d(x, y, cellsize, cellsize, dim_img, IndexVector, xcol, yrow, cell_np)
		))
	{
#ifdef DEBUG
		mexPrintf("CppTreeClusterClassifier ==> CppRasterize2d failed!\n");
#endif
		return false;
	}

//	double *reference, *model;
//	reference=new double[xcol.size()*2];
//	for (unsigned int i=0; i<xcol.size(); i++)
//	{
//		reference[i]=xcol[i];
//		reference[i+xcol.size()]=yrow[i];
//	}
//	int *index;
//	index=new int[xcol.size()];
//	for (unsigned int i=0; i<xcol.size(); i++)
//	{
//		index[i]=i;
//	}
//	Tree *kdtree;
//	if ( (kdtree = build_kdtree(reference,xcol.size(),2,index,xcol.size(),0))==NULL )
//	{
//		delete [] index;
//#ifdef DEBUG
//		mexPrintf("CppTreeClusterClassifier ==> Not enough free memory to build k-D tree\n");
//#endif
//		return false;
//	} 
//	else 
//	{
//		kdtree->dims = 2;
//		delete [] index;
//	}

	//vector<unsigned int> cell_treeid(xcol.size(), 0);
	
	vector<double> treetable_x, treetable_y; 
	vector<unsigned int> treetable_npoints;
	vector<unsigned int> img_treeid(img_np.size(), 0);	// based from 1. 
	unsigned int ntrees=0;
	//treetable_x.push_back(xcol[0]);
	//treetable_y.push_back(yrow[0]);
	//treetable_npoints.push_back(1);	// now, treetable_npoints records the number of cells within a tree. 
	//treetable_id.push_back(ntrees);
	//cell_treeid[0]=ntrees;
	//bool treeadd=true;
	Tree *kdtree;
	double *reference; reference= new double[1];
	double modelpoint[2], dist=0.0, closesttree=0.0;
	unsigned int tempindex;

	// in the following for loop, treetable_npoints records the number of cells within a tree. 
	for (unsigned int i=0; i<img_np.size(); i++)
	{
		if (img_np[i]==0)
		{
			continue;
		}

		// the x(column) and y(row) of current point.
		modelpoint[0]=MatrixLZ::ind2subcol(i, dim_img[0], dim_img[1], MatrixLZ::ColMajor);	// x, column
		modelpoint[1]=MatrixLZ::ind2subrow(i, dim_img[0], dim_img[1], MatrixLZ::ColMajor);	// y, row

		if (treetable_x.size()==0)	// no tree, then create the first tree.
		{
			ntrees++;
			img_treeid[i] = ntrees;
			treetable_x.push_back( modelpoint[0] );
			treetable_y.push_back( modelpoint[1] );
			treetable_npoints.push_back(1);
			continue;
		}
		else
		{
			delete [] reference;
			reference=new double[treetable_x.size()*2];
			for (unsigned int itree=0; itree<treetable_x.size(); itree++)
			{
				reference[itree]=treetable_x[itree];
				reference[itree+treetable_x.size()]=treetable_y[itree];
			}
			if ( (kdtree=CTCC_buildkdtree(reference, treetable_x.size()))==NULL )
			{
#ifdef DEBUG
				mexPrintf("CppTreeClusterClassifier ==> CTCC_buildkdtree failed!\n");
#endif
				delete [] reference;
				free_tree(kdtree->rootptr);
				free(kdtree);
				return false;
			}
			run_queries(kdtree->rootptr,modelpoint,1,kdtree->dims,&closesttree,&dist, RETURN_INDEX);

			if (dist>CutoffDis/cellsize)	// add a new tree
			{
				ntrees++;
				img_treeid[i] = ntrees;
				treetable_x.push_back( modelpoint[0] );
				treetable_y.push_back( modelpoint[1] );
				treetable_npoints.push_back(1);
			}
			else
			{
				tempindex=static_cast<unsigned int>(closesttree);
				img_treeid[i] = tempindex+1;
				treetable_x[tempindex] = treetable_x[tempindex]*treetable_npoints[tempindex] + modelpoint[0];
				treetable_y[tempindex] = treetable_y[tempindex]*treetable_npoints[tempindex] + modelpoint[1];
				treetable_npoints[tempindex] += 1;
				treetable_x[tempindex] /= treetable_npoints[tempindex];
				treetable_y[tempindex] /= treetable_npoints[tempindex];
			}

			// !!!Important: free the kdtree in each loop, because new kdtree will be built in each loop!!!
			free_tree(kdtree->rootptr);
			free(kdtree);
		}
	}
	delete [] reference;

	//free_tree(kdtree->rootptr);
	//free(kdtree);

	// calculate the number of points in each tree and record it with treetable_npoints.
	treetable_npoints.assign(treetable_npoints.size(), 0);
	for (unsigned int i=0; i<img_np.size(); i++)
	{
		if (img_np[i]!=0)
		{
			treetable_npoints[ img_treeid[i]-1 ] += img_np[i];
		}
	}

	double minx, miny;
	minx=*(min_element(x.begin(), x.end()));
	miny=*(min_element(y.begin(), y.end()));
	// output trees information.
	ofstream Ttablefstream;
	Ttablefstream.open(TtableFileName, ios_base::out);
	Ttablefstream.precision(6);
	Ttablefstream<<fixed;
	if (!Ttablefstream)
	{
#ifdef DEBUG
		mexPrintf("CppTreeClusterClassifier ==> TtableFileName opened failed!\n");
#endif
		//free_tree(kdtree->rootptr);
		//free(kdtree);
		return false;
	}
	for (unsigned int i=0; i<treetable_x.size(); i++)
	{
		if (treetable_npoints[i]>=minpoints)
		{
			Ttablefstream<<treetable_x[i]*cellsize+minx<<"\t"<<treetable_y[i]*cellsize+miny<<"\t"<<treetable_npoints[i]<<"\t"<<i+1<<endl;
		}
	}
	Ttablefstream.close();

	// mark the points with corresponding tree ID. if the number of point within corresponding tree is less than minpoints, then mark this tree with -1. 
	ofstream arrTfstream;
	arrTfstream.open(arrTFileName, ios_base::out);
	arrTfstream.precision(6);
	arrTfstream<<fixed;
	for (unsigned int pcount=0; pcount<x.size(); pcount++)
	{
		//tempindex= static_cast<unsigned int>( IndexVector[pcount] );
		tempindex = img_treeid[ IndexVector[pcount] ] - 1;
		if ( treetable_npoints[ tempindex ] < minpoints )
		{
			//arrTfstream<<x[pcount]<<"\t"<<y[pcount]<<"\t"<<z[pcount]<<"\t"<< -1 <<endl;
			continue;
		}
		else
		{
			arrTfstream<<x[pcount]<<"\t"<<y[pcount]<<"\t"<<z[pcount]<<"\t"<< tempindex+1 <<endl;
		}
	}
	arrTfstream.close();

	//free_tree(kdtree->rootptr);
	//free(kdtree);

	return true;

//	for (unsigned int i=1; i<img_np.size(); i++)
//	{
//		//if (treeadd)	// create kdtree used to find the closest tree from the current point.
//		{
//			delete [] reference;
//			reference=new double[treetable_id.size()*2];
//			for (unsigned int itree=0; itree<treetable_id.size(); itree++)
//			{
//				reference[itree]=treetable_x[itree];
//				reference[itree+treetable_id.size()]=treetable_y[itree];
//			}
//			if ( (kdtree=CTCC_buildkdtree(reference, treetable_id.size()))==NULL )
//			{
//#ifdef DEBUG
//				mexPrintf("CppTreeClusterClassifier ==> CTCC_buildkdtree failed!\n");
//#endif
//				delete [] reference;
//				return false;
//			}
//		}
//
//		modelpoint[0]=xcol[i];
//		modelpoint[1]=yrow[i];
//		run_queries(kdtree->rootptr,modelpoint,1,kdtree->dims,&closesttree,&dist, RETURN_INDEX);
//		if (dist>CutoffDis/cellsize)	// add a new tree
//		{
//			ntrees++;
//			treetable_x.push_back(xcol[i]);
//			treetable_y.push_back(yrow[i]);
//			treetable_npoints.push_back(cell_np[i]);
//			treetable_id.push_back(ntrees);
//			cell_treeid[i]=ntrees;
//		}
//		else
//		{
//			tempindex=static_cast<unsigned int>(closesttree);
//			cell_treeid[i]=treetable_id[ tempindex ];
//			treetable_x[tempindex] = treetable_x[tempindex]*treetable_npoints[tempindex] + xcol[i];
//			treetable_y[tempindex] = treetable_y[tempindex]*treetable_npoints[tempindex] + yrow[i];
//			treetable_npoints[tempindex] = treetable_npoints[tempindex] + 1;
//			treetable_x[tempindex] /= treetable_npoints[tempindex];
//			treetable_y[tempindex] /= treetable_npoints[tempindex];
//
//		}		
//	}

	// calculate the number of points in each tree and record it with treetable_npoints.
	//treetable_npoints.assign(treetable_npoints.size(), 0);
	//for (unsigned int i=0; i<xcol.size(); i++)
	//{
	//	treetable_npoints[ cell_treeid[i] ] += cell_np[i];
	//}

}

// mexTreeClusterClassifier: sperate trees in a stem points file by cluster. 
// SYNTAX: mexTreeClusterClassifier (x, y, z, cellsize, CutoffDis, minpoints, TtableFileName, arrTFileName)
// INPUT:
//		x, y, z: column-vector, coordinates of points.
//		cellsize: scalar, the cell size used to rasterize the x-y plane. 
//		CutoffDis: scalar, the maximum distance between cells within the same tree. 
//		minpoints: scalar, the minimum number of points in a single tree. 
//		TtableFileName: string, the complete name of file containing tree NOs and corresponding center coordinates. 
//			File format: 
//			#1-#end: x_of_tree_center \t  y_of_tree_center \t z_of_tree_center \t number_of_points_in_this_tree \t NO_of_tree
//		arrTFileName: string, the complete name of file containing the points and corresponding tree NO. 
//			File format:
//			#1-#end: x \t y \t z \t NO_of_tree
// OUTPUT:
//		None. 
// REQUIRED ROUTINES:
//		
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
	// check the number of input and output arguments.
	if (nrhs != 8)
	{
		mexErrMsgTxt("8 input arguments are required!");
	}
	if (nlhs > 0)
	{
		mexErrMsgTxt("No output arguments!");
	}
	
	// check the type of input arguments.
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
		mexErrMsgTxt("cellsize is not numeric!");
	}
	else if (mxGetNumberOfElements(prhs[3]) != 1)
	{
		mexErrMsgTxt("cellsize is not scalar!");
	}
	if (!(mxIsNumeric(prhs[4])))
	{
		mexErrMsgTxt("CutoffDis is not numeric!");
	}
	else if (mxGetNumberOfElements(prhs[4]) != 1)
	{
		mexErrMsgTxt("CutoffDis is not scalar!");
	}
	if (!(mxIsNumeric(prhs[5])))
	{
		mexErrMsgTxt("minpoints is not numeric!");
	}
	else if (mxGetNumberOfElements(prhs[5]) != 1)
	{
		mexErrMsgTxt("minpoints is not scalar!");
	}
	if (!(mxIsChar(prhs[6])))
	{
		mexErrMsgTxt("TtableFileName is not a string!");
	}
	if (!(mxIsChar(prhs[7])))
	{
		mexErrMsgTxt("arrTFileName is not a string!");
	}

	unsigned int npoints;
	npoints = mxGetNumberOfElements(prhs[0]);
	if (npoints != mxGetNumberOfElements(prhs[1]) || npoints != mxGetNumberOfElements(prhs[2]) || mxGetNumberOfElements(prhs[1]) != mxGetNumberOfElements(prhs[2]) )
	{
		mexErrMsgTxt("x, y and z does not have the same length!");
	}

	vector<double> x(npoints), y(npoints), z(npoints);
	double cellsize, CutoffDis;
	unsigned int minpoints;
	char *TtableFileName, *arrTFileName;

	double *ptr_x, *ptr_y, *ptr_z;
	ptr_x=mxGetPr(prhs[0]);
	ptr_y=mxGetPr(prhs[1]);
	ptr_z=mxGetPr(prhs[2]);
	for (unsigned int i=0; i<npoints; i++)
	{
		x[i]=ptr_x[i];
		y[i]=ptr_y[i];
		z[i]=ptr_z[i];
	}
	cellsize=mxGetScalar(prhs[3]);
	CutoffDis=mxGetScalar(prhs[4]);
	minpoints=static_cast<unsigned int>( mxGetScalar(prhs[5]) );
	TtableFileName=mxArrayToString(prhs[6]);
	arrTFileName=mxArrayToString(prhs[7]);

	if ( !( CppTreeClusterClassifier(
		x, y, z, 
		cellsize, CutoffDis, minpoints, 
		TtableFileName, arrTFileName))
		)
	{
		mxFree(TtableFileName);
		mxFree(arrTFileName);
		mexErrMsgTxt("C++ style function: CppTreeClusterClassifier failed!");
	}

	mxFree(TtableFileName);
	mxFree(arrTFileName);
}
