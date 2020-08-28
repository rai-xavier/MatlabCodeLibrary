function mylog = mycat(varargin)
mylog = {};
for ii=1:length(varargin)
    mytype = varargin{ii};
    if ischar(varargin{ii})
        mylog{ii} = varargin{ii};
    elseif isnumeric(varargin{ii})
        mylog{ii} = num2str(varargin{ii});
    else
        warning(['datatype not supported by mycat: ' class(varargin{ii})])
        return
    end
end
mylog = char(join(mylog, ' '));
return
end