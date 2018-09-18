function hpol = kuramoto_polar(varargin)
    %POLAR  Polar coordinate plot.
    %   POLAR(THETA, RHO) makes a plot using polar coordinates of
    %   the angle THETA, in radians, versus the radius RHO.
    %   POLAR(THETA, RHO, S) uses the linestyle specified in string S.
    %   See PLOT for a description of legal linestyles.
    %
    %   POLAR(AX, ...) plots into AX instead of GCA.
    %
    %   H = POLAR(...) returns a handle to the plotted object in H.
    %
    %   Example:
    %      t = 0 : .01 : 2 * pi;
    %      polar(t, sin(2 * t) .* cos(2 * t), '--r');
    %
    %   See also POLARPLOT, PLOT, LOGLOG, SEMILOGX, SEMILOGY.
    
    %   Copyright 1984-2015 MathWorks, Inc.
    %
    % Edited: Keivan Hassani Monfared, k1monfared@gmail.com
    
    
    % Parse possible Axes input
    [gca, args, nargs] = axescheck(varargin{:});
    
    % Error if given uiaxes
    if isa(gca,'matlab.ui.control.UIAxes')
        error(message('MATLAB:ui:uiaxes:general'));
    end

    if nargs < 1
        error(message('MATLAB:narginchk:notEnoughInputs'));
    elseif nargs > 3
        error(message('MATLAB:narginchk:tooManyInputs'));
    end
    
    if nargs < 1 || nargs > 3
        error(message('MATLAB:polar:InvalidDataInputs'));
    elseif nargs == 2
        theta = args{1};
        rho = ones(1,length(theta));
        if ischar(rho)
            line_style = 'o';
            rho = ones(size(theta));
            [mr, nr] = size(rho);
            if mr == 1
                theta = 1 : nr;
            else
                th = (1 : mr)';
                theta = th(:, ones(1, nr));
            end
        else
            line_style = 'o';
        end
    elseif nargs == 1
        theta = args{1};
        line_style = 'o';
        rho = ones(size(theta));
%         [mr, nr] = size(rho);
%         if mr == 1
%             theta = 1 : nr;
%         else
%             th = (1 : mr)';
%             theta = th(:, ones(1, nr));
%         end
    else % nargs == 3
        [theta, rho, line_style] = deal(args{1 : 3});
    end
    if ischar(theta) || ischar(rho)
        error(message('MATLAB:polar:InvalidInputType'));
    end
    if ~isequal(size(theta), size(rho))
        error(message('MATLAB:polar:InvalidInputDimensions'));
    end
    
    % get hold state
    gca = newplot(gca);
    
    next = lower(get(gca, 'NextPlot'));
    hold_state = ishold(gca);

    if isa(handle(gca),'matlab.graphics.axis.PolarAxes')
        error(message('MATLAB:polar:PolarAxes'));
    end
    
    % get x-axis text color so grid is in same color
    % get the axis gridColor
    axColor = get(gca, 'Color');
    gridAlpha = get(gca, 'GridAlpha');
    axGridColor = get(gca,'GridColor').*gridAlpha + axColor.*(1-gridAlpha);
    tc = axGridColor;
    ls = get(gca, 'GridLineStyle');
    
    % Hold on to current Text defaults, reset them to the
    % Axes' font attributes so tick marks use them.
