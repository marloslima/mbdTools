% ----
% Author  : Marlos Lima de O. Cunha (MLOCUNH / marlos.lima)
% Date    : 30th January 2023
% URL     : https://github.com/marloslima/mbdTools
% License : MIT License
% --
% How to use:
% 1) Select a block in a model
% 2) Call the function via Command Window: alignBlocksViaPortHandle_gcb()
% --
% Description:
% 1) Inputs, Outputs:
% - No input is expected by the function. Also, no data is outputted from
% the function.
% --
% This function will align two blocks, using their Port Handle Position 
% properties, so that a line conectting both blocks will be a 
% "straight line".
% ----

function alignBlocksViaPortHandle_gcb()

% Uses "gcb" to identify the currently selected block in the model.
currBlk = gcb;

% currBlk's height and length shall be kept unchanged after changing its
% location in the model.
currBlk_Pos     = get_param(currBlk, 'Position');
currBlk_height  = currBlk_Pos(4) - currBlk_Pos(2);
currBlk_length  = currBlk_Pos(3) - currBlk_Pos(1);

% Gets the Port Handle of "currBlk":
currBlk_PHs = get_param(currBlk, 'PortHandles');

currBlk_hasInPH     = ~isempty(currBlk_PHs.Inport);
currBlk_hasOutPH    = ~isempty(currBlk_PHs.Outport);

if currBlk_hasInPH && currBlk_hasOutPH
    % Do nothing.
    return
elseif currBlk_hasInPH
    portHandleType = 'Inport';
    linePortHandle = 'SrcPortHandle';
else
    portHandleType = 'Outport';
    linePortHandle = 'DstPortHandle';
end

% currBlk's Port Handle to be used for alignment purposes:
currBlk_PH = get_param(currBlk, 'PortHandles').(portHandleType);

% A way to get information about the block to which 'currBlk' is connected
% to is via the connecting line between both of them - remember that we
% wish to have a 'straight line connection' between both blocks.
% 'currBlk'      <---connecting line----> 'referenceBlk'
% 'referenceBlk' <---connecting line----> 'currBlk'

% Gets the Handle of the line connecting both blocks:
connectingLine  = get_param(currBlk_PH, 'Line');
referenceBlk_PH = get_param(connectingLine, linePortHandle);

% Gets 'Position' information from the 'referenceBlk'
referenceBlk_PH_Pos = get_param(referenceBlk_PH, 'Position');

% We will use the Port Handle position from 'referenceBlk' as a reference
% value for the alignment of 'currBlk'. Note that the 'Port Handle
% Position' of a given block is located at its height/2 (middle height).
currBlk_newYPos = referenceBlk_PH_Pos(2) - currBlk_height/2;

% Modifies the position of 'currBlk', aligning its 'port handle position'
% to the 'port handle position' of the block it is connecting to.
set_param(gcb, 'Position', [currBlk_Pos(1) currBlk_newYPos ...
    currBlk_length+currBlk_Pos(1) currBlk_height+currBlk_newYPos]);

end