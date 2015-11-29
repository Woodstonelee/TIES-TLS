% PtsPathName = 'E:\Research of IRSA\Lidar\Terrestrial\ProcessAnalysis\clslc101702NEW\OriginalPtscldsSOCS';
% PtsFileName = 'cl101702cz - Scan001.txt';
% StemPtsPathName = 'E:\Research of IRSA\Lidar\Terrestrial\ProcessAnalysis\clslc101702NEW\cl101702AutoReg';
% StemPtsFileName = 'StemPts_cl101702cz - Scan001.txt';
% StemBasePathName = 'E:\Research of IRSA\Lidar\Terrestrial\ProcessAnalysis\clslc101702NEW\cl101702AutoReg';
% StemBaseFileName = 'NewStemBases_arrTree_cl101702cz.txt';
% BreastHeight = 1.3;
% SliceThick = 0.1;
% ExtentRadius = 0.5;
% cellsize=0.01;
% maxR=50;
% sigmacoef=1;
% epsion=0.001;
% maxIter=100;
% minnumfit=6;
% SingleScanFlag = true;
% scanpos = [0 0 0];
% DBHTreeHPathName = 'E:\Research of IRSA\Lidar\Terrestrial\My Programs';
% DBHTreeHFileName = 'TestDBHTreeH.txt';

function [ReturnMsgStr, WarnMsgStr] = Fcn_EstDBHTreeHeight(PtsPathName, PtsFileName, ...
    StemBasePathName, StemBaseFileName, ...
    BreastHeight, ExtentRadius, ...
    SliceThick, cellsize, maxR, minnumfit, sigmacoef, epsion, maxIter, ...
    SingleScanFlag, scanpos, ...
    DBHTreeHPathName, DBHTreeHFileName)
% Estimate the DBH and tree height of each detected tree. DBH is estimated
% from a slice of stem points at the given height (usually 1.3m) above the
% stem base. Tree height is the height difference between the stem base and
% the highest point within a circle centering at the DBH center and with a
% given radius.
% 
% SYNTAX: Fcn_EstDBHTreeHeight(PtsPathName, PtsFileName, ...
%     StemPtsPathName, StemPtsFileName, ...
%     StemBasePathName, StemBaseFileName, ...
%     BreastHeight, SliceThick, ExtentRadius, SingleScanFlag, ...
%     DBHTreeHPathName, DBHTreeHFileName)
% INPUT:
%   1. PtsPathName, PtsFileName: Text file of original point clouds. 
%       File format:
%       #1-#end: x y z
%   2. StemBasePathName, StemBaseFileName: Text file of stem bases. 
%       File format:
%       #1: 'x, y, z, TreeNO'
%       #2-#end: x, y, z, TreeNO
%   3. BreastHeight: the breast height, usually 1.3m
%   4. ExtentRadius: the radius of the cylinder within which the points are
%   used to estimate tree height and DBH.
%   5. SliceThick, cellsize, maxR, minnumfit, sigmacoef, epsion, maxIter,
%   SingleScanFlag, scanpos: all the 9 arguments are used for the
%   estimation of DBH (mexDetEstCircle_Half and mexDetEstCircle_Complete).
%   More detailes are listed in the function of mexDetEstCircle_Half and
%   mexDetEstCircle_Complete.
%   6. DBHTreeHPathName, DBHTreeHFileName: Output text file of DBH and tree
%   height.
%       File format:
%       #1: 'TreeNO, DBH, TreeHeight, CenterX_BH, CenterY_BH, StemBaseX, StemBaseY, StemBaseZ'
%       #2-#end: TreeNO, DBH, TreeHeight, CenterX_BH, CenterY_BH,
%       StemBaseX, StemBaseY, StemBaseZ
% OUTPUT:
%
% REQUIRED ROUTINES:
%   1. mexDetEstCircle_Half.mexw32
%   2. mexDetEstCircle_Complete.mexw32
% METHODS AND PROCESS: 

ReturnMsgStr = '';
WarnMsgStr = '';

fid = fopen(fullfile(StemBasePathName, StemBaseFileName), 'r');
if fid<0
    errstr = sprintf('Estimate DBH and Tree Height: failed to open the file of stem bases: \r\n%s', fullfile(StemBasePathName, StemBaseFileName));
    errordlg(errstr, 'Estimate DBH and Tree Height', 'modal');
    return;
end
fclose(fid);
data = importdata(fullfile(StemBasePathName, StemBaseFileName));
if iscell(data.data)
    StemBase = cell2mat(data.data);
else
    StemBase = data.data;
end
TreeNum = size(StemBase, 1);

wbstr = sprintf('%s\r\n%d / %d trees has been processed.', 'Estimate DBH and tree height: ', 0, TreeNum);
wbh = waitbar(0, wbstr, 'Name', 'Estimate DBH and Tree Height', 'WindowStyle', 'modal', ...
    'CreateCancelBtn', 'setappdata(gcbf,''canceling'',1)');

