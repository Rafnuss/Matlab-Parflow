function generate_manning(d,type)
%%  generate_perm() Generate the Hydraulic Conductivity field over the whole domain
tic

switch type                                                            % ________________________
    case 'HighInCenter'                                                % | _____perimeterM_____  |
        perimeterM=0.03;                                               % | |                   | |    
        center = 10;                                                   % | |                   | |    
        b=1;                                                           % | |      centerM      | |    
        M = center*ones(d.grid.nx,d.grid.ny);                          % | |                   | |   
        M(1:d.grid.nx<1+b | 1:d.grid.nx>d.grid.nx-b,:)=perimeterM;     % | |___________________| |    
        M(:,1:d.grid.ny<1+b | 1:d.grid.nx>d.grid.ny-b)=perimeterM;     % |_______________________| | = b 
end



%% Write to the file .SA
cd([d.path.save '/input']);
fileID = fopen('manning.sa','w');
fprintf(fileID,'%d %d %d \n',d.grid.nx,d.grid.ny,1);
fprintf(fileID,'%e\n',reshape(M,d.grid.nx*d.grid.ny,1));
fclose(fileID);

%% fin
cd([d.path.core '/pre/generate_function'])
disp(['6. Manning created  in ' num2str(toc) ' sec'])
end