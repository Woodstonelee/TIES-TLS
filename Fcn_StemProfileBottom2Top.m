function ReturnMsgStr = Fcn_StemProfileBottom2Top(DataPathName, DataPtsFileName, ...
    SingleScanFlag, ...
    cellsize, slicethick, maxR, minnumfit_data, sigmacoef, epsion, maxIter, ...
    initialTranslateVector_Data, ...
    DeltaTheta, DeltaPhi, Ratio, EpsionRMS, MinNumP, ...
    OutPath ...
    )
% Registration, step 1, detect and estimate the stem centers and radii by
% Hough Transform and least square fitting from the file of forest point
% clouds with tree NO. 
% SYNTAX: 
%     Fcn_StemProfileBottom2Top(DataPathName, DataPtsFileName, ...
%     SingleScanFlag, ...
%     cellsize, slicethick, maxR, minnumfit_data, sigmacoef, epsion, maxIter, ...
%     initialTranslateVector_Data, ...
%     DeltaTheta, DeltaPhi, Ratio, EpsionRMS, MinNumP, ...
%     OutPath ...
%     )
% INPUT: 
%   1. [DataPathName, DataPtsFileName]: Forest point clouds set with marked tree NO created by
%   'Detect and Classify Stems'.
%           File format:
%           #1-#end: x \t y \t z \t TreeNO
%   2. SingleScanFlag: indicate if the input point clouds are single scan
%   data 
%   3. cellsize: cell size in horizontal plane (meter)
%   4. slicethick: slice thick along Z (meter)
%   5. maxR: maximum possible radius in pixels
%   6. minnumfit_data: minimum number of points used in final circle estimation
%   7. sigmacoef: coefficient of standard deviation of radii defining ROI
%   8. epsion: the threshold used in circle detection (meter)
%   9. maxIter: maximum iterative count in circle detection
%   10. initialTranslateVector_Data: the scan position determination
%   according to initial SOP of inputted point clouds.
%   11. DeltaTheta: the resolution of theta (with z axis, degree)
%   12. DeltaPhi: the resolution of phi (with x axis, degree)
%   13. Ratio: the ratio of threshold to theorectial point density
%   14. EpsionRMS: the threshold of minimum RMS of distances to the fit stem line(meter)
%   15. MinNumP: the minimum number of points to form a stem
%   16. OutPath: Output directory
% TEMPORARY OUTPUT: 
%   None.
% OUTPUT:
%   1. Text files of stem centers. (StemCenter_)
%       Format:
%       yc, xc, r, zc, TreeNO, number_of_points_in_circle_fitting_finally, ArcAngle(radian) 
%   2. Text files of reliable stem centers determined only by half plane. (ReliableStemCenterByPtsNum_)
%       Format:
%       yc, xc, r, zc, TreeNO, number_of_points_in_circle_fitting_finally, ArcAngle(radian) 
%   3. Text files of reliable stem centers determined only by half plane and fitted line. (ReliableStemCenterByPtsNum&FitLine_)
%       Format:
%       yc, xc, r, zc, TreeNO, number_of_points_in_circle_fitting_finally, ArcAngle(radian) 
%   4. Text files of fitted lines of stems. (FittedStemLine_)
%       Format: 
%       m, n, p, x0, y0, z0, TreeNO, number_of_stem_centers_in_fitting_line_finally
%       ([m, n, p] is direction of line, [x0, y0, z0] is coordinates of one point on line)
% REQUIRED ROUTINES:
%   1. AvrgStemCenter.m
%   2. mexDetEstCircle_Half.mexw32
%   3. IterativeFitLine3D.m
% METHODS AND PROCESS: 
%   1. Read points from data and model stem point clouds file. Select from
%   data set points with z value below a given height (usually determined
%   by proportion of stem height to complete tree height).
%   2. With selected points, seperate trees, and calculate stem centers
%   using AvrgStemCenter.m. 
%   THEN, 
%   0. Remove stem centers with zero arc angle!
%   1. Calculate the theoretical point density at each stem center. And
%   calculate the threshold of point number for each stem center according
%   to the given ratio. 
%   2. Remove the stem centers with point numbers less than corresponding
%   threshold. 
%   3. Fit a line to these stem centers with the same tree NO by
%   IterativeFitLine3D.m and get final valid stem centers via removing
%   those ones deviating from the fit line more than the remained. 

