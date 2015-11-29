function Fcn_StemBases(StemLinePathName, StemLineFileName, ...
    DEMPathName, DEMFileName, ...
    StemBasePathName, StemBaseFileName)
% Registration, step 3, calculate the intersection of stem line and DEM
% that is used as the base point of stems. And output the intersection
% point to a text file. 
% SYNTAX: Fcn_StemBases(StemLinePathName, StemLineFileName, ...
%     DEMPathName, DEMFileName, ...
%     StemBasePathName, StemBaseFileName)
% INPUT:
%   1. StemLinePathName, StemLineFileName: Text files of fitted lines of stems. (FittedStemLine_)
%       Format: 
%       m, n, p, x0, y0, z0, TreeNO, number_of_stem_centers_in_fitting_line_finally
%       ([m, n, p] is direction of line, [x0, y0, z0] is coordinates of one
%       point on line)
%   2. DEMPathName, DEMFileName: Text file of DEM derived from the lowest
%       points. 
%           File format: (EXAMPLE)
%          "ncols         181
%           nrows         181
%           xllcorner     -90.496391
%           yllcorner     -86.518433
%           cellsize      1
%           NODATA_value  -9999
%           [nrows by ncols matrix]"
%   3. StemBasePathName, StemBaseFileName: Text file for outputting stem
%   bases. 
%       File format:
%       #1: 'x, y, z, TreeNO'
%       #2-#end: x, y, z, TreeNO
% OUTPUT:
% REQUIRED ROUTINES:
% METHODS AND PROCESS: 

ParameterFileName=['Parameters_Fcn_StemBases_', StemBaseFileName];
fid=fopen(fullfile(StemBasePathName, ParameterFileName), 'w');
fprintf(fid, [...
    'the input stem line file: %s\r\n', ...
    'the DEM file: %s\r\n' ...
    'the output file for stem base: %s' ...
    ], ...
    fullfile(StemLinePathName, StemLineFileName), ...
    fullfile(DEMPathName, DEMFileName), ...
    fullfile(StemBasePathName, StemBaseFileName));
fclose(fid);

% ---read from stem line file---
fid=fopen(fullfile(StemLinePathName, StemLineFileName), 'r');
stemline=textscan(fid, '%f %f %f %f %f %f %f %f');
stemline=cell2mat(stemline);
fclose(fid);

% ---read from DEM file.---
demfid=fopen(fullfile(DEMPathName, DEMFileName), 'r');
data=textscan(demfid, '%s %f', 6);
deminfo=data{1, 2};
formatstr=ones(1, deminfo(1)*3);formatstr=char(formatstr);
for i=1:deminfo(1)
    formatstr((i*3-2):(i*3))='%f ';
end
data=textscan(demfid,formatstr);
dem=cell2mat(data);
dem=flipud(dem);
fclose(demfid);

