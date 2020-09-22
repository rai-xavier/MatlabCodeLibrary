function varargout = dock(varargin)
if TerminalMode;    varargout{1} = [];;return;     end

try
    if nargin>=1
        switch length(varargin)
            case 1
                if isnumeric(varargin{1})
                    fignum = varargin{1};
                    f = figure(fignum);
                elseif ischar(varargin{1})
                    figname = varargin{1};
                    f = figure();
                    set(f,'Name',figname,'NumberTitle','off');
                elseif isa(varargin{1},'matlab.ui.Figure')
                    f = varargin{1};
                end
                
            case 2
                fignum = varargin{1};
                figname = varargin{2};
                f = figure(fignum);
                set(f,'Name',figname,'NumberTitle','off');
        end
    else
       f = figure();        
    end
        
    
    set(f,'WindowStyle','docked');
    drawnow
%     if logical(nargout); 
        varargout{1} = f;
%         else; varargout{end
catch ME
	varargout{1} = [];
    showstack(ME)

end
return
end
