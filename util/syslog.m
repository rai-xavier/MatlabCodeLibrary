function syslog(log_statement, varargin)
formatOut = 'mm/dd/yy HH:MM';
timestamp = datestr(now,formatOut);
warning('off','all')
timestamp = datetime(timestamp,'TimeZone','EST');
warning('on','all')
timestamp = char(timestamp);

if not(isempty(varargin))
    log_type = varargin{1};
    if isnumeric(log_type)
        log_type = num2str(log_type);
    else
        log_type = upper(varargin{1});
        if strcmp(log_type, 'L')
            log_type = 'LOG';
        elseif strcmp(log_type,'P')
            log_type = 'PATH';
        elseif strcmp(log_type,'S')
            log_type = 'SAVE';
        elseif strcmp(log_type,'W')
            log_type = 'WARNING';
        elseif strcmp(log_type,'E')
            log_type = 'ERROR';
        elseif strcmp(log_type,'X')
            log_type = 'EXIT';
        elseif strcmp(log_type,'T')
            log_type = 'TIMER';
        else
            log_type = 'UNRECOGNIZED';
        end
    end
else
    log_type = 'LOG';
end

s = " ";
full_log_statement = strcat(timestamp, s, '(', log_type, ')', s, log_statement);
disp(full_log_statement)

if TerminalMode & strcmp(log_type,'EXIT'); exit; end
return
end