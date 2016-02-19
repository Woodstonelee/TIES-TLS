% % parameters needed to be set beforehand

% ScanPtsPathName='';
% ScanPtsFileName='';
% InPtsPathName='';
% InPtsFileName='';

fprintf('ScanPtsPathName to be processed: %s\n', ScanPtsPathName);
fprintf('ScanPtsFileName to be processed: %s\n', ScanPtsFileName);
fprintf('InPtsPathName for the following scripts: %s\n', InPtsPathName);
fprintf('InPtsFileName for the following scripts: %s\n', InPtsFileName);

fid = fopen(fullfile(ScanPtsPathName, ScanPtsFileName));
data = textscan(fid, repmat('%f', 1, 19), 'HeaderLines', 3, 'Delimiter', ',');
fclose(fid);
data = cell2mat(data);
% data = csvread(fullfile(ScanPtsPathName, ScanPtsFileName), 1, 0);
x = data(:, 1);
y = data(:, 2);
z = data(:, 3);
num_returns = data(:, 7);
% class = data(:, 24);
clear data;

% remove zero-hit points
tmpflag = num_returns > 0;
x = x(tmpflag);
y = y(tmpflag);
z = z(tmpflag);
% class = class(tmpflag);

% use only woody points
% tmpflag = class == 1;
% x = x(tmpflag);
% y = y(tmpflag);
% z = z(tmpflag);
% class = class(tmpflag);

fid = fopen(fullfile(InPtsPathName, InPtsFileName), 'w');
fprintf(fid, '%f\t%f\t%f\n', ([x, y, z])');
fclose(fid);

fprintf('Script1_CvtPtsFmt finished!\n');

clear x y z;
