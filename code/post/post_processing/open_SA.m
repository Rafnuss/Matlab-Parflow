function data=open_SA(filename,d,D,t,init)
tic
if t % If it change with time...
    cd([d.path.output '/TXT'])
    %h = waitbar(0,['Loading ' filename]);
    if D % if it is 3D
        data=zeros(d.grid.nx,d.grid.ny,d.grid.nz,d.time.nt+1);
        for i=init:d.time.nt
            %waitbar(i/d.time.nt,h,['Loading ' filename ' .  ' num2str(round(toc)) '/' num2str(round(toc/i*d.time.nt)) 'sec'])
            fileID = fopen(sprintf('%s.%05.0f.txt',filename,i),'r');
            a=textscan(fileID,'%d',3);
            A=textscan(fileID,'%f');
            fclose(fileID);
            data(:,:,:,i+1)=reshape(A{1}(:),d.grid.nx,d.grid.ny,d.grid.nz);
        end
    else %if it is only 2D
        data=zeros(d.grid.nx,d.grid.ny,d.time.nt+1);
        for i=init:d.time.nt
            %waitbar(i/d.time.nt,h,['Loading ' filename '.  ' num2str(round(toc)) '/' num2str(round(toc/i*d.time.nt)) 'sec'])
            fileID = fopen(sprintf('%s.%05.0f.txt',filename,i),'r');
            a=textscan(fileID,'%d',3);
            A=textscan(fileID,'%f',d.grid.nx*d.grid.ny);
            fclose(fileID);
            data(:,:,i+1)=reshape(A{1}(:),d.grid.nx,d.grid.ny);
        end
    end
    %close(h)
    
else % ... if it does not change with time
    cd(d.path.output)
    if D % if it is 3D
        fileID = fopen([filename '.txt'],'r');
        a=textscan(fileID,'%d',3);
        A=textscan(fileID,'%f');
        fclose(fileID);
        data=reshape(A{1}(:),d.grid.nx,d.grid.ny,d.grid.nz);
    else % if it is 2D
        fileID = fopen([filename '.txt'],'r');
        a=textscan(fileID,'%d',3);
        A=textscan(fileID,'%f',d.grid.nx*d.grid.ny);
        fclose(fileID);
        data=reshape(A{1}(:),d.grid.nx,d.grid.ny);
    end
end

cd([d.path.core '/post/post_processing']);
end
