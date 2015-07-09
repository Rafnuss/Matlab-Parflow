function generate_soil(d)
%%  generate_soil() generate porosity  and van genuchten parameter
tic

% switch type
%     case 'log' % identical to guelf
%         SSat =  0.520*ones(d.grid.nx,d.grid.ny,d.grid.nz);
%         SRes =  0.218*ones(d.grid.nx,d.grid.ny,d.grid.nz);
%         alpha = 0.0115*ones(d.grid.nx,d.grid.ny,d.grid.nz);
%         n =     2.03*ones(d.grid.nx,d.grid.ny,d.grid.nz);     
%         
%     case 'HS' % Hygiene sandstone
%         SSat =  0.250*ones(d.grid.nx,d.grid.ny,d.grid.nz);
%         SRes =  0.153*ones(d.grid.nx,d.grid.ny,d.grid.nz);
%         alpha = 0.0079*ones(d.grid.nx,d.grid.ny,d.grid.nz);
%         n =     10.4*ones(d.grid.nx,d.grid.ny,d.grid.nz);
%         
%     case 'TSL' % Touchet Silt Loam
%         SSat =  0.469*ones(d.grid.nx,d.grid.ny,d.grid.nz);
%         SRes =  0.190*ones(d.grid.nx,d.grid.ny,d.grid.nz);
%         alpha = 0.0050*ones(d.grid.nx,d.grid.ny,d.grid.nz);
%         n =     7.09*ones(d.grid.nx,d.grid.ny,d.grid.nz);
%         
%     case 'SL' % Silt Loam
%         SSat =  0.396*ones(d.grid.nx,d.grid.ny,d.grid.nz);
%         SRes =  0.131*ones(d.grid.nx,d.grid.ny,d.grid.nz);
%         alpha = 0.00423*ones(d.grid.nx,d.grid.ny,d.grid.nz);
%         n =     1.06*ones(d.grid.nx,d.grid.ny,d.grid.nz);
%         
%     case 'GL' % Guelph Loam 
%         SSat =  0.520*ones(d.grid.nx,d.grid.ny,d.grid.nz);
%         SRes =  0.218*ones(d.grid.nx,d.grid.ny,d.grid.nz);
%         alpha = 0.0115*ones(d.grid.nx,d.grid.ny,d.grid.nz);
%         n =     2.03*ones(d.grid.nx,d.grid.ny,d.grid.nz);
%         
%     case 'BNF' % Beit Netofa Clay
%         SSat =  0.446*ones(d.grid.nx,d.grid.ny,d.grid.nz);
%         SRes =  0.0*ones(d.grid.nx,d.grid.ny,d.grid.nz);
%         alpha = 0.00152*ones(d.grid.nx,d.grid.ny,d.grid.nz);
%         n =     1.17*ones(d.grid.nx,d.grid.ny,d.grid.nz);
%         
% end

% convert from [cm^-1] to [m^-1]
%alpha=alpha*100;

SSat    =  d.info.SSat*ones(d.grid.nx,d.grid.ny,d.grid.nz);
SRes    =  d.info.SRes*ones(d.grid.nx,d.grid.ny,d.grid.nz);
alpha   =  d.info.alpha*ones(d.grid.nx,d.grid.ny,d.grid.nz);
N       =  d.grid.n*ones(d.grid.nx,d.grid.ny,d.grid.nz);

%% Write to the file .SA
cd([d.path.save '/input']);
fileID = fopen('SSat.sa','w');
fprintf(fileID,'%d %d %d \n',d.grid.nx,d.grid.ny,d.grid.nz);
fprintf(fileID,'%e\n',reshape(SSat,d.grid.nx*d.grid.ny*d.grid.nz,1));
fclose(fileID);
fileID = fopen('SRes.sa','w');
fprintf(fileID,'%d %d %d \n',d.grid.nx,d.grid.ny,d.grid.nz);
fprintf(fileID,'%e\n',reshape(SRes,d.grid.nx*d.grid.ny*d.grid.nz,1));
fclose(fileID);
fileID = fopen('alphas.sa','w');
fprintf(fileID,'%d %d %d \n',d.grid.nx,d.grid.ny,d.grid.nz);
fprintf(fileID,'%e\n',reshape(alpha,d.grid.nx*d.grid.ny*d.grid.nz,1));
fclose(fileID);
fileID = fopen('Ns.sa','w');
fprintf(fileID,'%d %d %d \n',d.grid.nx,d.grid.ny,d.grid.nz);
fprintf(fileID,'%e\n',reshape(N,d.grid.nx*d.grid.ny*d.grid.nz,1));
fclose(fileID);
cd([d.info.chemin '/pre/generate_function']);
disp(['5. Soil d.info created  in ' num2str(toc) ' sec'])
end