%function [qmax,pt]=maxflow(d,aquiclude)


qmax=0;

u=1;
h=waitbar(0,'wait...');
tic
for k1=2:d.grid.nz-1
    for t=1:366
        for i1=2:d.grid.nx-1
            for j1=2:d.grid.ny-1
                for i2=i1-1:2:i1+1
                    for j2=j1-1:2:j1+1
                        for k2=k1-1:2:k1+1
                            q(u) = abs ( 1/ ( 1/d.perm(i1,j1,k1) + 1/d.perm(i2,j2,k2))  *  ...
                                ( d.head(i1,j1,k1,t)-d.head(i2,j2,k2,t)  )   / ...
                                sqrt( (d.x(i1)-d.x(i2))^2 + (d.y(j1)-d.y(j2))^2 + (d.z(k1)-d.z(k2))^2 ));
                            u=u+1;
                        end
                    end
                end
                
            end
        end
    end
    qz(k1-1)=nanmean(q);
    u=1;
    tt=toc;
    
    %waitbar(k1/(aquiclude-2),h,[tt ' sec already ?? So fast ! But still' tt*(aquiclude-2)/k1 ])
end
close(h)

figure; 
subplot(1,3,1); box on;
plot(qz,d.z(2:end-1),'k')
xlabel('q [m/hr]');ylabel('elevation [m]')
subplot(1,3,2); box on;
plot(cumsum(qz)/nansum(qz),d.z(2:end-1),'k')
xlabel('frequency');ylabel('elevation [m]')
set(gca,'Xscale','log')
subplot(1,3,3); box on;hold on;
plot(reshape(d.perm(d.pt.hill(1),d.pt.hill(2),:),d.grid.nz,1),d.z,'k')
plot(reshape(d.perm(d.pt.pond(1),d.pt.pond(2),:),d.grid.nz,1),d.z,'--k')
xlabel('Ks [m/d]');ylabel('elevation [m]')
legend('At the top of hill', 'at the pond')
set(gca,'Xscale','log')

 %% BETTER, compute the flow..
 
 q=nan(d.grid.nx-1,d.grid.ny-1,d.grid.nz-1,6);
 qq=nan(d.grid.nx-1,d.grid.ny-1,d.grid.nz-1);
 qz=nan(d.grid.nz-1,6);
 qzz=nan(d.grid.nz-1,1);
 tic
 t=4;
 h=waitbar(0,'wait...');
 for z=1:d.grid.nz-1
     for y=1:d.grid.ny-1
         for x=1:d.grid.nx-1
             Z=round(z-d.grid.nz+d.top.level(x,y)/d.grid.dz);
             if Z>0
                 if d.mask(x,y,Z)==1
                     q(x,y,z,1) = nanmean(abs ( 1/ ( 1/d.perm(x,y,Z) + 1/d.perm(x+1,y,Z))  *  ...
                         ( d.head(x,y,Z,:)-d.head(x+1,y,Z,:)  )   ./ d.grid.dx));
                     q(x,y,z,2) = nanmean(abs ( 1/ ( 1/d.perm(x,y,Z) + 1/d.perm(x,y+1,Z))  *  ...
                         ( d.head(x,y,Z,:)-d.head(x,y+1,Z,:)  )   / d.grid.dy));
                     q(x,y,z,3) = nanmean(abs ( 1/ ( 1/d.perm(x,y,Z) + 1/d.perm(x,y,Z+1))  *  ...
                         ( d.head(x,y,Z,:)-d.head(x,y,Z+1,:)  )   / d.grid.dz));
                     q(x,y,z,4) = nanstd(abs ( 1/ ( 1/d.perm(x,y,Z) + 1/d.perm(x+1,y,Z))  *  ...
                         ( d.head(x,y,Z,:)-d.head(x+1,y,Z,:)  )   ./ d.grid.dx));
                     q(x,y,z,5) = nanstd(abs ( 1/ ( 1/d.perm(x,y,Z) + 1/d.perm(x,y+1,Z))  *  ...
                         ( d.head(x,y,Z,:)-d.head(x,y+1,Z,:)  )   / d.grid.dy));
                     q(x,y,z,6) = nanstd(abs ( 1/ ( 1/d.perm(x,y,Z) + 1/d.perm(x,y,Z+1))  *  ...
                         ( d.head(x,y,Z,:)-d.head(x,y,Z+1,:)  )   / d.grid.dz));
                     
                     qq(x,y,z)=nanmean(d.flow(x,y,Z,:));
                     
                 end
             end
         end
     end

    qqz(z)= nanmean(nanmean(nanmean(qq(:,:,z))));
     
    qz(z,1)= nanmean(nanmean(nanmean(q(:,:,z,1))));
    qz(z,2)= nanmean(nanmean(nanmean(q(:,:,z,2))));
    qz(z,3)= nanmean(nanmean(nanmean(q(:,:,z,3))));
    qz(z,4)= nanmean(nanmean(nanmean(q(:,:,z,4))));
    qz(z,5)= nanmean(nanmean(nanmean(q(:,:,z,5))));
    qz(z,6)= nanmean(nanmean(nanmean(q(:,:,z,6))));
    waitbar(z/d.grid.nz,h)
