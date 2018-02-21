function [DEP, adcp] = leconte_2017_sep_pre_rotation_hook(DEP,adcp)

switch DEP.vessel.name
  case 'Swankie'
    if isfield(adcp.config,'heading_cal_coeffs')
        adcp.heading = ...
            adcp.config.heading_cal_func(adcp.config.heading_cal_coeffs,...
                                         adcp.heading_internal);
        adcp.info = cat(1,adcp.info,{'Using calibrated ADCP compass as heading source'});
    end
end