% Output the given parameters to a text file. 
ParameterFileName=['Parameters_Fcn_StemProfileBottom2Top_', DataPtsFileName];
fid=fopen(fullfile(OutPath, ParameterFileName), 'w');
fprintf(fid, [...
    'inputted file of point cloud with TREE ID: \r\n%s\r\n\r\n', ...
    'Parameters for detect and estimate circles: \r\n', ...
    'cell size in horizontal plane (meter): %f\r\n', ...
    'slice thick along Z (meter): %f\r\n', ...
    'maximum possible radius in pixels: %f\r\n', ...
    'minimum number of points used in final circle estimation: %f\r\n', ...
    'coefficient of standard deviation of radii defining ROI: %f\r\n', ...
    'epsion, the threshold used in circle detection (meter): %f\r\n', ...
    'maximum iterative count in circle detection: %f\r\n' ...
    '\r\nParameters for select reliable stem centers: \r\n', ...
    'the resolution of theta (with z axis, degree): %f\r\n', ...
    'the resolution of phi (with x axis, degree): %f\r\n', ...
    'the ratio of threshold to theorectial point density: %f\r\n', ...
    'the threshold of minimum RMS of distances to the fit stem line(meter): %f\r\n', ...
    'the minimum number of points to form a stem: %f\r\n' ...
    '\r\nOutput directory: %s\r\n' ...
    ], ...
    fullfile(DataPathName, DataPtsFileName), ...
    cellsize, slicethick, maxR, minnumfit_data, sigmacoef, epsion, maxIter, ...
    DeltaTheta, DeltaPhi, Ratio, EpsionRMS, MinNumP, ...
    OutPath);
fclose(fid);

% step 1, detect and estimate the stem centers and radii by
% Hough Transform and least square fitting from the file of forest point
% clouds with tree NO.
% StemProportion_data: proportion of stem height to complete tree height.
StemProportion_data=1;
ptscldfid=fopen(fullfile(DataPathName, DataPtsFileName), 'r');
rawdata=textscan(ptscldfid,'%f %f %f %f');
fclose(ptscldfid);
datax=rawdata{1};
datay=rawdata{2};
dataz=rawdata{3};
datatreeno=rawdata{4};
clear rawdata;
% reshape x, y, z to column vector.
ndata=length(datax);
datax=reshape(datax, ndata,1);
datay=reshape(datay, ndata,1);
dataz=reshape(dataz, ndata,1);
datatreeno=reshape(datatreeno, ndata,1);
% select points below the given height from data set. 
maxz=max(dataz);minz=min(dataz);
topz_data=(maxz-minz)*StemProportion_data+minz;
temp_index=dataz<=topz_data;
datax=datax(temp_index);
datay=datay(temp_index);
dataz=dataz(temp_index);
datatreeno=datatreeno(temp_index);

ntree_data=max(datatreeno);
ASC_data=zeros(ntree_data, 4);
stemcenter_data=cell(ntree_data, 1);
% calculate average stem centers for each tree in data point set. 
% nanIter_Count1=0;
tempname = fullfile(DataPathName, DataPtsFileName);
wbstr = sprintf('%s\r\n%s\r\n%d / %d trees has been processed.', 'Detect and estimate circles at different heights from bottom to top: ', tempname, 0, ntree_data);
wbh = waitbar(0, wbstr, 'Name', 'Stem profiler from the bottom to top', 'WindowStyle', 'modal', ...
    'CreateCancelBtn', 'setappdata(gcbf,''canceling'',1)');
