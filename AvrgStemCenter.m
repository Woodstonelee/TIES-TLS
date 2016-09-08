% AvrgStemCenter
% estimate the stem center positions from slices along stem direction
% (usually z axis), and average these positions as AvrgStemCenter. If no
% stem center position is derived, return NaN(1, 3).
% 
% SYNTAX: 
%   [ASC, stemcenter, stemcenterHT, stemIterCount,
%   stemArcInfo]=AvrgStemCenter(x, y, z, SingleScanFlag, SliceThick,
%   cellsize, maxR, sigmacoef, epsion, maxIter, minnumfit, scanpos)
% 
% INPUT: 
%   x, y, z: the coordinates of points from only one stem.
%   SingleScanFlag: indicate if the input point clouds are single scan
%   data or complete scan data. true means single scan data, it will use
%   the function mexDetEstCircle_Half.mexw32. If false, it uses
%   mexDetEstCircle_Complete.mexw32
%   SliceThick: the thickness of slice. 
%   cellsize: the cell size used to rasterize the point clouds. 
%   maxR: the maximum radius used in Circular Hough Transform, in unit of
%   pixel. 
%   sigmacoef: used to determine the ROI: HT_radius+(or -)sigmacoef*r_sigma.
%   epsion: converge constraint threshold: in unit of meter, usually 0.01meter.
%   maxIter: maximum iteration counts in Iterative Hough Transform
%   Algorithm, usually 100. 
%   minnumfit: the minimum number of points used to fit a circle by Least
%     Square Method.
%   scanpos: [scanpos_x, scanpos_y, scanpos_z], the scan position in the
%       same coordinate system as the coordinate system of given x and y.
% 
% OUTPUT:
%   ASC: the average stem center position and radius, 
%   [average_yc, average_xc, average_r], in unit of meter. If detection
%   failed, return empty matrix[].
%   stemcenter: fitted circle center and radii of all slices, num_slice*4,
%   [yc, xc, r, slice_middle_z], if no circle returned(i.e. empty matrix[] returned) by
%   mexDetEstCircle, it will be changed to NaN(1, 3).
%   stemcenterHT: HT detected circle center and radii of all slices,
%   num_slice*4, [yc, xc, r, slice_middle_z], if no circle returned(i.e. empty matrix[]
%   returned) by mexDetEstCircle, it will be changed to NaN(1, 3).
%   stemIterCount: the iterative count, last change of center and radii of
%   all slices, num_slices*3, if iterative count is 0, it indicates either
%   point number in this slice is less than minnumfit or circle fitting
%   failed. Its special value: [0, NaN, NaN], [0, Inf, Inf], [0, 0, 0]
%   stemArcInfo: [start_angle, end_angle, arc_angle]
% 
% REQUIRED ROUTINES: 
%   1. mexDetEstCircle_Half.mexw32
%   2. mexDetEstCircle_Complete.mexw32
% 
% METHOD: 

% PARAMETER SETTING FOR EXECUTION: 
% ptscldfilename='E:\Research of IRSA\Lidar\Terrestrial\Data\cls_IterHT\TrunkDetected\Ptsarr_T\laspts_tree13.txt';
% ptscloudfid=fopen(ptscldfilename);
% data=textscan(ptscloudfid,'%f %f %f %*s');
% x=data{1};
% y=data{2};
% z=data{3};
% fclose(ptscloudfid);
% x=reshape(x, length(x),1);
% y=reshape(y, length(y),1);
% z=reshape(z, length(z),1);
% SliceThick=0.1;
% cellsize=0.01;
% maxR=50;
% sigmacoef=1;
% epsion=0.001;
% maxIter=100;
% minnumfit=6;
% [AvrgStemCenter, stemcenter, stemcenterHT, stemIterCount]=AvrgStemCenter(x, y, z, SliceThick, cellsize,
% maxR, sigmacoef, epsion, maxIter, minnumfit);
function [ASC, stemcenter, stemcenterHT, stemIterCount, stemArcInfo]=AvrgStemCenter(x, y, z, SingleScanFlag, SliceThick, cellsize, maxR, sigmacoef, epsion, maxIter, minnumfit, scanpos)
    minz=min(z);
    maxz=max(z);
    slicenum=floor((maxz-minz)/SliceThick)+1;
    stemcenter=zeros(slicenum, 4);
    stemcenterHT=zeros(slicenum, 4);
    stemIterCount=zeros(slicenum, 4);
    stemArcInfo=zeros(slicenum, 3);
    
%     fprintf('AvrgStemCenter Start: %d slices ... ...', slicenum);
    
    for count=1:slicenum
        bottom=minz+(count-1)*SliceThick;
        top=minz+(count)*SliceThick;
        selectindex= z>=bottom & z<top;
        selectx=x(selectindex);
        selecty=y(selectindex);
        if length(selectx)<minnumfit
            detectedcircle=NaN(1,4);
            finalHT=NaN(1,4);
            stemIterCount(count, :)=zeros(1, 4);
            stemArcInfo(count, :)=zeros(1, 3);
        else
            if SingleScanFlag
                [detectedcircle, finalHT, iterationdata, arcinfo] = mexDetEstCircle_Half(selectx, selecty, cellsize, maxR, sigmacoef, epsion, maxIter, minnumfit, scanpos);
            else
                [detectedcircle, finalHT, iterationdata, arcinfo] = mexDetEstCircle_Complete(selectx, selecty, cellsize, maxR, sigmacoef, epsion, maxIter, minnumfit);                
            end
            
            if isempty(detectedcircle) || isempty(finalHT) || arcinfo(3)==0 || isinf(arcinfo(3))
                detectedcircle=NaN(1,4);
                finalHT=NaN(1,4);
            else
                detectedcircle=[detectedcircle, (bottom+top)/2];
                finalHT=[finalHT, (bottom+top)/2];
            end
            stemIterCount(count, :)=iterationdata;
            stemArcInfo(count, :)=arcinfo;
        end
        stemcenter(count, :)=detectedcircle;
        stemcenterHT(count, :)=finalHT;
    end
    
    selectindex= (~isnan(stemcenter(:, 1))) & (~isnan(stemIterCount(:, 2)));
    if all(~selectindex)
        ASC=[];
%         fprintf('Failed: no slice give circle!\n');
        return;
    end
    ASC=mean(stemcenter(selectindex, 1:3), 1);    
%     fprintf('Succeed: %d slices give circles!\n', sum(selectindex));
end