function [Result, MatchedStemBase, DataDistMatrix, ModelDistMatrix, DisThreshold]= ...
    Fcn_MatchFeaturePoints(DataStemBasePathName, DataStemBaseFileName, ...
    ModelStemBasePathName, ModelStemBaseFileName, ...
    DisThreshold, MaxLoopCount, ...
    TieStemBasePathName, TieStemBaseFileName, UseZ)
% Registration, step 4, search the tie points from stem base points by
% matching ditances between every two stem base points in DATA and MODEL
% set respectively. Then, repeat this process again with half of the
% matched DATA and MODEL stem base points until at least four pairs of
% stem base points are matched. 
% 
% SYNTAX: 
%   Fcn_MatchFeaturePoints(DataStemBasePathName, DataStemBaseFileName, ...
%     ModelStemBasePathName, ModelStemBaseFileName, ...
%     DisThreshold, MaxLoopCount, ...
%     TieStemBasePathName, TieStemBaseFileName)
% INPUT: 
%     DataStemBasePathName, DataStemBaseFileName: the file of feature points for DATA: 
%       File format:
%       #1: 'x, y, z, FeaturePointNO'
%       #2-#end: x, y, z, FeaturePointNO
%     ModelStemBasePathName, ModelStemBaseFileName: the file of feature points for MODEL: 
%       File format:
%       #1: 'x, y, z, FeaturePointNO'
%       #2-#end: x, y, z, FeaturePointNO
%     DisThreshold: the initial threshold used to determine whether two distances are the same (meter): 
%     MaxLoopCount: the maximum count for iteration: 
%     TieStemBasePathName, TieStemBaseFileName:the output file for matched feature points
%       File format:
%       #1-#end: x, y, z, FeaturePointNO, x, y, z, ModelPointNO, count_of_matched_distances, mean_of_distance_difference
% TEMPORARY OUTPUT: 
%   None.
% OUTPUT:
% REQUIRED ROUTINES:
%   None. 
% METHODS AND PROCESS: 
%   1. Calculate distances between every two stem base points in DATA and
%   MODEL set respectively. 
%   2. For each stem base point, compare the distances from it to the other
%   stem base points in DATA with those distances from each stem base
%   points to the others in MODEL. If the difference of distances is less
%   than given threshold, then mark the distances as the same. Count the
%   number of the same distance and record the TreeNO of stem in MODEL with
%   the greatest number as the matched stem base points. The number of same
%   distance is recorded as well. 
%   3. Repeat the above processes with half of found matched stem base
%   point pairs with most number of same distances and half of threshold
%   until at least four stem base point pair are found. 

switch nargin
    case 8
      usez = true;
    case 9
      usez = UseZ;
    otherwise
      usez = true;
end

ParameterFileName=['Parameters_Fcn_MatchFeaturePoints_', TieStemBaseFileName];
fid=fopen(fullfile(TieStemBasePathName, ParameterFileName), 'w');
fprintf(fid, [...
    'the ascii file of feature points for DATA: %s\r\n', ...
    'the ascii file of feature points for MODEL: %s\r\n', ...
    'the initial threshold of distance difference used to determine whether two distances are matched (meter): %f\r\n', ...
    'the maximum count for iteration: %d\r\n' ...
    'the output file for matched feature points: %s' ...
    ], ...
    fullfile(DataStemBasePathName, DataStemBaseFileName), ...
    fullfile(ModelStemBasePathName, ModelStemBaseFileName), ...
    DisThreshold, ...
    MaxLoopCount, ...
    fullfile(TieStemBasePathName, TieStemBaseFileName));
fclose(fid);

% read stem base points. 
fid=fopen(fullfile(DataStemBasePathName, DataStemBaseFileName), 'r');
DataStemBase=textscan(fid, '%f %f %f %f', 'Delimiter', ',', 'HeaderLines', 1);
DataStemBase=cell2mat(DataStemBase);
fclose(fid);
fid=fopen(fullfile(ModelStemBasePathName, ModelStemBaseFileName), 'r');
ModelStemBase=textscan(fid, '%f %f %f %f', 'Delimiter', ',', 'HeaderLines', 1);
ModelStemBase=cell2mat(ModelStemBase);
fclose(fid);