%     fAngle = get(gca, 'DefaultTextFontAngle');
%     fName = get(gca, 'DefaultTextFontName');
%     fSize = get(gca, 'DefaultTextFontSize');
%     fWeight = get(gca, 'DefaultTextFontWeight');
%     fUnits = get(gca, 'DefaultTextUnits');
    set(gca, ...
        'DefaultTextFontAngle', get(gca, 'FontAngle'), ...
        'DefaultTextFontName', get(gca, 'FontName'), ...
        'DefaultTextFontSize', get(gca, 'FontSize'), ...
        'DefaultTextFontWeight', get(gca, 'FontWeight'), ...
        'DefaultTextUnits', 'data');
    
    % only do grids if hold is off
    if ~hold_state
        
        % make a radial grid
        hold(gca, 'on');
        % ensure that Inf values don't enter into the limit calculation.
        arho = abs(rho(:));
        maxrho = max(arho(arho ~= Inf));
        hhh = line([-maxrho, -maxrho, maxrho, maxrho], [-maxrho, maxrho, maxrho, -maxrho], 'Parent', gca);
        set(gca, 'DataAspectRatio', [1, 1, 1], 'PlotBoxAspectRatioMode', 'auto');
        v = [get(gca, 'XLim') get(gca, 'YLim')];
        ticks = sum(get(gca, 'YTick') >= 0);
        delete(hhh);
        % check radial limits and ticks
        rmin = 0;
        rmax = v(4);
        rticks = max(ticks - 1, 2);
        if rticks > 5   % see if we can reduce the number
            if rem(rticks, 2) == 0
                rticks = rticks / 2;
            elseif rem(rticks, 3) == 0
                rticks = rticks / 3;
            end
        end
        
        % define a circle
        th = 0 : pi / 50 : 2 * pi;
        xunit = cos(th);
        yunit = sin(th);
        % now really force points on x/y axes to lie on them exactly
        inds = 1 : (length(th) - 1) / 4 : length(th);
        xunit(inds(2 : 2 : 4)) = zeros(2, 1);
        yunit(inds(1 : 2 : 5)) = zeros(3, 1);
        % plot background if necessary
        if ~ischar(get(gca, 'Color'))
            patch('XData', xunit * rmax, 'YData', yunit * rmax, ...
                'EdgeColor', tc, 'FaceColor', get(gca, 'Color'), ...
                'HandleVisibility', 'off', 'Parent', gca);
        end
        
        % draw radial circles
%         c82 = cos(82 * pi / 180);
%         s82 = sin(82 * pi / 180);
%         rinc = (rmax - rmin) / rticks;
        for i = 1:1%(rmin + rinc) : rinc : rmax
            hhh = line(xunit * i, yunit * i, 'LineStyle', ls, 'Color', tc, 'LineWidth', 1, ...
                'HandleVisibility', 'off', 'Parent', gca);
%             text((i + rinc / 20) * c82, (i + rinc / 20) * s82, ...
%                 ['  ' num2str(i)], 'VerticalAlignment', 'bottom', ...
%                 'HandleVisibility', 'off', 'Parent', gca);
        end
        set(hhh, 'LineStyle', '-'); % Make outer circle solid
        
        % plot spokes
        th = (1 : 6) * 2 * pi / 12;
        cst = cos(th);
        snt = sin(th);
        cs = [-cst; cst];
        sn = [-snt; snt];
        line(rmax * cs, rmax * sn, 'LineStyle', ls, 'Color', tc, 'LineWidth', 1, ...
            'HandleVisibility', 'off', 'Parent', gca);
        
%         % annotate spokes in degrees
%         rt = 1.1 * rmax;
%         for i = 1 : length(th)
%             text(rt * cst(i), rt * snt(i), int2str(i * 30),...
%                 'HorizontalAlignment', 'center', ...
%                 'HandleVisibility', 'off', 'Parent', gca);
%             if i == length(th)
%                 loc = int2str(0);
%             else
%                 loc = int2str(180 + i * 30);
%             end
%             text(-rt * cst(i), -rt * snt(i), loc, 'HorizontalAlignment', 'center', ...
%                 'HandleVisibility', 'off', 'Parent', gca);
%         end
        
        % set view to 2-D
        view(gca, 2);
        % set axis limits
        axis(gca, rmax * [-1, 1, -1.15, 1.15]);
    end
    
%     % Reset defaults.
%     set(gca, ...
%         'DefaultTextFontAngle', fAngle , ...
%         'DefaultTextFontName', fName , ...
%         'DefaultTextFontSize', fSize, ...
%         'DefaultTextFontWeight', fWeight, ...
%         'DefaultTextUnits', fUnits );
%     
    % transform data to Cartesian coordinates.
    xx = rho .* cos(theta);
    yy = rho .* sin(theta);

    % plot data on top of grid
    q = plot(xx, yy, line_style, 'Parent', gca, 'MarkerSize', 10, 'LineWidth',1.5);
    
    if nargout == 1
        hpol = q;
    end
    
    if ~hold_state
        set(gca, 'DataAspectRatio', [1, 1, 1]), axis(gca, 'off');
        set(gca, 'NextPlot', next);
    end
    set(get(gca, 'XLabel'), 'Visible', 'on');
    set(get(gca, 'YLabel'), 'Visible', 'on');
    
    if ~isempty(q) && ~isdeployed
        makemcode('RegisterHandle', gca, 'IgnoreHandle', q, 'FunctionName', 'polar');
    end
end
