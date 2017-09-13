function Ross = ross_proc_all_deployments(Ross)

for k = 1:length(Ross)
    for ndep = 1:length(Ross(k).deployments)
        Ross(k) = ross_proc_deployment(Ross(k),ndep);
    end
end