if usez
    dimension=3;
else
    dimension=2;
end

CurrentDataStemBase=DataStemBase;
CurrentModelStemBase=ModelStemBase;
CurrentNum = size(DataStemBase, 1);
if CurrentNum < 4
    Result=[];
    MatchedStemBase=[];
    DataDistMatrix=[];

    ModelDistMatrix=[];
    errordlg('Not enough stem base points in DATA set!', 'Match Feature Points Failed', 'modal');
    return;
end
MatchedStemBase = zeros(CurrentNum, 4);
% IterCount = fix(log(CurrentNum/4)/log(2));
AllMSBcrude = cell(MaxLoopCount, 1);
AllMSBrefine = cell(MaxLoopCount, 1);
AllDT = cell(MaxLoopCount, 1);
AllDataSB = cell(MaxLoopCount, 1);
AllModelSB = cell(MaxLoopCount, 1);
InitialDisThreshold = DisThreshold;
IterCount = 0;
LoopCount = 0;
MatchedFlag = false;
while (CurrentNum >= 4) && (DisThreshold > 0.0) && LoopCount<MaxLoopCount
    IterCount = IterCount + 1;
    LoopCount = LoopCount + 1;
    
    InitialDataStemBase = CurrentDataStemBase;
    InitialModelStemBase = CurrentModelStemBase;
    InitialMatchedStemBase = MatchedStemBase;
    
    InitialDataPointNum = size(InitialDataStemBase, 1);
    
    AllDataSB{IterCount} = CurrentDataStemBase;
    AllModelSB{IterCount} = CurrentModelStemBase;
    
    % calculate the distances between every two stem base points in DATA and
    % MODEL. 
    % call functions in Statistics Toolbox to calculate distances. 
    % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    % 2D on x-y plane or 3D
    DataDist = pdist(CurrentDataStemBase(:, 1:dimension));
    ModelDist = pdist(CurrentModelStemBase(:, 1:dimension));
    % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    DataDistMatrix = squareform(DataDist);
    ModelDistMatrix = squareform(ModelDist);
    MatchedStemBase = zeros(size(DataDistMatrix, 1), 4);    % [Index_to_Model_Feature_Points, count_of_matched_distances, sum_of_distance_difference, mean_of_distance_difference]
    for count=1:size(DataDistMatrix, 1)
        tempdatarow = DataDistMatrix(count, :);
        tempdatarow(count)=[];
        tempSameCount = MatchVector2Matrix(tempdatarow, ModelDistMatrix, DisThreshold);
        % !!!
        if (max(tempSameCount(:, 1))==0)
            % maximum count is zero, indicating that no Model point is
            % matched to this data point. 
            MatchedStemBase(count, :) = [NaN, 0, NaN, Inf];
            continue;
        end
        tempsub = find(tempSameCount(:, 1)==max(tempSameCount(:, 1)));
        % !!!
        % if for this stem base in DATA, there are more than one stem base in
        % MODEL has maximum number of so-called same distance, it is thought to
        % correspond to none in MODEL. 
        if length(tempsub)>1
            temp = [tempsub, tempSameCount(tempsub, 1:3)];
            tempsub = find( temp(:, 4)==min(temp(:, 4)) );
            if length(tempsub)==1
                MatchedStemBase(count, :) = temp(tempsub, :);
            else
                MatchedStemBase(count, :) = NaN(1, 4);
            end
        else
            MatchedStemBase(count, :) = [tempsub, tempSameCount(tempsub, 1:3)];
        end
    end
    % remove the rows with [NaN, NaN, NaN, NaN];
    tempindex = ~isnan(MatchedStemBase(:, 1));
    MatchedStemBase=MatchedStemBase(tempindex, :);
    CurrentDataStemBase=CurrentDataStemBase(tempindex, :);
    AllMSBcrude{IterCount} = [CurrentDataStemBase, CurrentModelStemBase(MatchedStemBase(:, 1), :), MatchedStemBase(:, 2),MatchedStemBase(:, 4),];
    % sort the count of 'identical' distance in descending order. 
    [~, tempIX]=sort(MatchedStemBase(:, 2), 'descend');
    MatchedStemBase=MatchedStemBase(tempIX, :);
    CurrentDataStemBase=CurrentDataStemBase(tempIX, :);
    % remove the duplicate MODEL stem base points. 
    [uniqueModelSB, tempUm, ~]=unique(MatchedStemBase(:, 1), 'first');
    tempMatchedStemBase = NaN(size(MatchedStemBase));
    tempCurrentDataStemBase = NaN(size(CurrentDataStemBase));
    tempcount = 0;
    for count=1:length(uniqueModelSB)
        tempindex1 = (MatchedStemBase(:, 1)==uniqueModelSB(count));
        if sum(tempindex)==1
            tempcount = tempcount+1;
            tempMatchedStemBase(tempcount, :) = MatchedStemBase(tempindex1, :);
            tempCurrentDataStemBase(tempcount, :) = CurrentDataStemBase(tempindex1, :);
        else
            % if multiple Data points correspond to the same Model point.
            temp = MatchedStemBase(tempindex1, :);
            tempC = CurrentDataStemBase(tempindex1, :);
            tempindex2 = temp(:, 2)==max(temp(:, 2));
            % remain the one with maximum count if only one is found. 
            if sum(tempindex2)==1
                tempcount = tempcount+1;
                tempMatchedStemBase(tempcount, :) = temp(tempindex2, :);
                tempCurrentDataStemBase(tempcount, :) = tempC(tempindex2, :);
            else
                % if more than one have maximum count, remain the one with
                % minimum mean distance difference. 
                temp = temp(tempindex2, :);
                tempC = tempC(tempindex2, :);
                tempindex3 = temp(:, 4)==min(temp(:, 4));
                if sum(tempindex3)==1
                    tempcount = tempcount+1;
                    tempMatchedStemBase(tempcount, :) = temp(tempindex3, :);
                    tempCurrentDataStemBase(tempcount, :) = tempC(tempindex3, :);
                end
            end
        end
    end
    MatchedStemBase = tempMatchedStemBase(1:tempcount, :);
    CurrentDataStemBase = tempCurrentDataStemBase(1:tempcount, :);

    if size(MatchedStemBase, 1)<4
        AllMSBrefine{IterCount} = [CurrentDataStemBase, CurrentModelStemBase(MatchedStemBase(:, 1), :), MatchedStemBase(:, 2),MatchedStemBase(:, 4),];
        AllDT{IterCount} = DisThreshold;
        
        CurrentDataStemBase = InitialDataStemBase;
        CurrentModelStemBase = InitialModelStemBase;
        MatchedStemBase = InitialMatchedStemBase;
        DisThreshold = 2*DisThreshold;
        CurrentNum = size(CurrentDataStemBase, 1);
        continue;
    else
        % sort the count of 'same' distance in descending order again. 
        [~, tempIX]=sort(MatchedStemBase(:, 2), 'descend');

        MatchedStemBase=MatchedStemBase(tempIX, :);
        CurrentDataStemBase=CurrentDataStemBase(tempIX, :);
        CurrentModelStemBase=CurrentModelStemBase(MatchedStemBase(:, 1), :);
        AllMSBrefine{IterCount} = [CurrentDataStemBase, CurrentModelStemBase, MatchedStemBase(:, 2),MatchedStemBase(:, 4),];
        AllDT{IterCount} = DisThreshold;
        if size(MatchedStemBase, 1)>=4 && size(MatchedStemBase, 1)<8
            if size(MatchedStemBase, 1)<InitialDataPointNum
                CurrentNum = size(CurrentDataStemBase, 1);
                continue;
            else
                MatchedFlag = true;
                break; 
            end
