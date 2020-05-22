function syslog(log_statement, varargin)
formatOut = 'mm/dd/yy HH:MM';
timestamp = datestr(now,formatOut);

if not(isempty(varargin))
    log_type = varargin{1};
    if isnumeric(log_type)
        log_type = num2str(log_type);
    else
        log_type = upper(varargin{1});
        if contains(log_type, 'L')
            log_type = 'LOG';
        elseif contains(log_type,'S')
            log_type = 'SAVE';
        elseif contains(log_type,'W')
            log_type = 'WARNING';
        elseif contains(log_type,'E')
            log_type = 'ERROR';
        else
            log_type = 'UNRECOGNIZED';
        end
    end
else
    log_type = 'LOG';
end

log_statement = [timestamp ' (' log_type ') ' log_statement];
disp(log_statement)

return
end