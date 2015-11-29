% Process an ascii file of single-scan point cloud to get potential trunk
% centers at the breast height, output the trunk center for manual matching and
% registration and/or try automatic matching and registration.
% 
% This script is a summary script that runs the following four (up to the output
% of trunk centers) or five (up to the automatic matching and registration of
% detected trunk centers) scripts in sequence.
% 
% Script1_CvtPtsFmt.m: convert whatever ascii file format to a simple
% tab-delimiter xyz ascii file format that is used by the following scripts in
% sequence. You want to CHANGE this script to fit your own ascii file format.
%
% Script2_FilteringVarTIN.m: filter point cloud to get ground points with a
% multi-scale TIN method. See Huang et. al. PERS 2011 for reference. 
% 
% Script3_Points2DEM.m: create a DEM from ground points by a combination of TIN
% generation and RANSAC plane fitting, and write the DEM to an ascii file that
% can be directly imported into ArcGIS for visualization. The RANSAC processing
% is to fix the gap area in a single scan where no ground points have been
% obtained by the scanner. Those areas though may have many trunks as potential
% tie targets as they are highly like to locate in overlapping areas between two
% scans.
% 
% Script4_TrkCtrSingleScanLayer.m: extract trunk centers from a point cloud
% layer above ground (given by DEM) from a single scan by (1) separating
% individual stems with clustering and (2) estimating trunk center xyz with
% circle fitting or simple average of point coordinates.
% 
% Script5_AutoMatchTrkCtr.m (optional step): automatic match extracted trunk
% centers and calculate a transfomration matrix. This step now could be very
% unstable and not able to give a robust matching result due to many
% noisy/sprurious trunk centers. It might be easier to just manually match
% extracted trunk centers.
% 
% Zhan Li, zhanli86@bu.edu
% Sun May 31 16:22:58 EDT 2015
%

% setup for the script files
script1 = 'Script1_CvtPtsFmt.m';
script2 = 'Script2_FilteringVarTIN.m';
script3 = 'Script3_Points2DEM.m';
script4 = 'Script4_TrkCtrSingleScanLayer.m';

% inputs and arameters to be set for the sequence of four/five scripts.
% input point cloud file of single scan, full file name
% ScanPtsFile = '/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140503/spectral-points-by-union/HFHD20140503-dual-points-clustering/merging/HFHD_20140503_C_dual_cube_bsfix_pxc_update_atp2_ptcl_points_kmeans_canupo_class.txt';
% a temporary folder to store all intermediate files, no trailing path seperator.
% TmpDir = '/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140503/spectral-points-by-union/HFHD20140503-dual-points-clustering/merging/tmpdir-single-scan-trkctr';

% parameters for Script2, filtering non-ground points and output
% ground points. 
RefineGround = true;

% parameters for Script3, generating TIN from ground points
% resolution of DEM, unit: same with input points
cellsize = 0.2;
% the value of no data
nodata = -9999; 
% the maximum length of boundary edges of TIN, unit: same with input points
maxTINedgelen = 10; 
% Whether to fill the nodata area in the DEM from TIN with RANSAC fitting.
fill_nodata = true;
% whether to calculate extent of points rather than using the
% extent from the last step, Script2
cal_extent = false;

% parameters for Script4, extracting trunk centers from a point cloud layer
% above the ground given by the DEM.
% for extracting the layer of points
range = 50;
height_clear = 1.4;
% for circle fitting with Hough transform
cellsize = 0.05;
maxR = 30;
sigmacoef = 1;
epsion = 0.01;
maxIter = 200;
minnumfit = 9;

% run script1
fprintf('\nRunning %s ...\n\n', script1);
[ScanPtsPathName, ScanPtsFileName, ext] = fileparts(ScanPtsFile);
InPtsPathName = TmpDir;
InPtsFileName = [ScanPtsFileName, '_xyz.txt'];
ScanPtsFileName = [ScanPtsFileName, ext];
run(script1);

% run script2
fprintf('\nRunning %s ...\n\n', script2);
GroundPtsPathName = InPtsPathName;
GroundPtsFileName = [InPtsFileName(1:end-4), '_ground.txt'];
run(script2);

% run script3
fprintf('\nRunning %s ...\n\n', script3);
demfilename = fullfile(GroundPtsPathName, [GroundPtsFileName(1:end-4), '.dem']);
run(script3);

% run script4
fprintf('\nRunning %s ...\n\n', script4);
ptsfilename = fullfile(InPtsPathName, InPtsFileName);
fpfilename = fullfile(TmpDir, [InPtsFileName(1:end-4), '.fp']);
run(script4);