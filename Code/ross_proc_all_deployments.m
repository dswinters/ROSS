function Config = ross_proc_all_deployments(Config)

for k = 1:length(Config)
    for ndep = 1:length(Config(k).deployments)
        Config(k) = ross_proc_deployment(Config(k),ndep);
    end
end