end
toc
close(h)
 
 
fig=figure('units','normalized','outerposition',[0 0 1 1]);
subplot(1,3,1); box on;hold on;
plot(qqz,d.z(1:end-1),'k')
    %plot(qz(:,1),d.z(1:end-1),'r')
    plot(qz(:,2),d.z(1:end-1),'b')
    plot(qz(:,3),d.z(1:end-1),'g')
    plot(qz(:,1)-qz(:,4),d.z(1:end-1),'--r')
    plot(qz(:,2)-qz(:,5),d.z(1:end-1),'--b')
    plot(qz(:,3)-qz(:,6),d.z(1:end-1),'--g')
    plot(qz(:,1)+qz(:,4),d.z(1:end-1),'--r')
    plot(qz(:,2)+qz(:,5),d.z(1:end-1),'--b')
    plot(qz(:,3)+qz(:,6),d.z(1:end-1),'--g')
    xlabel('q [m/hr]');ylabel('elevation [m]')
    legend('x-direction','y-direction','z-direction')
    set(gca,'Xscale','log')
subplot(1,3,2); box on; hold on
    plot(cumsum(qz(:,1))/nansum(qz(:,1)),d.z(1:end-1),'r')
    plot(cumsum(qz(:,2))/nansum(qz(:,2)),d.z(1:end-1),'b')
    plot(cumsum(qz(:,3))/nansum(qz(:,3)),d.z(1:end-1),'g')
    xlabel('frequency');ylabel('elevation [m]')
    legend('x-direction','y-direction','z-direction')
set(gca,'Xscale','log')
    subplot(1,3,3); box on;hold on;
    plot(reshape(d.perm(d.pt.hill(1),d.pt.hill(2),:),d.grid.nz,1),d.z,'k')
    plot(reshape(d.perm(d.pt.pond(1),d.pt.pond(2),:),d.grid.nz,1),d.z,'--k')
    xlabel('Ks [m/d]');ylabel('elevation [m]')
    legend('At the top of hill', 'at the pond')
    set(gca,'Xscale','log')
 
    
% Compare homo and exp    
fig=figure('units','normalized','outerposition',[0 0 1 1]);
subplot(1,3,1); box on;hold on;
    plot(reshape(permhomo(d.pt.hill(1),d.pt.hill(2),:),d.grid.nz,1),15-d.z,'k')
    plot(reshape(permexp(d.pt.hill(1),d.pt.hill(2),:),d.grid.nz,1),15-d.z,'--k')
    xlabel('Ks [m/d]');ylabel('depth [m]')
    legend('homogenous K', 'exponential K')
    set(gca,'Xscale','log','YDir','reverse')
subplot(1,3,2); box on;hold on;
    plot(qzhomo(:,2),15-d.z(1:end-1),'b')
    plot(qzhomo(:,3),15-d.z(1:end-1),'g')
    plot(qzexp(:,2),15-d.z(1:end-1),'--b')
    plot(qzexp(:,3),15-d.z(1:end-1),'--g')
    xlabel('q [m/hr]');ylabel('depth [m]')
    legend('x,y-direction homogenous','z-direction homogenous','x,y-direction exponential','z-direction exponential')
    set(gca,'Xscale','log','YDir','reverse')
