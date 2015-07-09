function generate_pfsol(d)
tic
% !
% !  written by Reed Maxwell (maxwell5@llnl.gov)
% !  10-30-04
% ! 
% !  modifications 23 september 2008 by aditi bhaskar (aditi.bhaskar@umbc.edu)
% !  adaptation to Matlab by Raphael in June 2014 (rafnuss@gmail.com)
% ! 
% ! code creates a triangulated pf solid file
% ! it reads in a d.dem file for the shape of the top surface, but assumes that
% ! the rest of the domain is rectangularly shaped (and is the same size as the
% ! extents of the d.dem)
% !
% !NOTES:
% ! we assume the spatial discretization is the SAME for bottom and top of domain
% ! we assume rectangular sides
% ! we assume one (1) solid
% ! we assume six (6) patches
% 
% ! ------  INPUT LINES -------

num_solid       = 1;
num_points      = 2*d.grid.nx*d.grid.ny;
num_triangles   = 4*(d.grid.nx-1)*(d.grid.ny-1)  + 4*(d.grid.nx-1) + 4*(d.grid.ny-1);
num_patches     = 6;
points          = zeros(num_points,3);
triangles       = zeros(num_triangles,3);
patches         = zeros(num_patches,num_patches);

dem2 = d.dem - (min(d.dem(:))-d.thickness);
% ! the lowest elevation of the land surface may not be sea level. e.g. if 
% ! your elevations are from 50 to 400 m, you want to add 150m (200-50) to 
% ! all your d.dem values so that z=0 is the bottom of your aquifer, and z=200 
% ! is your minimum land surface elev cell (50m+150m) and z=550m is your max 
% ! elev (400m+150m). basically you want the solid file to contain your
% ! whole domain including the aquifer thickness, and it seems to only have 
% ! worked for me if you make z=0 the bottom of the aquifer instead of a 
% ! negative value. 


% ! loop over points and assign, jj = point counter
% ! first the d.dem/upper surface
% ! we assume points are in the center of the digital elevation tile 

jj = 1;
for i=1:d.grid.nx
    for j=1:d.grid.ny
        points(jj,1) = (i-1)*d.grid.dx + d.grid.dx/2 + d.grid.lx;
        points(jj,2) = (j-1)*d.grid.dy + d.grid.dy/2 + d.grid.ly;
        points(jj,3) = dem2(i,j);
        jj = jj + 1;
    end
end

% then the lower surface; currently a flat surface - i.e. datum
for i=1:d.grid.nx
    for j=1:d.grid.ny
        points(jj,1) = (i-1)*d.grid.dx + d.grid.dx/2. + d.grid.lx;
        points(jj,2) = (j-1)*d.grid.dy + d.grid.dy/2. + d.grid.ly;
        points(jj,3) = d.grid.lz;
        jj = jj + 1;
    end
end

% ! NOTE: the order in which the triangle points verticies are specified is 
% ! critical - they must be specified so the normal vector points out of 
% ! the domain always (ie RHR counterclockwise for the top face, etc)
jj = 1;
ii = 1;
for i=1:(d.grid.nx-1)
    for j=1:(d.grid.ny-1)
        triangles(jj,1) = (i-1)*d.grid.ny + j;
        triangles(jj,2) = (i)*d.grid.ny + j  + 1;
        triangles(jj,3) = (i-1)*d.grid.ny + j  +1;
        patches(1,ii) = jj;
        jj = jj + 1;
        ii = ii + 1;
        triangles(jj,1) = (i-1)*d.grid.ny + j;
        triangles(jj,2) = (i)*d.grid.ny + j ;
        triangles(jj,3) = (i)*d.grid.ny + j +1;
        patches(1,ii) = jj;
        jj = jj + 1;
        ii = ii + 1;
    end
end

num_tri_patches(1) = ii - 1;
ii = 1;

% then the lower surface; 
for i=1:(d.grid.nx-1)
    for j=1:(d.grid.ny-1)
        triangles(jj,1) = (i-1)*d.grid.ny + j+ d.grid.nx*d.grid.ny;
        triangles(jj,2) = (i-1)*d.grid.ny + j  + 1 + d.grid.nx*d.grid.ny;
        triangles(jj,3) = (i)*d.grid.ny + j  +1 + d.grid.nx*d.grid.ny;
        patches(2,ii) = jj;
        jj = jj + 1;
        ii = ii + 1;
        triangles(jj,1) = (i-1)*d.grid.ny + j+ d.grid.nx*d.grid.ny;
        triangles(jj,2) = (i)*d.grid.ny + j + 1+ d.grid.nx*d.grid.ny;
        triangles(jj,3) = (i)*d.grid.ny + j + d.grid.nx*d.grid.ny;
        patches(2,ii) = jj;
        jj = jj + 1;
        ii = ii + 1;
    end
end

num_tri_patches(2) = ii - 1;
ii = 1;