numstem = size(stemline, 1);
StemBase = zeros(numstem, 4);
for count=1:numstem
    m=stemline(count,1);n=stemline(count,2);p=stemline(count,3);
    x0=stemline(count,4);y0=stemline(count,5);z0=stemline(count,6);
    if m==0 
        if n==0 % m=0 and n=0 means that the line is perpendicular to the xoy plane.
            xpix = fix( ( x0 - deminfo(3) ) / deminfo(5) ) + 1;
            ypix = fix( ( y0 - deminfo(4) ) / deminfo(5) ) + 1;
            if dem(ypix, xpix)==deminfo(6) % the grid has no height value.
                % delete this line due to no accurate ground position.
                StemBase(count, :) = [ NaN, NaN, NaN, stemline(count, 7) ];
                % debug
                fprintf('No accurate ground position\n');
                % debug
            else
                StemBase(count, :) = [ x0, y0, dem(ypix, xpix), stemline(count, 7) ]; 
            end
            continue;
        else
            ypix=1:1:deminfo(2);
            xpix = ( fix( ( x0 - deminfo(3) ) / deminfo(5) ) + 1 ) * ones(size(ypix));
            ymap= (ypix-ones(size(ypix)) + 0.5 )*deminfo(5) + deminfo(4)*ones(size(ypix));
            t = (ymap - y0*ones(size(ymap)))/n;
            zmap = z0*ones(size(xmap)) + p*t;
            tempindex = true(size(ypix));
        end
    else
        if abs(n/m)<=1
            xpix=1:1:deminfo(1);
            xmap= (xpix-ones(size(xpix)) + 0.5 )*deminfo(5) + deminfo(3)*ones(size(xpix));
            t = (xmap - x0*ones(size(xmap)))/m;
            ymap = y0*ones(size(xmap)) + n*t;
            zmap = z0*ones(size(xmap)) + p*t;
            ypix = fix( ( ymap - deminfo(4)*ones(size(ymap)) ) / deminfo(5) ) + ones(size(ymap));
            tempindex = ypix >=1 & ypix <= deminfo(2);
        else
            ypix=1:1:deminfo(2);
            ymap= (ypix-ones(size(ypix)) + 0.5 )*deminfo(5) + deminfo(4)*ones(size(ypix));
            t = (ymap - y0*ones(size(ymap)))/n;
            xmap = x0*ones(size(ymap)) + m*t;
            zmap = z0*ones(size(ymap)) + p*t;
            xpix = fix( ( xmap - deminfo(3)*ones(size(xmap)) ) / deminfo(5) ) + ones(size(xmap));
            tempindex = xpix >=1 & xpix <= deminfo(1);
        end
    end
    
    zdem = dem(sub2ind([deminfo(2), deminfo(1)], ypix(tempindex), xpix(tempindex)));
    validzindex = zdem~=deminfo(6);
    zdem = zdem(validzindex);
    if length(zdem)<1 % no valid height value
        % delete this line due to no accurate ground position.
        StemBase(count, :) = [ NaN, NaN, NaN, stemline(count, 7) ];
        % debug
        fprintf('No accurate ground position\n');
        % debug
    else
        % -----------------------------------------------------------------
        % code of original version
%         zmap = zmap(tempindex); zmap = zmap(validzindex);
%         tempdiff = abs( zdem - zmap );
%         tempsub = find( tempdiff==min(tempdiff) );
%         if length(tempsub)>1
%             tempz = mean(zdem(tempsub));
%             t = ( tempz - z0 ) / p;
%             StemBase(count, :) = [ x0+m*t, y0+n*t, tempz, stemline(count, 7) ];
%         else
%             t = ( zdem(tempsub) - z0 ) / p;
%             StemBase(count, :) = [ x0+m*t, y0+n*t, zdem(tempsub), stemline(count, 7) ];        
%         end
        % -----------------------------------------------------------------
        
        % -----------------------------------------------------------------
        % revision on June 30, 2011, by Zhan Li
        zmap = zmap(tempindex); zmap = zmap(validzindex);
        tempdiff = zmap - zdem;
        % the intersection must be found from those zmap greater than zdem,
        % i.e. above the ground rather than below the ground (zmap < zdem)
        tempdiff = tempdiff( tempdiff>=0 );
        if isempty(tempdiff)
            % delete this line due to the whole stem line below the ground.
            StemBase(count, :) = [ NaN, NaN, NaN, stemline(count, 7) ];
            % debug
            fprintf('The whole stem line is below the ground in the DEM extent, possibly due to inaccurate DEM\n');
            % debug
        else
            tempsub = find( tempdiff==min(tempdiff) );
            if length(tempsub)>1
                tempz = mean(zdem(tempsub));
                t = ( tempz - z0 ) / p;
                StemBase(count, :) = [ x0+m*t, y0+n*t, tempz, stemline(count, 7) ];
            else
                t = ( zdem(tempsub) - z0 ) / p;
                StemBase(count, :) = [ x0+m*t, y0+n*t, zdem(tempsub), stemline(count, 7) ];        
            end 
        end
        % -----------------------------------------------------------------
        
    end    
end

% delete those rows with NaN, i.e. stem line without finding accurate
% ground position.
tempindex = ~isnan(StemBase(:, 3));
StemBase = StemBase(tempindex, :);

fid=fopen(fullfile(StemBasePathName, StemBaseFileName), 'w');
fprintf(fid, '%s\r\n', 'x, y, z, TreeNO');
fclose(fid);
dlmwrite(fullfile(StemBasePathName, StemBaseFileName), StemBase, '-append', 'delimiter', ',', 'precision', 6, 'newline', 'pc');

end