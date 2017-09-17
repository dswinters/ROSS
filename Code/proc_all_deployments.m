function Vessels = proc_all_deployments(Vessels)

for nves = 1:length(Vessels)
    fprintf('\n* %s deployments\n',Vessels(nves).name);
    for ndep = 1:length(Vessels(nves).deployments)
        fprintf('\n** %s\n',Vessels(nves).deployments(ndep).name);
        Vessels(nves).deployments(ndep) = ...
            proc_deployment(Vessels(nves).deployments(ndep));
    end
end