%             MatchedFlag = true;
%             break; 
        else
            % select part of the stem base points with most count. 
            CurrentNum = fix(length(tempIX)/2);
%             CurrentNum = length(tempIX);
            MatchedStemBase=[];
            CurrentDataStemBase=CurrentDataStemBase((1:CurrentNum), :);
            CurrentModelStemBase=CurrentModelStemBase(1:CurrentNum, :);
        end
    end

    % decrease the threshold of distance difference. 
    DisThreshold = DisThreshold/2;
    
end

if MatchedFlag
    Result=[CurrentDataStemBase, CurrentModelStemBase, MatchedStemBase(:, 2),MatchedStemBase(:, 4),];
    dlmwrite(fullfile(TieStemBasePathName, TieStemBaseFileName), Result, 'delimiter', '\t', 'precision', 6, 'newline', 'pc');
else
    % CurrentDataStemBase
    % fprintf('\n')
    % CurrentModelStemBase
    % Result=[CurrentDataStemBase, CurrentModelStemBase, NaN(size(CurrentDataStemBase, 1), 2)];
    % dlmwrite(fullfile(TieStemBasePathName, TieStemBaseFileName), Result, 'delimiter', '\t', 'precision', 6, 'newline', 'pc');
    Result = [];
end

fid=fopen(fullfile(TieStemBasePathName, ParameterFileName), 'a');
fprintf(fid, [...
    '\r\nInputDataPointNum\tInputModelPointNum\tInitialDisThreshold\tMatchedPointPairNum\tFinalDisThreshold\tTotalIterationCount\tTotalLoopCount\r\n', ...
    '%d\t%d\t%1.3f\t%d\t%1.3f\t%d\t%d\r\n', ...
    '\r\nIterationCount\tDataPointNum\tModelPointNum\tDisThreshold\tMatchedPointPairNum\tMeanMatchedCount\tMeanMeanDisDiff\r\n' ...
    ], ...
    size(DataStemBase, 1), size(ModelStemBase, 1), InitialDisThreshold, size(Result, 1), DisThreshold, IterCount, LoopCount ...
    );
