function [DEP, adcp] = leconte_2017_sep_pre_rotation_hook(DEP,adcp)

switch DEP.vessel.name
  case 'Swankie'
    % Set BT values to data from BT profile files
  case 'Steller'
    if checkfield(DEP.proc,'diagnostic')
        adcp.config.xducer_misalign = 0;
        DEP.proc.ship_vel_removal = 'none';
    end
end