fid = fopen(fullfile(PtsPathName, PtsFileName), 'r');
if fid<0
    errstr = sprintf('Estimate DBH and Tree Height: failed to open the file of original point clouds: \r\n%s', fullfile(PtsPathName, '\', PtsFileName));
    errordlg(errstr, 'Estimate DBH and Tree Height', 'modal');
    return;
end
data = textscan(fid, '%f %f %f');
AllPts = cell2mat(data);
fclose(fid);
AllPtsNum = size(AllPts, 1);

DBH = zeros(TreeNum, 3);
TreeH = zeros(TreeNum, 1);

% fid = fopen('E:\Research of IRSA\Lidar\Terrestrial\ProcessAnalysis\clslc101702NEW\cl101702AutoReg\arrTree_cl101702cz - Scan001.txt', 'r');
% data = textscan(fid, '%f %f %f %f');
% fclose(fid);
% arrTree = cell2mat(data);
% fid = fopen('E:\Research of IRSA\Lidar\Terrestrial\ProcessAnalysis\clslc101702NEW\cl101702AutoReg\MergeTable_StemBases_arrTree_cl101702cz.txt', 'r');
% data = textscan(fid, '%f %f', 'HeaderLines', 1);
% fclose(fid);
% mergetable = cell2mat(data);

for count=1:TreeNum%[6,46]
    % Check for Cancel button press
    if getappdata(wbh,'canceling')
        % output the DBH and tree height that has been estimated to text files.
        % ---output: DBH and tree height---
        fid = fopen(fullfile(DBHTreeHPathName, DBHTreeHFileName), 'w');
        fprintf(fid, 'TreeNO, DBH, TreeHeight, CenterX_BH, CenterY_BH, StemBaseX, StemBaseY, StemBaseZ\r\n');
        fprintf(fid, '%d, %f, %f, %f, %f, %f, %f, %f\r\n', [StemBase(1:count-1, 4), DBH(1:count-1, 1), TreeH(1:count-1, 1), DBH(1:count-1, 2:3), StemBase(1:count-1, 1:3)]');
        fclose(fid);
        % ---ending of output---
        
        ReturnMsgStr = 'Estimation of DBH and Tree Height was Canceled.';
        delete(wbh);
        clear functions;
        return;
    end
    
    Dist = sqrt( (AllPts(:, 1) - StemBase(count, 1)*ones(AllPtsNum, 1)).^2 + (AllPts(:, 2) - StemBase(count, 2)*ones(AllPtsNum, 1)).^2 );
    selected = Dist < ExtentRadius;    
    selectx = AllPts(selected, 1);
    selecty = AllPts(selected, 2);
    selectz = AllPts(selected, 3);
    
%     selected = ismember(arrTree(:, 4), mergetable(mergetable(:, 2)==StemBase(count, 4), 1));
%     selectx = arrTree(selected, 1);
%     selecty = arrTree(selected, 2);
%     selectz = arrTree(selected, 3);
    
    selected = ( (selectz - StemBase(count, 3)) < BreastHeight+0.5*SliceThick ) & ( (selectz - StemBase(count, 3)) > BreastHeight-0.5*SliceThick );
    selectx = selectx(selected);
    selecty = selecty(selected);
    
    if length(selectx)<minnumfit
        DBH(count, :) = NaN(1, 3);
        TreeH(count) = NaN;
    else
        if SingleScanFlag
            [detectedcircle, finalHT, iterationdata, arcinfo] = mexDetEstCircle_Half(selectx, selecty, cellsize, maxR, sigmacoef, epsion, maxIter, minnumfit, scanpos);
        else
            [detectedcircle, finalHT, iterationdata, arcinfo] = mexDetEstCircle_Complete(selectx, selecty, cellsize, maxR, sigmacoef, epsion, maxIter, minnumfit);                
        end

        if isempty(detectedcircle) || isempty(finalHT) || arcinfo(3)==0 || isinf(arcinfo(3))
            DBH(count, :) = NaN(1, 3);
            TreeH(count) = NaN;
        else
            if all(reshape(iterationdata(1:3), 1, 3)==[0 NaN NaN])
                DBH(count, :) = NaN(1, 3);
                TreeH(count) = NaN;
                
                WarnMsgStr = sprintf('The circle center detected by Hough Transform locates outside the rasterized image. Please increase the maximum possible radius');
            else
                DBH(count, 1) = detectedcircle(3)*2;
                DBH(count, 2:3) = [detectedcircle(2), detectedcircle(1)];
            end
        end
    end
    
    if ~isnan(TreeH(count))
        Dist = sqrt( (AllPts(:, 1) - DBH(count, 2)*ones(AllPtsNum, 1)).^2 + (AllPts(:, 2) - DBH(count, 3)*ones(AllPtsNum, 1)).^2 );
        selected = Dist < ExtentRadius;
        selectz = AllPts(selected, 3);
        if isempty(selectz)
            TreeH(count) = NaN;
        else
            maxselectz = max(selectz);
            TreeH(count) = maxselectz - StemBase(count, 3);
        end
    end
    
    wbstr = sprintf('%s\r\n%d / %d trees has been processed.', 'Estimate DBH and tree height: ', count, TreeNum);
    waitbar(count/TreeNum, wbh, wbstr);
    
end
delete(wbh);

fid = fopen(fullfile(DBHTreeHPathName,DBHTreeHFileName), 'w');
if fid<0
    errstr = sprintf('Estimate DBH and Tree Height: failed to create the file for writing DBH and tree height \r\n%s', fullfile(DBHTreeHPathName, DBHTreeHFileName));
    errordlg(errstr, 'Estimate DBH and Tree Height', 'modal');
    return;
end
fprintf(fid, 'TreeNO, DBH, TreeHeight, CenterX_BH, CenterY_BH, StemBaseX, StemBaseY, StemBaseZ\r\n');
fprintf(fid, '%d, %f, %f, %f, %f, %f, %f, %f\r\n', [StemBase(:, 4), DBH(:, 1), TreeH(:, 1), DBH(:, 2:3), StemBase(:, 1:3)]');
fclose(fid);

ReturnMsgStr = 'Estimation of DBH and Tree Height was Finished Successfully.';

clear functions;
end