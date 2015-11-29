% Script5_AutoMatchTrkCtr.m
% Automatically match trunk centers (or some other feature points
% extracted from point clouds) from two scans. If not enough pairs
% of feature points are found by this automatic matching algorithm,
% it prompts the user to do the matching of trunk centers (feature
% points) manually. 
% Zhan Li, zhanli86@bu.edu
% 2014-5-28
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
% files to output: 
% TieStemBasePathName, TieStemBaseFileName:the output file for matched feature points
%   File format:
%   #1-#end: x y z FeaturePointNO x y z ModelPointNO
%   count_of_matched_distances mean_of_distance_difference
% parameters to input
% DisThreshold: the initial threshold used to determine whether two distances are the same (meter): 
% MaxLoopCount: the maximum count for iteration: 

% clear;
datafpfile = '/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140503/spectral-points-by-union/HFHD20140503-dual-points-clustering/merging/tmpdir-single-scan-trkctr/HFHD_20140503_W_dual_cube_bsfix_pxc_update_atp2_ptcl_points_kmeans_canupo_class_xyz.fp';
modelfpfile = '/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140503/spectral-points-by-union/HFHD20140503-dual-points-clustering/merging/tmpdir-single-scan-trkctr/HFHD_20140503_C_dual_cube_bsfix_pxc_update_atp2_ptcl_points_kmeans_canupo_class_xyz.fp';
% output files
matchedfpfile = '/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140503/spectral-points-by-union/HFHD20140503-dual-points-clustering/merging/tmpdir-single-scan-trkctr/auto_match_trkctr_hfhd20140503_w2c.txt';
tmfile = '/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140503/spectral-points-by-union/HFHD20140503-dual-points-clustering/merging/tmpdir-single-scan-trkctr/auto_match_trkctr_tm_hfhd20140503_w2c.txt';
% parameters for the processing if we will use z coordinates of matched trunk
% centers in the calculation of transformation matrix.
usez = true;
disthreshold = 0.2;
maxiter = 100;


[datafppathname, datafpfilename, ext] = fileparts(datafpfile);
datafpfilename = [datafpfilename, ext];
[modelfppathname, modelfpfilename, ext] = fileparts(modelfpfile);
modelfpfilename = [modelfpfilename, ext];
[matchedfppathname, matchedfpfilename, ext] = fileparts(matchedfpfile);
matchedfpfilename = [matchedfpfilename, ext];

% read trunk centers
fid = fopen(fullfile(datafppathname, datafpfilename), 'r');
data = textscan(fid, '%f %f %f %f %f %f', 'HeaderLines', 1, ...
                'Delimiter', ',');
datax = data{1};
datay = data{2};
dataz = data{3};
datatreeno = data{4};
datareliability = data{6};
fclose(fid);
fid = fopen(fullfile(modelfppathname, modelfpfilename), 'r');
data = textscan(fid, '%f %f %f %f %f %f', 'HeaderLines', 1, ...
                'Delimiter', ',');
modelx = data{1};
modely = data{2};
modelz = data{3};
modeltreeno = data{4};
modelreliability = data{6};
fclose(fid);

tmpdatafile = fullfile(datafppathname, ['tmp-', datafpfilename, '-', ...
                   modelfpfilename]);
tmpmodelfile = fullfile(modelfppathname, ['tmp-', modelfpfilename, ...
                    '-', datafpfilename]);

