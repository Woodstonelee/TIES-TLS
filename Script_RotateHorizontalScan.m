% Preprocess China Culai horizontally scannning data. Rotate the z axis to
% the zenith. 

% HSDataPathName = '/net/casfsb.bu.edu/vol/Data13/zhanli86/AutoRegLiDAR/ChinaCulai';
% HSDataFileName = 'cl101603hs01Scan001.txt';
% RotateDataPathName = '/net/casfsb.bu.edu/vol/Data13/zhanli86/AutoRegLiDAR/ChinaCulai';
% RotateDataFileName = 'cl101603hs01Scan001_Rotate.txt';

fprintf('Start script:\n')
% read in horizontally scanning data.
data = dlmread(fullfile(HSDataPathName, HSDataFileName));
% x = data(:, 1);
% y = data(:, 2);
% z = data(:, 3);
% clear data;

R = [0, 0, 1; ...
     0, 1, 0; ...
     -1, 0, 0];
data = R*data';

fid = fopen(fullfile(RotateDataPathName, RotateDataFileName), 'w');
fprintf(fid, '%.6f\t%.6f\t%.6f\n', data);
fclose(fid);

fprintf(['Finished: ', fullfile(HSDataPathName, HSDataFileName), '\n']);

exit
