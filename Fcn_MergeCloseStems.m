% StemBasePathName = 'E:\Research of IRSA\Lidar\Terrestrial\ProcessAnalysis\clslc101702NEW\cl101702AutoReg\';
% StemBaseFileName = 'StemBases_arrTree_cl101702cz.txt';
% ReliableStemCenterPathName = 'E:\Research of IRSA\Lidar\Terrestrial\ProcessAnalysis\clslc101702NEW\cl101702AutoReg\';
% ReliableStemCenterFileName = 'ReliableStemCenterByHP&FL_arrTree_cl101702cz - Scan001.txt';
% MergeTablePathName = 'E:\Research of IRSA\Lidar\Terrestrial\ProcessAnalysis\clslc101702NEW\cl101702AutoReg\';
% MergeTableFileName = 'TestMergeTable.txt';
% NewStemLinePathName = 'E:\Research of IRSA\Lidar\Terrestrial\ProcessAnalysis\clslc101702NEW\cl101702AutoReg\';
% NewStemLineFileName = 'TestNewStemLine.txt';
% NewStemCenterPathName = 'E:\Research of IRSA\Lidar\Terrestrial\ProcessAnalysis\clslc101702NEW\cl101702AutoReg\';
% NewStemCenterFileName = 'TestNewStemCenter.txt';
% MinStemBaseDist = 1.0;
% EpsionRMS = 0.05;
% MinNumP = 6;
function err = Fcn_MergeCloseStems(StemBasePathName, StemBaseFileName, ...
    MinStemBaseDist, EpsionRMS, MinNumP, ...
    ReliableStemCenterPathName, ReliableStemCenterFileName, ...
    MergeTablePathName, MergeTableFileName, ...
    NewStemCenterPathName, NewStemCenterFileName, ...
    NewStemLinePathName, NewStemLineFileName)
% If the distances on the xoy plane between some stem bases are too close,
% i.e. less than a given threshold, label the reliable stem centers of
% these stem bases with a same new tree ID and fit a new stem line with all
% the reliable stem centers. In addition, re-estimate a new stem base with
% this new stem line.
% 
% SYNTAX: Fcn_MergeCloseStems
% INPUT:
%   1. StemBasePathName, StemBaseFileName: Text file of stem bases. 
%       File format:
%       #1: 'x, y, z, TreeNO'
%       #2-#end: x, y, z, TreeNO
%   2. MinStemBaseDist: the minimum distance between two seperate stems.
%   3. EpsionRMS: the threshold of minimum RMS of distances to the fit stem
%       line(meter).
%   4. MinNumP: the minimum number of points to form a stem, i.e. to fit a
%       line.
%   5. Text files of reliable stem centers determined only by half plane and fitted line. (ReliableStemCenterByHP&FL_)
%       Format:
%       yc, xc, r, zc, TreeNO, number_of_points_in_circle_fitting_finally, ArcAngle(radian) 
% OUTPUT:
% REQUIRED ROUTINES:
% METHODS AND PROCESS: 

ParameterFileName=['Parameters_Fcn_MergeCloseStems_', StemBaseFileName];
fid=fopen(fullfile(StemBasePathName, ParameterFileName), 'w');
fprintf(fid, [...
    'the input stem base file: %s\r\n', ...
    'the input reliable stem center file: %s\r\n', ...
    'the output file of the table showing tree ID'' correspondence before and after the merging: %s\r\n' ...
    'the output file of the reliable stem centers with new tree ID after the merging: %s\r\n' ...
    'the output file of the new fitted stem lines after the merging: %s' ...
    ], ...
    fullfile(StemBasePathName, StemBaseFileName), ...
    fullfile(ReliableStemCenterPathName, ReliableStemCenterFileName), ...
    fullfile(MergeTablePathName, MergeTableFileName), ...
    fullfile(NewStemCenterPathName, NewStemCenterFileName), ...
    fullfile(NewStemLinePathName, NewStemLineFileName) ...
    );
fclose(fid);

StemBases = importdata(fullfile(StemBasePathName, StemBaseFileName), ',', 1);
if ~isstruct(StemBases)
    errordlg('No stem bases are found in the given file!', 'File Error');
    err = true;
    return;
end
StemBases = StemBases.data;
ReliableStemCenters = importdata(fullfile(ReliableStemCenterPathName, ReliableStemCenterFileName));

% the new number for the new tree ID will be represented with negative
% number.
stemnum = size(StemBases, 1);
stemcluster = zeros(stemnum, 5); % x, y, z, treeno, stem number of the cluster.
clusternum = 1;
stemcluster(1, 1:3) = StemBases(1, 1:3);
stemcluster(1, 4) = -1;
stemcluster(1, 5) = 1;
mergetable = zeros(stemnum, 2); % in each row: the old tree NO, the new tree NO.
mergetable(1, :) = [StemBases(1, 4), stemcluster(1, 4)];
temptreeid = ReliableStemCenters(:, 5);
tempindex = temptreeid==mergetable(1, 1);
temptreeid(tempindex) = mergetable(1, 2);
for count=2:stemnum
    [mindist, index] = FindMinDist(StemBases(count, 1:3), stemcluster(1:clusternum, 1:3));
    if mindist>MinStemBaseDist
        clusternum = clusternum + 1;
        stemcluster(clusternum, 1:3) = StemBases(count, 1:3);
        stemcluster(clusternum, 4) = -1*clusternum;
        stemcluster(clusternum, 5) = 1;
        mergetable(count, :) = [StemBases(count, 4), stemcluster(clusternum, 4)];
    else
        stemcluster(index, 1:3) = (stemcluster(index, 5)*stemcluster(index, 1:3) + StemBases(count, 1:3))/(stemcluster(index, 5)+1);
        stemcluster(index, 5) = stemcluster(index, 5) + 1;
        mergetable(count, :) = [StemBases(count, 4), stemcluster(index, 4)];
    end
    tempindex = temptreeid==mergetable(count, 1);
    temptreeid(tempindex) = mergetable(count, 2);
