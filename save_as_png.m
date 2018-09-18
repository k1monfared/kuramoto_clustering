function save_as_png(handle, filename, dpi, width, height)
    % save a figure handle as png with given parameters
    
    set(handle, 'PaperUnits', 'inches', 'PaperPosition', [0 0 width height] / dpi);
    print(handle, '-dpng', ['-r' num2str(dpi)], filename);
end