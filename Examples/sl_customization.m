% ----
% Author  : Marlos Lima de O. Cunha (MLOCUNH / marlos.lima)
% Date    : 30th January 2023
% URL     : https://github.com/marloslima/mbdTools
% License : MIT License
% --
% This is an initial example of how to add a custom function to a 
% right-mouse-click menu inside simulink environment.
% --

function sl_customization(cm)

  %% Register custom menu function.
  cm.addCustomMenuFcn('Simulink:ContextMenu', @getCtxtMenuPlugins);
end

%% Define the custom menu function.
function schemaFcns = getCtxtMenuPlugins(callbackInfo) 
  schemaFcns = { @schMBDTools }; 
end

%% Define the schema function for first menu item. 
function schema = schMBDTools(callbackInfo)
  schema                = sl_container_schema;
  schema.label          = 'MBD Tools';
  schema.childrenFcns   = {@schMenu1};
end


function schema = schMenu1(callbackInfo)
  schema                = sl_action_schema;
  schema.label          = 'Align selected blocks via Port Handle';
  schema.accelerator    = 'Shift+Alt+A';
  schema.callback       = @pluginCallback; 
end

function pluginCallback(callbackInfo)
  alignBlocksViaPortHandle()
end