for count=1:IterCount
    temp = AllMSBrefine{count};
    fprintf(fid, '%d\t%d\t%d\t%1.3f\t%d\t%1.3f\t%1.3f\r\n', count, size(AllDataSB{count}, 1), size(AllModelSB{count}, 1), AllDT{count}, size(temp, 1), mean(temp(:, 9)), mean(temp(:, 10)));
end
fclose(fid);

if ~MatchedFlag
    Result = [];
    % errordlg('No feature points are matched!', 'Match Feature Points', 'modal');
    warning('TIES_TLS:Fcn_MatchFeaturePoints', 'No feature points are matched!');
    return;
end

end

function SameCount=MatchVector2Matrix(Vdis, Mdis, Threshold)
%   Compare each element in Vdis and Mdis, if the difference between two
%   elements is less than Threshold, they are marked as same. Count the
%   number of 'same' elements in each row of Mdis which is recorded in a
%   vector SameCount. 
%   INPUT: 
%       Vdis: a row from DataDistMatrix (distance matrix of DATA)
%       Mdis: a matrix, i.e. ModelDistMatrix (distance matrix of MODEL)
%       Threshold: a value indicating the maximum difference of two
%       elements. 
%   OUTPUT:
%       SameCount: size(Mdis, 1)*3, the number of so-called same
%       elements in each row of Mdis with Vdis. 
%       each row: [count, sum of distance difference, mean of dist diff]

    SameCount = zeros(size(Mdis, 1), 3);
    colnum=size(Mdis, 2);
    for row=1:size(Mdis, 1)
        tempcount = 0;
        tempsumdist = 0;
        currentVdis = Vdis;
        for col=1:colnum
            if col==row
                continue;
            end
            DistDiff = abs( Mdis(row, col)*ones(size(currentVdis)) - currentVdis );
            
            [~, tempsub] = min(DistDiff);
            % if tempsub contains more than one element, only use the first
            % element as corresponding stem base in MODEL. 
            if DistDiff(tempsub(1))<=Threshold
                tempcount = tempcount + 1;
                tempsumdist = tempsumdist + DistDiff(tempsub(1));
            end
        end
        SameCount(row, :) = [tempcount, tempsumdist, tempsumdist./tempcount];
    end
end