function Config = proc_all_deployments(Config)

for nves = 1:length(Config)
    fprintf('\n* %s deployments\n',Config(nves).name);
    for ndep = 1:length(Config(nves).deployments)
        fprintf('\n** %s\n',Config(nves).deployments(ndep).name);
        Config(nves).deployments(ndep) = ...
            proc_deployment(Config(nves).deployments(ndep));
    end
end

