function register_google_map(image_name,overwrite)
mapdir = '../../Maps/';

I = imread([mapdir,image_name]);
I = flipud(I);
imshow(I), hold on
set(gca,'ydir','normal')

[fpath,fname,fext] = fileparts(image_name);
matfile = [fpath fname '.mat'];
if ~exist(matfile,'file') | overwrite
    disp('Please select 5 points on the map:')
    for i = 1:5
        p(i,:) = ginput(1);
        plot(p(i,1),p(i,2),'x','markersize',15);
        plot(p(i,1),p(i,2),'wo','markersize',15);
        text(p(i,1)+10,p(i,2),sprintf('%d',i),...
             'horizontalalignment','left',...
             'verticalalignment','middle',...
             'color','r','fontsize',20,...
             'fontweight','bold');
    end

    ll = nan(5,2);

    for i = 1:5
        prompt = sprintf('Enter the lat/lon of point %d:',i);
        llstr = inputdlg(prompt,'s');
        ll(i,:) = str2num(llstr{1});
    end

    % convert pixel coords to lat/lon
    R = [[p(:,1)*0+1, p(:,1)] \ ll(:,2),...
         [p(:,2)*0+1, p(:,2)] \ ll(:,1)];
    x = R(1,1) + R(2,1)*[1:size(I,2)];
    y = R(1,2) + R(2,2)*[1:size(I,1)]';

    save([mapdir matfile],'x','y','I');
    disp(['Saved ' matfile])
end



return
