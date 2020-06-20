function execute(script_name)
try
    syslog(strcat("Running  ",script_name))
    eval(script_name)
catch ME
    disp(ME)
    disp(struct2table(ME.stack))
    syslog('Exiting script.','x')
end
return
end
