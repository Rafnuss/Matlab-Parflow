function generate_perm(d,type)
%%  generate_perm() Generate the Hydraulic Conductivity field over the whole domain
tic

switch type
    case 'log'
        % In this case, the function used is : log10(k)=a*exp(l*d)+b
        a=6;        b=-6;        l=0.1;   %-1/10*log(2/3);
        
        K=zeros(d.grid.nx,d.grid.ny,d.grid.nz);
        for i=1:d.grid.nx
            for j=1:d.grid.ny
                d=linspace(0,d.grid.dz*d.grid.nz,d.grid.nz)-d.dem(i,j)+(min(d.dem(:))-d.thickness);
                K(i,j,:)=10.^(a*exp(l*d)+b)';
            end
        end
        
        % This generate [cm/day]
        Ks=K/24;
        
        
        % Plot to check
        % surface(K(:,:,end/2)); d=0:50;
        % Kt=10.^(a*exp(l*d)+b); semilogx(Kt,-d); xlabel('K [m/d]');ylabel('depth [m]')
        
        
    case 'constant'
        Ks=d.soil.Ks*ones(d.grid.nx,d.grid.ny,d.grid.nz);
        
        
        
        
    case 'exp' %(Ireson,2013)
                        
        K=zeros(d.grid.nx,d.grid.ny,d.grid.nz);
        for i=1:d.grid.nx
            for j=1:d.grid.ny
                z=linspace(0,d.grid.dz*d.grid.nz,d.grid.nz)-d.dem(i,j)+(min(d.dem(:))-d.thickness);
                wf=d.soil.wf_inf + (d.soil.wf_0 - d.soil.wf_inf)*exp(d.soil.b*-z);
                K(i,j,:)=wf*d.soil.Kf  +  (1-wf)*d.soil.Km;
            end
        end
        
        Ks=K/24; % from [m/d] -> [m/h]
        
    otherwise
        error('No Permeability method used !')
        return
        
        
        
end



%% Write to the file .SA
cd([d.path.save '/input']);
fileID = fopen('perm.sa','w');
fprintf(fileID,'%d %d %d \n',d.grid.nx,d.grid.ny,d.grid.nz);
fprintf(fileID,'%e\n',reshape(Ks,d.grid.nx*d.grid.ny*d.grid.nz,1));
fclose(fileID);

%% fin
cd([d.path.core '/pre/generate_function'])
disp(['2.2 perm created  in ' round(num2str(toc)) ' sec'])
end