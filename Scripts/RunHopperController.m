%%


ProcessIdentifier = 'DEBUG-h2go';
pathToPoolProfile = '\\abyss1\active_projects\Hopper_Dev\dev-xavier\Hopper\Cloud_Cluster_Profile.settings';

jsonDir = 'Y:\Hopper_Dev\dev-xavier\ToolsDebug\h2go\';
jsonCommand = struct;
jsonCommand.MethodToUse = 'JSONINIT';
jsonCommand.MethodParameters = fullfile(jsonDir,'jsonString_local.json');
jsonCommand = jsonencode(jsonCommand);
disp(jsonCommand)

HopperController(ProcessIdentifier, pathToPoolProfile, jsonCommand)
