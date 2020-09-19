function titleabove(mytitle)
% if using MAtlab < 2018a, sgtitle not available
% mtit found on file exchange
% fallback case = normal title function
try
    sgtitle(mytitle)
catch
    try
        mtit(mytitle)
    catch
        title(mytitle)
    end
end

return
end