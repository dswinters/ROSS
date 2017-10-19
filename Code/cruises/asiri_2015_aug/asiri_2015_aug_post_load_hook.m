function [dep, adcp, gps] = asiri_2015_aug_post_load_hook(dep,adcp,gps)

%% Apply time offsets to ADCP clocks
switch dep.name
  case 'Deploy1' ; time_offset=0;
  case 'Deploy2' ; time_offset=0;
  case 'Deploy3' ; time_offset=-13/86400 ;
  case 'Deploy4' ; time_offset=-16/86400 ;
  case 'Deploy5' ; time_offset=-16/86400 ;
  case 'Deploy6' ; time_offset=-22/86400 ;
end
adcp.mtime = adcp.mtime + time_offset;

