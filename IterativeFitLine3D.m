function [direction, onepoint, IterInfo, validsub] = IterativeFitLine3D(x, y, z, epsion, minnumpoint)
    % Fit line by iteratively calling FitLine. 
    if length(x)<minnumpoint
        direction=NaN(1,3);
        onepoint=NaN(1,3);
        IterInfo = [0, length(x), Inf];
        validsub = [];
        return;
    end
    RMSE=Inf;
    count=0;
    validx=x;
    validy=y;
    validz=z;
    maxErrIndex = false(size(validx));
    validsub = (1:1:length(x))';
    
    while RMSE>epsion
        validx=validx(~maxErrIndex);
        validy=validy(~maxErrIndex);
        validz=validz(~maxErrIndex);
        validsub=validsub(~maxErrIndex);
        if (length(validx)<minnumpoint)
            direction=NaN(1,3);
            onepoint=NaN(1,3);
            IterInfo = [count, length(validx), RMSE];
            validsub = [];
            return;
        end
        [direction, onepoint] = FitLine3D(validx, validy, validz);
        m=direction(1);n=direction(2);p=direction(3);
        x0=ones(size(validx))*onepoint(1);y0=ones(size(validy))*onepoint(2);z0=ones(size(validz))*onepoint(3);       
        t=( m*(validx-x0)+n*(validy-y0)+p*(validz-z0) )./(m*m+n*n+p*p);
        squareErr =  (x0+m*t-validx).^2 + (y0+n*t-validy).^2 + (z0+p*t-validz).^2 ;
        RMSE = sqrt(mean(squareErr));
        maxErrIndex = squareErr==max(squareErr);
        count=count+1;
    end
    
    IterInfo = [count, length(validx), RMSE];
    
end

function [direction, onepoint] = FitLine3D(x, y, z)
    % Fit line in 3D space by minimizing the sum of square of distance from
    % each point to the fit line. 
    errFcn=PkBgErr(x,y,z);
    estParams = [0, 0, 1; mean(x), mean(y), mean(z)];
    fitParams = lsqnonlin(errFcn,estParams);
    direction = fitParams(1,:);
    onepoint = fitParams(2,:);
end

function h = PkBgErr(x,y,z) %PKBGERR returns function handle.
    h = @errFcn;
    function err = errFcn(param) %nested
        sizeparam=size(param);
        if sizeparam(2)~=3 || sizeparam(1)~=2
            error('PkBgErr, size of estParams is wrong!');
        end
        m=param(1,1);n=param(1,2);p=param(1,3);
        x0=ones(size(x))*param(2,1);y0=ones(size(y))*param(2,2);z0=ones(size(z))*param(2,3);       
        
        t=( m*(x-x0)+n*(y-y0)+p*(z-z0) )./(m*m+n*n+p*p);
               
        err = sqrt( (x0+m*t-x).^2 + (y0+n*t-y).^2 + (z0+p*t-z).^2 );
        
    end %nested function
end

