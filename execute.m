function execute(script_name,varargin)
try
    syslog(strcat("Running  ",script_name))
    for jj=1:2:length(varargin)
        define_var_string = strcat(varargin{jj}, " = ");
        myclass = class(varargin{jj+1});
        switch myclass
            case 'double'
                if length(varargin{jj+1}) ==1
                    define_var_string = strcat(define_var_string , string(varargin{jj+1}), ";");
                else
                    define_var_string = strcat(define_var_string , "[", join(string(1:3)," "),"]", ";");
                end
        end
        
        syslog(define_var_string);
        eval(define_var_string)
    end
    eval(script_name)
catch ME
    disp(ME)
    disp(struct2table(ME.stack))
    syslog('Exiting script.','x')
end
return
end
