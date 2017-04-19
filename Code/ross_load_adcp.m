function A = ross_load_adcp(ross,ndep)
D = ross.deployments(ndep);

matfile = [ross.dirs.raw.adcp D.name '.mat'];
fexist = exist(matfile,'file');

if ~fexist || ross.deployments(ndep).proc.adcp_raw2mat
    %% Load raw data
    adcp_load_func = 'rdradcp_multi';
    if isfield(D.proc,'adcp_load_function')
        adcp_load_func = D.proc.adcp_load_function;
    end
    A = feval(adcp_load_func,D.files.adcp);

    %% Minor processing
    for ia = 1:length(A)
        % Make sure century is correct
        idx = year(A(ia).mtime) < 2000;
        A(ia).mtime(idx) = A(ia).mtime(idx) + datenum([2000 0 0 0 0 0]);
        % limit to deployment start/stop time
        idx = find(A(ia).mtime >= D.tlim(1) & ...
                   A(ia).mtime <= D.tlim(2));
        A(ia) = adcp_index(A(ia),idx);
    end
    
    %% save matfile
    save(matfile,'A');
    disp(['Saved ' matfile])
else
    load(matfile,'A');
    disp(['- Loaded ' matfile])
    for i = 1:length(A(1).files)
        disp(sprintf('  - %s',A(1).files{i}));
    end
end


for i = 1:length(A)
    disp(sprintf('- ADCP configuration %d:',i))
    s = evalc('A(i).config');
    s = s(10:end-1);
    s = regexprep(s,'  +',' |');
    s = regexprep(s,'\n','|\n');
    s = regexprep(s,': ',' | ');   
    fprintf(['\n' s '\n']);
end

end