% if there are more than 4 feature points with reliability = 1
% (from circle fitting)
selectflag = datareliability==1;
if sum(selectflag) >= 4 
    % use only reliability=1 feature points
    fid = fopen(tmpdatafile, 'w');
    fprintf(fid, 'x, y, z, FeaturePointNO\n');
    fprintf(fid, '%f, %f, %f, %d\n', ([datax(selectflag), datay(selectflag), ...
                   dataz(selectflag), datatreeno(selectflag)])');
    fclose(fid);
    dataall = 0;
else
    % use all feature points
    warning(['less than 4 trunk centers with reliability=1 in Data set, use all ' ...
             'feature points in the automatic matching.']);
    fid = fopen(tmpdatafile, 'w');
    fprintf(fid, 'x, y, z, FeaturePointNO\n');
    fprintf(fid, '%f, %f, %f, %d\n', ([datax, datay, dataz, datatreeno])');
    fclose(fid);
    dataall = 1;
end
selectflag = modelreliability==1;
if sum(selectflag) >= 4 
    % use only reliability=1 feature points
    fid = fopen(tmpmodelfile, 'w');
    fprintf(fid, 'x, y, z, FeaturePointNO\n');
    fprintf(fid, '%f, %f, %f, %d\n', ([modelx(selectflag), modely(selectflag), ...
                   modelz(selectflag), modeltreeno(selectflag)])');
    fclose(fid);
    modelall = 0;
else
    % use all feature points
    warning(['less than 4 trunk centers with reliability=1 in Model set, use all ' ...
             'feature points in the automatic matching.']);
    fid = fopen(tmpmodelfile, 'w');
    fprintf(fid, 'x, y, z, FeaturePointNO\n');
    fprintf(fid, '%f, %f, %f, %d\n', ([modelx, modely, modelz, modeltreeno])');
    fclose(fid);
    modelall = 1;
end

[Result, MatchedStemBase, DataDistMatrix, ModelDistMatrix, DisThreshold]= ...
    Fcn_MatchFeaturePoints(datafppathname, ['tmp-', datafpfilename, '-', modelfpfilename], ...
    modelfppathname, ['tmp-', modelfpfilename, '-', datafpfilename], ...
    disthreshold, maxiter, ...
    matchedfppathname, matchedfpfilename, false);

MatchedFlag = false;
% if less than 2 pairs of matched feature points are found
if size(Result, 1) < 2
    if ~(dataall & modelall)
        warning(['No enough pairs (<2) of matched have been found. ' ...
                 'Using all feature points in BOTH Data and Model ' ...
                 'now.']);
        if ~dataall
            % use all feature points
            warning(['Data: use all ' ...
                     'feature points in the automatic matching.']);
            fid = fopen(tmpdatafile, 'w');
            fprintf(fid, 'x, y, z, FeaturePointNO\n');
            fprintf(fid, '%f, %f, %f, %d\n', ([datax, datay, dataz, datatreeno])');
            fclose(fid);
            dataall = 1;
        end
        if ~modelall
            % use all feature points
            warning(['Model: use all ' ...
                     'feature points in the automatic matching.']);
            fid = fopen(tmpmodelfile, 'w');
            fprintf(fid, 'x, y, z, FeaturePointNO\n');
            fprintf(fid, '%f, %f, %f, %d\n', ([modelx, modely, modelz, modeltreeno])');
            fclose(fid);
            modelall = 1;
        end
        [Result, MatchedStemBase, DataDistMatrix, ModelDistMatrix, DisThreshold]= ...
            Fcn_MatchFeaturePoints(datafppathname, ['tmp-', datafpfilename, '-', modelfpfilename], ...
            modelfppathname, ['tmp-', modelfpfilename, '-', datafpfilename], ...
            disthreshold, maxiter, ...
            matchedfppathname, matchedfpfilename, false);
        if size(Result, 1) < 2
            % already use all feature points in both Data and Model
            fprintf(['Used all feature points in both Data and Model ' ...
                     'sets.\nNo enough pairs (<2) of matched have been ' ...
                     'found.\nTry increasing DisThreshold or manually ' ...
                     'match feature points.\nData:%s\nModel:%s\n'], ...
                    datafpfilename, modelfpfilename);
        else
            fprintf(['Automatic matching algorithm found %d pairs of ' ...
                     'matched, with ALL feature points in BOTH Data ' ...
                     'and Model.\nData:%s\nModel:%s\n'], size(Result, 1), size(Result, 1), ...
                    datafpfilename, modelfpfilename);
            MatchedFlag = true;
        end
    else
        % already use all feature points in both Data and Model
        fprintf(['Used all feature points in both Data and Model ' ...
                 'sets.\nNo enough pairs (<2) of matched have been ' ...
                 'found.\nTry increasing DisThreshold or manually ' ...
                 'match feature points.\nData:%s\nModel:%s\n'], ...
                datafpfilename, modelfpfilename);
    end
else
    fprintf(['Automatic matching algorithm found %d pairs of ' ...
             'matched.\nData:%s\nModel:%s\n'], size(Result, 1), ...
            datafpfilename, modelfpfilename);
    MatchedFlag = true;
end

delete(tmpdatafile, tmpmodelfile);

if MatchedFlag
    fprintf('Calculate transformation matrix from matched points!\n');
    [TMPathName, TMFileName, ext] = fileparts(tmfile);
    TMFileName = [TMFileName, ext];
    Fcn_RegExplicitlyMatchedPoints( ...
        matchedfppathname, matchedfpfilename, ...
        TMPathName, TMFileName, usez);
end