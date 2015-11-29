% Script5_ManualMatchTrkCtr.m
% Generate point pairs for transformation matrix
% calculation from the labels of manually identified pairs of trunk centers, and
% calculate transformation matrix.
% 
% Zhan Li, zhanli86@bu.edu
% 20150601
%
% files to input:
% DataStemBasePathName, DataStemBaseFileName: the file of feature points for DATA: 
%   File format:
%   #1: 'x, y, z, FeaturePointNO, radius, reliability'
%   #2-#end: x, y, z, FeaturePointNO, radius, reliability
% ModelStemBasePathName, ModelStemBaseFileName: the file of feature points for MODEL: 
%   File format:
%   #1: 'x, y, z, FeaturePointNO, radius, reliability'
%   #2-#end: x, y, z, FeaturePointNO, radius, reliability
% TieStemBasePairLabelFile: the file giving the labels of manually matched trunk centers.
%   File format:
%   #1: 'FeaturePointNo, ModelPointNo'
%   #2-#end: FeaturePointNo, ModelPointNo

% input files
datafpfile = '/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140503/spectral-points-by-union/HFHD20140503-dual-points-clustering/merging/tmpdir-single-scan-trkctr/HFHD_20140503_E_dual_cube_bsfix_pxc_update_atp2_ptcl_points_kmeans_canupo_class_xyz.fp';
modelfpfile = '/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140503/spectral-points-by-union/HFHD20140503-dual-points-clustering/merging/tmpdir-single-scan-trkctr/HFHD_20140503_C_dual_cube_bsfix_pxc_update_atp2_ptcl_points_kmeans_canupo_class_xyz.fp';
manualmatchedlabelfile = '/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140503/spectral-points-by-union/HFHD20140503-dual-points-clustering/merging/tmpdir-single-scan-trkctr/manual_match_label_hfhd20140503_e2c.txt';
% output files
matchedfpfile = '/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140503/spectral-points-by-union/HFHD20140503-dual-points-clustering/merging/tmpdir-single-scan-trkctr/manual_match_trkctr_hfhd20140503_e2c.txt';
tmfile = '/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140503/spectral-points-by-union/HFHD20140503-dual-points-clustering/merging/tmpdir-single-scan-trkctr/manual_match_trkctr_tm_hfhd20140503_e2c.txt';
% parameters for the processing if we will use z coordinates of matched trunk
% centers in the calculation of transformation matrix.
usez = true;

% read trunk centers
fid = fopen(datafpfile, 'r');
data = textscan(fid, '%f %f %f %f %f %f', 'HeaderLines', 1, ...
                'Delimiter', ',');
datax = data{1};
datay = data{2};
dataz = data{3};
datatreeno = data{4};
datareliability = data{6};
fclose(fid);

fid = fopen(modelfpfile, 'r');
data = textscan(fid, '%f %f %f %f %f %f', 'HeaderLines', 1, ...
                'Delimiter', ',');
modelx = data{1};
modely = data{2};
modelz = data{3};
modeltreeno = data{4};
modelreliability = data{6};
fclose(fid);

% read manually matched trunk center labels
fid = fopen(manualmatchedlabelfile, 'r');
data = textscan(fid, '%f %f', 'HeaderLines', 1, ...
                'Delimiter', ',');
datalabelno = data{1};
modellabelno = data{2};

nmatched = length(datalabelno);
matchedtiepoints = zeros(nmatched, 10);
for n=1:nmatched
    fd = datatreeno == datalabelno(n);
    fm = modeltreeno == modellabelno(n);
    matchedtiepoints(n, :) = [datax(fd), datay(fd), dataz(fd), datatreeno(fd), modelx(fm), modely(fm), modelz(fm), modeltreeno(fm), 1, 0];
end

dlmwrite(matchedfpfile, matchedtiepoints, 'delimiter', '\t', 'precision', 6, 'newline', 'pc');

[TieStemBasePathName, TieStemBaseFileName, ext] = fileparts(matchedfpfile);
TieStemBaseFileName = [TieStemBaseFileName, ext];
[TMPathName, TMFileName, ext] = fileparts(tmfile);
TMFileName = [TMFileName, ext];
Fcn_RegExplicitlyMatchedPoints( ...
    TieStemBasePathName, TieStemBaseFileName, ...
    TMPathName, TMFileName, usez);
