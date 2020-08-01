%%
thisdir = 'C:\wrk\Rheem\Phase 2 Analysis\Phase1Models';
mydir = dir(thisdir);
%%
str2replace = {};
str2replace(end+1,:) = {'OD30','OD'};
str2replace(end+1,:) = {'ID30','ID'};

% str2replace(end+1,:) = {'Mic 1','M1'};
% str2replace(end+1,:) = {'Mic 2','M2'};
% str2replace(end+1,:) = {'Mic 3','M3'};
% str2replace(end+1,:) = {'COMPR_SHELL_ACCEL','A1'};
% str2replace(end+1,:) = {'COMPR_DISCHARGE_ACCEL','A2'};
% str2replace(end+1,:) = {'FAN_MOTOR_ACCEL','A3'};
% str2replace(end+1,:) = {'OD 30%','OD30'};
% str2replace(end+1,:) = {'ID 30%','ID30'};
% str2replace(end+1,:) = {'RefrigerantCharge','CHRG'};
% str2replace(end+1,:) = {'MultiClass','MULTI'};
% str2replace(end+1,:) = {'BaseModel',''};
% str2replace(end+1,:) = {'(',''};
% str2replace(end+1,:) = {')',''};
% str2replace(end+1,:) = {' ','_'};
%%
for ii=1:length(mydir)
    
    [~,fn,ext] = fileparts(mydir(ii).name);
    if not(contains(ext,'mat'));continue;end
    
    src = fullfile(mydir(ii).folder,mydir(ii).name);
    dst_fn = fn;
    
    for jj=1:size(str2replace,1)
         dst_fn = strrep(dst_fn,str2replace{jj,1},str2replace{jj,2});
    end
    if strcmp(dst_fn(end),'_'); dst_fn = dst_fn(1:end-1); end
    
    dst = fullfile(mydir(ii).folder,[dst_fn ext]);
    if isfile(dst); continue; end
    
    movefile(src,dst)
    
end