end
ReliableStemCenters(:, 5) = temptreeid;
tempindex = temptreeid>0;
ReliableStemCenters(tempindex, :)=[];

fid=fopen(fullfile(MergeTablePathName, MergeTableFileName), 'w');
fprintf(fid, 'old_TreeNO\tnew_TreeNO\r\n');
fprintf(fid, '%d\t%d\r\n', mergetable');
fclose(fid);

[NewStemCenters, StemLine] = FitStemLine(ReliableStemCenters, EpsionRMS, MinNumP);

fid=fopen(fullfile(NewStemCenterPathName, NewStemCenterFileName), 'w');
% [yc, xc, r, zc, TreeNO, number_of_points_in_circle_fitting_finally,
%   ArcAngle(radian)]
fprintf(fid, '%f\t%f\t%f\t%f\t%d\t%d\t%f\r\n', NewStemCenters');
fclose(fid);

fid=fopen(fullfile(NewStemLinePathName, NewStemLineFileName), 'w');
% [m, n, p, x0, y0, z0, TreeNO,
%   number_of_stem_centers_in_fitting_line_finally]
%     ([m, n, p] is direction of line, [x0, y0, z0] is coordinates of one
%     point on line)
fprintf(fid, '%f\t%f\t%f\t%f\t%f\t%f\t%d\t%d\r\n', StemLine');
fclose(fid);
err = false;
end

function [dist, index] = FindMinDist(point, pset)
% find the minimum distance between point and each point in pset.
% point: 3 length vector, x, y, z in order.
% pset: n*3 array, n points, x, y, z in each row
% dist: minimum distance
% index: the closest point in the pset to the given point.
pnum = size(pset, 1);
distvec = pset - repmat(point, pnum, 1);
distvec = sum(distvec.^2, 2);
[mindistsquare, index] = min(distvec);
dist = sqrt(mindistsquare);
end

function [reliable_stemcenter, StemLine] = FitStemLine(selected_stemcenter, EpsionRMS, MinNumP)
% INPUT:
% 1. selected_stemcenter: the stem centers with tree NO used to fit stem
%     lines for each stem. n*7 array. In each row: 
%     [yc, xc, r, zc, TreeNO, number_of_points_in_circle_fitting_finally,
%     ArcAngle(radian)]
% 2. EpsionRMS: the threshold of maximum RMS of distances from stem centers
%       to the fit stem line(meter).
% 3. MinNumP: the minimum number of points to form a stem.
% 
% OUTPUT:
% 1. reliable_stemcenter: the stem centers with tree NO remained in the
%     stem line fitting procedure. n*7 array. In each row: 
%     [yc, xc, r, zc, TreeNO, number_of_points_in_circle_fitting_finally,
%     ArcAngle(radian)]
% 2. StemLine: the fitted line for each stem. n*8 array. In each row:
%     m, n, p, x0, y0, z0, TreeNO, number_of_stem_centers_in_fitting_line_finally
%     ([m, n, p] is direction of line, [x0, y0, z0] is coordinates of one
%     point on line)

reliable_stemcenter=NaN(size(selected_stemcenter));
uniquetreeno = unique(selected_stemcenter(:,5));
StemLine=NaN(length(uniquetreeno), 8);
tempcount=0;
% fit line to each stem. 
wbstr = sprintf('%s\r\n%d / %d trees has been processed.', 'Fit new line after merging very close stems using stem centers with new tree NO: ', 0, length(uniquetreeno));
wbh = waitbar(0, wbstr, 'Name', 'Fit new line for each stem after merging very close stems: ', 'WindowStyle', 'modal', ...
    'CreateCancelBtn', 'setappdata(gcbf,''canceling'',1)');
for count=1:1:length(uniquetreeno)
    % Check for Cancel button press
    if getappdata(wbh,'canceling')
        reliable_stemcenter=reliable_stemcenter(1:tempcount, :);
        StemLine=StemLine(~isnan(StemLine(:,1)), :);
        delete(wbh);
        return;
    end
    
    tempindex = selected_stemcenter(:,5)==uniquetreeno(count);
    if sum(tempindex)<MinNumP
        continue;
    end
    temp_stemcenter=selected_stemcenter(tempindex, :);
    [direction, onepoint, ~, validsub] = ...
        IterativeFitLine3D(temp_stemcenter(:, 2), ...
        temp_stemcenter(:, 1), ...
        temp_stemcenter(:, 4), ...
        EpsionRMS, MinNumP);
    if isempty(validsub)
        wbstr = sprintf('%s\r\n%d / %d trees has been processed.', 'Fit new line after merging very close stems using stem centers with new tree NO: ', count, length(uniquetreeno));
        waitbar(count/length(uniquetreeno), wbh, wbstr);
        continue;        
    end
    
    reliable_stemcenter(tempcount+1:tempcount+length(validsub), :) = ...
        temp_stemcenter(validsub, :);
    tempcount=tempcount+length(validsub);
    
    StemLine(count, :)=[reshape(direction, 1, 3), ...
        reshape(onepoint, 1, 3), ...
        uniquetreeno(count), length(validsub)];
    
    wbstr = sprintf('%s\r\n%d / %d trees has been processed.', 'Fit new line after merging very close stems using stem centers with new tree NO: ', count, length(uniquetreeno));
    waitbar(count/length(uniquetreeno), wbh, wbstr);
end
delete(wbh);
reliable_stemcenter=reliable_stemcenter(1:tempcount, :);
StemLine=StemLine(~isnan(StemLine(:,1)), :);
end