function s = string_date_time()
    % return the date and time as an string separated with underscores
    %
    % Credit: Keivan Hassani Monfared, k1monfared@gmail.com
    
    [y,mo,d] = ymd(datetime);
    [h,m,s] = hms(datetime);
    s = [ num2str(y) '_' num2str(mo) '_' num2str(d) '_' num2str(h) '_' num2str(m) '_' num2str(floor(s)) ];
end