% then x=d.grid.lx face; 
for j = 1:(d.grid.ny-1)
    triangles(jj,1) =  j + d.grid.nx*d.grid.ny;
    triangles(jj,2) =  j ;
    triangles(jj,3) =  j +1;
    patches(3,ii) = jj;
    jj = jj + 1;
    ii = ii + 1;
    
    triangles(jj,1) =  j + d.grid.nx*d.grid.ny;
    triangles(jj,2) =  j + 1 ;
    triangles(jj,3) =  j + 1 + d.grid.nx*d.grid.ny;
    patches(3,ii) = jj;
    jj = jj + 1;
    ii = ii + 1;
end

num_tri_patches(3) = ii - 1;
ii = 1;

% now the x=d.info.ux face; 
for j = 1:(d.grid.ny-1)
    triangles(jj,1) =  (d.grid.nx-1)*d.grid.ny + j + d.grid.nx*d.grid.ny;
    triangles(jj,2) =  (d.grid.nx-1)*d.grid.ny + j  +1;
    triangles(jj,3) =  j + (d.grid.nx-1)*d.grid.ny ;
    patches(4,ii) = jj;
    jj = jj + 1;
    ii = ii + 1;
    
    triangles(jj,1) =  j + d.grid.nx*d.grid.ny + (d.grid.nx-1)*d.grid.ny ;
    triangles(jj,2) =  j + 1 + (d.grid.nx-1)*d.grid.ny + d.grid.nx*d.grid.ny;
    triangles(jj,3) =  j + 1 + (d.grid.nx-1)*d.grid.ny ;
    patches(4,ii) = jj;
    jj = jj + 1;
    ii = ii + 1;
end

num_tri_patches(4) = ii - 1;
ii = 1;

% and the y=d.grid.ly face;
for i = 1:(d.grid.nx-1)
    triangles(jj,1) =  (i-1)*d.grid.ny + 1 + d.grid.nx*d.grid.ny;
    %triangles(jj,2) =  (i)*d.grid.ny + 1
    triangles(jj,2) =  d.grid.ny + (i-1)*d.grid.ny + 1 ;
    triangles(jj,3) =  (i-1)*d.grid.ny + 1 ;
    patches(5,ii) = jj;
    jj = jj + 1;
    ii = ii + 1;
    
    triangles(jj,1) =  (i-1)*d.grid.ny + 1 + d.grid.nx*d.grid.ny;
    %triangles(jj,2) =  1 +(i)*d.grid.ny + d.grid.nx*d.grid.ny;
    triangles(jj,2) =  (i-1)*d.grid.ny + 1 + d.grid.nx*d.grid.ny + d.grid.ny;
    triangles(jj,3) =  1 + d.grid.ny + (i-1)*d.grid.ny;
    patches(5,ii) = jj;
    jj = jj + 1;
    ii = ii + 1;
end

num_tri_patches(5) = ii - 1;
ii = 1;

% and the y=d.info.ux
for i = 1:(d.grid.nx-1)
    triangles(jj,1) =  (i-1)*d.grid.ny + d.grid.ny + d.grid.nx*d.grid.ny;
    triangles(jj,2) =  (i-1)*d.grid.ny + d.grid.ny ;
    triangles(jj,3) =  (i-1)*d.grid.ny + 2*d.grid.ny;
    patches(6,ii) = jj;
    jj = jj + 1;
    ii = ii + 1;
    
    triangles(jj,1) =  (i-1)*d.grid.ny + d.grid.ny + d.grid.nx*d.grid.ny;
    triangles(jj,2) =  2*d.grid.ny +(i-1)*d.grid.ny;
    triangles(jj,3) =  2*d.grid.ny +(i-1)*d.grid.ny + d.grid.nx*d.grid.ny;
    patches(6,ii) = jj;
    jj = jj + 1;
    ii = ii + 1;
end

num_tri_patches(6) = ii - 1;
ii = 1;

%% Save file
cd([d.path.save '/input']);
fileID = fopen('shape.pfsol','w');
fprintf(fileID,'%d\n',1); % version
fprintf(fileID,'% 8d\n',num_points); % write num vertices/points
for i=1:num_points % write points
    fprintf(fileID,'% 15.4f% 17.4f% 17.4f\n',[points(i,1), points(i,2), points(i,3)]);
end
fprintf(fileID,'% 4d\n',num_solid); % currently we are assuming 1 solid
for k=1:num_solid
    fprintf(fileID,'% 8d\n',num_triangles); % write num trianglesw
    for i=1:num_triangles %write triangles
        fprintf(fileID,'% 8d% 10d% 10d\n',[triangles(i,1)-1, triangles(i,2)-1, triangles(i,3)-1]);
    end
    fprintf(fileID,'% 3d\n',num_patches); % write num patches
    for i=1:num_patches
        fprintf(fileID,'% 9d\n',num_tri_patches(i));
        for j=1:num_tri_patches(i)
            fprintf(fileID,'% 8d\n',patches(i,j)-1);
        end        
    end
end
fclose(fileID);


cd([d.path.core '/pre/generate_function'])
disp(['2.5 pfsol created in ' round(num2str(toc)) ' sec'])
end