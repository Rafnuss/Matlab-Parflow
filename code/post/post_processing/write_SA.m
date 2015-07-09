function write_SA(data,filename,info)
cd([info.chemin '/output'])
nx=size(data,1);
ny=size(data,2);
nz=size(data,3);

if size(data,4)~=1 % If it change with time...
    tmax=size(data,4);
    for i=1:tmax
        fileID = fopen(sprintf('%s.%05.0f.sa',filename,i),'w');
        fprintf(fileID,'%d %d %d\n',nx,ny,nz);
        for z=1:nz
            for y=1:ny
                for x=1:nx
                    fprintf(fileID,'% 8.6e\n',data(x,y,z,i));
                end
            end
        end
        fclose(fileID);
    end
    
    
else % ... if it does not change with time
    fileID = fopen(sprintf('%s.sa',filename),'w');
    fprintf(fileID,'%d %d %d\n',nx,ny,nz);
    for z=1:nz
        for y=1:ny
            for x=1:nx
                fprintf(fileID,'% 8.6e\n',data(x,y,z));
            end
        end
    end
    fclose(fileID);
end
cd([info.chemin '/post/post_processing']);
end



