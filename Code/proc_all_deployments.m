function Vessels = proc_all_deployments(Vessels)

for nves = 1:length(Vessels)
    fprintf('\n* %s deployments\n',Vessels(nves).name);
    for ndep = 1:length(Vessels(nves).deployment)
        fprintf('\n** %s\n',Vessels(nves).deployment(ndep).name);
        try
            Vessels(nves).deployment(ndep) = ...
                proc_deployment(Vessels(nves).deployment(ndep));
        catch err
            disp(sprintf('Skipped %s',Vessels(nves).deployment(ndep).name))
        end
    end
end

