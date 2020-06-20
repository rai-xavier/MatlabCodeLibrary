function execute(script_name)
try
    syslog(strcat("Running  ",script_name))
    evalc(script_name)
catch ME
    disp(ME)
    disp(struct2table(ME.stack))
    exit
end
return
end