subplot(1,3,3); box on; hold on
    plot(cumsum(qzhomo(:,2))/nansum(qzhomo(:,2)),15-d.z(1:end-1),'b')
    plot(cumsum(qzhomo(:,3))/nansum(qzhomo(:,3)),15-d.z(1:end-1),'g')
    plot(cumsum(qzexp(:,2))/nansum(qzexp(:,2)),15-d.z(1:end-1),'--b')
    plot(cumsum(qzexp(:,3))/nansum(qzexp(:,3)),15-d.z(1:end-1),'--g')
    xlabel('frequency');ylabel('depth [m]')
    legend('x,y-direction homogenous','z-direction homogenous','x,y-direction exponential','z-direction exponential')
    set(gca,'Xscale','log','YDir','reverse')

 
 %% Only at one poin
 x1=1;
 y1=1;
  q=nan(d.grid.nz-1,6);
  
 for z=1:d.grid.nz-1
     q(z,1) = nanmean(abs ( 1/ ( 1/d.perm(x1,y1,z) + 1/d.perm(x+1,y,z))  *  ...
         ( d.head(x1,y1,z,:)-d.head(x1+1,y1,z,:)  )   ./ d.grid.dx));
     q(z,2) = nanmean(abs ( 1/ ( 1/d.perm(x1,y1,z) + 1/d.perm(x1,y1+1,z))  *  ...
         ( d.head(x1,y1,z,:)-d.head(x1,y1+1,z,:)  )   / d.grid.dy));
     q(z,3) = nanmean(abs ( 1/ ( 1/d.perm(x1,y1,z) + 1/d.perm(x1,y1,z+1))  *  ...
         ( d.head(x1,y1,z,:)-d.head(x1,y1,z+1,:)  )   / d.grid.dz));
     q(z,4) = nanstd(abs ( 1/ ( 1/d.perm(x1,y1,z) + 1/d.perm(x+1,y,z))  *  ...
         ( d.head(x1,y1,z,:)-d.head(x+1,y,z,:)  )   ./ d.grid.dx));
     q(z,5) = nanstd(abs ( 1/ ( 1/d.perm(x1,y1,z) + 1/d.perm(x1,y1+1,z))  *  ...
         ( d.head(x1,y1,z,:)-d.head(x1,y1+1,z,:)  )   / d.grid.dy));
     q(z,6) = nanstd(abs ( 1/ ( 1/d.perm(x1,y1,z) + 1/d.perm(x1,y1,z+1))  *  ...
         ( d.head(x1,y1,z,:)-d.head(x1,y1,z+1,:)  )   / d.grid.dz));
 end
 
 fig=figure('units','normalized','outerposition',[0 0 1 1]);
subplot(1,3,2); box on;hold on;
    plot(q(:,1),d.z(1:end-1),'r')
    plot(q(:,2),d.z(1:end-1),'b')
    plot(q(:,3),d.z(1:end-1),'g')
    plot(q(:,1)-q(:,4),d.z(1:end-1),'--r')
    plot(q(:,2)-q(:,5),d.z(1:end-1),'--b')
    plot(q(:,3)-q(:,6),d.z(1:end-1),'--g')
    plot(q(:,1)+q(:,4),d.z(1:end-1),'--r')
    plot(q(:,2)+q(:,5),d.z(1:end-1),'--b')
    plot(q(:,3)+q(:,6),d.z(1:end-1),'--g')
    xlabel('q [m/hr]');ylabel('elevation [m]')
    legend('x-direction','y-direction','z-direction')
    set(gca,'Xscale','log')
 
%% USE FLOW created by PF
[f,x] = ecdf(d.flow(:));
plot(x,f)  

flowremoved=d.flow(abs(d.flow(:))<0.5);
[f,x] = ecdf(flowremoved);
plot(x,f)

flowremoved2=d.flow(abs(d.flow(:))<10^-7);
[f,x] = ecdf(flowremoved2);
plot(x,f)

numel(flowremoved2)/numel(d.flow(~isnan(d.flow(:))));
flow2=d.flow;
flow2(d.flow>10^-1)=NaN;
h=pcolor(Y,Z,reshape(flow3(d.coupe(1),d.yy,d.zz,t),numel(d.yy),numel(d.zz))');
set(h, 'EdgeColor', 'none');
contour(Y,Z,reshape(flow3(d.coupe(1),d.yy,d.zz,t),numel(d.yy),numel(d.zz))','ShowText','on');

flow=reshape(nanmean(nanmean(nanmean(flow2,1),2),4),d.grid.nz,1);


for x=1:d.grid.nx
    for y=1:d.grid.ny
        flow2(x,y,d.top.level(x,y)/d.grid.dz,:)=0;
    end
end
flow3=flow2;
flow3(abs(flow2)<10^-5)=NaN;
flow3(abs(flow2)>1)=NaN;

