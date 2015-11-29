function [coarseR3D, coarseT3D, EA3D, distrms3D]=Fcn_RegExplicitlyMatchedPoints( ...
    TieStemBasePathName, TieStemBaseFileName, ...
    TMPathName, TMFileName, UseZ)
% !!!Function!!!
% Registration, step 5, input tie stem base points, calculate coarse
% transform matrix by minimizing the sum of square of distance between tie
% stem base. Registration is carried out with 3-D coordinates.
% INPUT:
%     TieStemBasePathName, TieStemBaseFileName:the ascii file of matched feature points
%       File format:
%       #1-#end: x, y, z, FeaturePointNO, x, y, z, ModelPointNO, count_of_matched_distances, mean_of_distance_difference
%   TMPathName, TMFileName: the ascii file for outputting transformation
%   matrix. 
% OUTPUT:
%   coarseR3D, coarseT3D: transformation matrix
%   EA3D: 1*3 vector, [roll, pitch, yaw], in unit of degree
%   distrms3D: Square root of sum of square of distances between matched
%   feature points in Data and Model, in unit of meter. 
% REQUIRED ROUTINES: 
%   lsqTM.m

% p = inputParser;
% default_usez = true;
% addParameter(p, 'UseZ', default_usez);
% parse(p, varargin{:});
% usez = p.Results.UseZ;
switch nargin
    case 4
      usez = true;
    case 5
      usez = UseZ;
    otherwise
      usez = true;
end

ParameterFileName=['Parameters_Fcn_RegExplicitlyMatchedPoints_', TMFileName];
fid=fopen(fullfile(TMPathName, ParameterFileName), 'w');
fprintf(fid, [...
    'the ascii file of matched feature points: %s\r\n', ...
    'the output file for outputting transformation: %s' ...
    ], ...
    fullfile(TieStemBasePathName, TieStemBaseFileName), ...
    fullfile(TMPathName, TMFileName));
fclose(fid);

fid=fopen(fullfile(TieStemBasePathName, TieStemBaseFileName), 'r');
TieStemBase=textscan(fid, '%f %f %f %f %f %f %f %f %f %f');
fclose(fid);
if any(isnan(TieStemBase{9}))
    errordlg('No matched feature points in the input file!', 'Registration Failed!', 'modal');
    coarseR3D = [];
    coarseT3D = [];
    EA3D = [];
    distrms3D = [];
    return;
end
TieStemBase=cell2mat(TieStemBase(:, 1:8));

datap = TieStemBase(:, 1:3);
modelp = TieStemBase(:, 5:7);
if usez
    [coarseR3D, coarseT3D, EA3D, distrms3D, exitflag] = lsqTM(modelp, ...
                                                      datap, [], [], ...
                                                      []);
else
    [coarseR3D, coarseT3D, EA3D, distrms3D, exitflag] = lsqTM2D(modelp(:, 1:2), ...
                                                      datap(:, 1:2), [], [], ...
                                                      []);
end
fprintf('exitflag: %d\n', exitflag);
dlmwrite(fullfile(TMPathName, TMFileName), [coarseR3D, coarseT3D; 0.0, 0.0, 0.0, 1.0], 'delimiter', '\t', 'precision', '%.9f', 'newline', 'pc');

EA3D = EA3D*180/pi;
fid=fopen(fullfile(TMPathName, ParameterFileName), 'a');
fprintf(fid, '\r\n\r\nOffset along X\tOffset along Y\tOffset along Z\r\n%.3f\t%.3f\t%.3f\r\nroll(degree, rotation about X)\tpitch(degree, rotation about Y)\tyaw(degree, rotation about Z)\tRMS_of_Dist(meter)\r\n%.3f\t%.3f\t%.3f\t%.3f', ...
    coarseT3D(1), coarseT3D(2), coarseT3D(3), EA3D(1), EA3D(2), EA3D(3), distrms3D);
fclose(fid);

% % Debug
% % output registration information to a summary file.
% fid=fopen([OutDir, '\Summary_FcnRegistration5CalTMbySB.txt'], 'a');
% % fprintf(fid, 'year-month-day-hour-minute-seconds\tTieStemBasePathName\tTieStemBaseFileName\tPointPairNum\tRMSDist2D\tRMSDist3D\r\n');
% fprintf(fid, '%d-%d-%d-%d-%d-%d\t%s\t%s\t%d\t%.6f\t%.6f\r\n', fix(clock), TieStemBasePathName, TieStemBaseFileName, size(datap, 1), distrms2D, distrms3D);
% fclose(fid);
% % End of debug

end