for itree=1:ntree_data%[148, 502, 520]
    % Check for Cancel button press
    if getappdata(wbh,'canceling')
        % output the stem centers to text files.
        % ---output: stem centers along z axis every slicethick---
        temp_stemcenter=cell2mat(stemcenter_data);
        temp_notNaN=~isnan(temp_stemcenter(:, 1));
        all_stemcenter_data=temp_stemcenter(temp_notNaN, :);
        dlmwrite(fullfile(OutPath, ['StemCenter_', DataPtsFileName]), all_stemcenter_data, 'delimiter', '\t', 'precision', '%.6f', 'newline', 'pc');
        % ---ending of output---
        
        ReturnMsgStr = 'Estimation of stem center and radii Canceled: Stem Profiler, from the stem bottom to top.';
        delete(wbh);
        clear functions;
        return;
    end
    
    singletree = datatreeno==itree;
    singletree_x=datax(singletree);
    if isempty(singletree_x)
        continue;
    end
    singletree_y=datay(singletree);
    singletree_z=dataz(singletree);
%     fprintf('DATA, process the NO %d tree: ', itree);
    [tempASC, tempstemcenter, ~, tempIteration, tempArcInfo]= ...
        AvrgStemCenter(singletree_x, singletree_y, singletree_z, SingleScanFlag, slicethick, cellsize, maxR, sigmacoef, epsion, maxIter, minnumfit_data, initialTranslateVector_Data);
    if ~isempty(tempASC)
        ASC_data(itree, 1:3)=tempASC;
        ASC_data(itree, 4)=itree;
    end
    nanIterIndex=isnan(tempIteration(:, 2));
%     nanIter_Count1=nanIter_Count1+sum(nanIterIndex);
    nanstemcenter=isnan(tempstemcenter(:, 1));
    tempstemcenter=tempstemcenter((~nanIterIndex)&(~nanstemcenter), :);
    stemcenter_data{itree}=[tempstemcenter, itree*ones(size(tempstemcenter, 1), 1), tempIteration((~nanIterIndex)&(~nanstemcenter), 4), tempArcInfo((~nanIterIndex)&(~nanstemcenter), 3)];
    wbstr = sprintf('%s\r\n%s\r\n%d / %d trees has been processed.', 'Detect and estimate circles at different heights from bottom to top: ', tempname, itree, ntree_data);
    waitbar(itree/ntree_data, wbh, wbstr);
end
delete(wbh);
% output the stem centers to text files.
% ---output: stem centers along z axis every slicethick---
temp_stemcenter=cell2mat(stemcenter_data);
temp_notNaN=~isnan(temp_stemcenter(:, 1));
all_stemcenter_data=temp_stemcenter(temp_notNaN, :);
dlmwrite(fullfile(OutPath, ['StemCenter_', DataPtsFileName]), all_stemcenter_data, 'delimiter', '\t', 'precision', '%.6f', 'newline', 'pc');
% ---ending of output---

clear functions;

% step 2, select reliable stem centers from all the estimate.
% get existing stem centers file. 
SCdatafile=fullfile(OutPath, ['StemCenter_', DataPtsFileName]);
% ---read from stem center file---
fid=fopen(SCdatafile, 'r');
all_stemcenter=textscan(fid, '%f %f %f %f %f %f %f');
all_stemcenter=cell2mat(all_stemcenter);
fclose(fid);
% ---ending of reading stem center file.---

scanx=initialTranslateVector_Data(1);
scany=initialTranslateVector_Data(2);
scanz=initialTranslateVector_Data(3);
% remove stem centers with zero arc angle!
all_stemcenter=all_stemcenter(all_stemcenter(:,7)~=0, :);
% calculate the range of each stem center to the scan position. 
rangesquare = ( (all_stemcenter(:, 2)-scanx).^2 + ...
    (all_stemcenter(:, 1)-scany).^2 + ...
    (all_stemcenter(:, 4)-scanz).^2 );
% calculate the theoretical point density at each stem center.
theory_ptsdensity = 1 ./ (rangesquare.*DeltaTheta/180*pi*DeltaPhi/180*pi);
% calculate the threshold for number of points at each stem center. 
threshold_pnum = theory_ptsdensity * Ratio * slicethick .* ...
        all_stemcenter(:, 3).*all_stemcenter(:, 7);
if ~SingleScanFlag
    threshold_pnum = threshold_pnum*0.5;
end

% select the stem centers with point numbers no less than threshold of
% point number. 
tempindex = all_stemcenter(:, 6) >= threshold_pnum;
selected_stemcenter = all_stemcenter(tempindex, :);
% temporarily output
dlmwrite(fullfile(OutPath, ['ReliableStemCenterByPtsNum_', DataPtsFileName]), selected_stemcenter, 'delimiter', '\t', 'precision', 6, 'newline', 'pc');

reliable_stemcenter=NaN(size(selected_stemcenter));
uniquetreeno = unique(selected_stemcenter(:,5));
StemLine=NaN(length(uniquetreeno), 8);
tempcount=0;
% fit line to each stem. 
wbstr = sprintf('%s\r\n%s\r\n%d / %d trees has been processed.', 'Fit line for each stem: ', tempname, 0, length(uniquetreeno));
wbh = waitbar(0, wbstr, 'Name', 'Stem profiler from the bottom to top', 'WindowStyle', 'modal', ...
    'CreateCancelBtn', 'setappdata(gcbf,''canceling'',1)');
for count=1:1:length(uniquetreeno)
    % Check for Cancel button press
    if getappdata(wbh,'canceling')
        % ---output the reliable stem centers---
        reliable_stemcenter=reliable_stemcenter(1:tempcount, :);
        StemLine=StemLine(~isnan(StemLine(:,1)), :);
        dlmwrite(fullfile(OutPath, ['ReliableStemCenterByPtsNum&FitLine_', DataPtsFileName]), reliable_stemcenter, 'delimiter', '\t', 'precision', 6, 'newline', 'pc');
        dlmwrite(fullfile(OutPath, ['FittedStemLine_', DataPtsFileName]), StemLine, 'delimiter', '\t', 'precision', 6, 'newline', 'pc');
        % ---end of output---
        
        ReturnMsgStr = 'Fitting line to stems Canceled: Stem Profiler, from the stem bottom to top.';
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
        wbstr = sprintf('%s\r\n%s\r\n%d / %d trees has been processed.', 'Fit line for each stem: ', tempname, count, length(uniquetreeno));
        waitbar(count/length(uniquetreeno), wbh, wbstr);
        continue;        
    end
    
    reliable_stemcenter(tempcount+1:tempcount+length(validsub), :) = ...
        temp_stemcenter(validsub, :);
    tempcount=tempcount+length(validsub);
    
    StemLine(count, :)=[reshape(direction, 1, 3), ...
        reshape(onepoint, 1, 3), ...
        uniquetreeno(count), length(validsub)];
    
    wbstr = sprintf('%s\r\n%s\r\n%d / %d trees has been processed.', 'Fit line for each stem: ', tempname, count, length(uniquetreeno));
    waitbar(count/length(uniquetreeno), wbh, wbstr);
end
delete(wbh);
reliable_stemcenter=reliable_stemcenter(1:tempcount, :);
StemLine=StemLine(~isnan(StemLine(:,1)), :);
dlmwrite(fullfile(OutPath, ['ReliableStemCenterByPtsNum&FitLine_', DataPtsFileName]), reliable_stemcenter, 'delimiter', '\t', 'precision', 6, 'newline', 'pc');
dlmwrite(fullfile(OutPath, ['FittedStemLine_', DataPtsFileName]), StemLine, 'delimiter', '\t', 'precision', 6, 'newline', 'pc');

ReturnMsgStr = 'Finished: Stem Profiler, from the stem bottom to top.';

end