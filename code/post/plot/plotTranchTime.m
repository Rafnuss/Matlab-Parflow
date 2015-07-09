function plotTranchTime(d)
x1=d.pt.hill(1);y1=d.pt.hill(2);
x2=d.pt.pond(1);y2=d.pt.pond(2);
elev1=d.top.level(x1,y1);
elev2=d.top.level(x2,y2);



figure('units','normalized','outerposition',[0 0 1 1]);



[T,Z]=meshgrid(0:d.time.nt,d.z(1:elev1/d.grid.dz));

subplot(2,2,1);hold on; box on;
contourf(T,Z,reshape(d.pressure(x1,y1,d.zz(1:elev1/d.grid.dz),:),elev1/d.grid.dz,d.time.nt+1),'ShowText','on');
line([0 d.time.nt],[elev1 elev1],'Color',[102/255 51/255 0],'LineWidth',2)
xlabel('Timer [hr]');ylabel('elevation');title('Pressure at hill')


subplot(2,2,3);hold on
%contourf(T,Z,reshape(d.pressure(x1,y1,d.zz,:),d.grid.nz,d.time.nt+1),'ShowText','on');
contourf(T,Z,reshape(d.head(x1,y1,d.zz(1:elev1/d.grid.dz),:),elev1/d.grid.dz,d.time.nt+1),'ShowText','on');
line([0 d.time.nt],[elev1 elev1],'Color',[102/255 51/255 0],'LineWidth',2)
xlabel('Timer [hr]');ylabel('elevation'); title('head at hill')




[T,Z]=meshgrid(0:d.time.nt,d.z(1:elev2/d.grid.dz));

subplot(2,2,4);hold on
%contourf(T,Z,reshape(d.pressure(x2,y2,d.zz,:),d.grid.nz,d.time.nt+1),'ShowText','on');

contourf(T,Z,reshape(d.head(x2,y2,d.zz(1:elev2/d.grid.dz),:),elev2/d.grid.dz,d.time.nt+1),'ShowText','on');
line([0 d.time.nt],[elev2 elev2],'Color',[102/255 51/255 0],'LineWidth',2)
xlabel('Timer [hr]');ylabel('elevation');title('Head at pond')

subplot(2,2,2);
contourf(T,Z,reshape(d.pressure(x2,y2,d.zz(1:elev2/d.grid.dz),:),elev2/d.grid.dz,d.time.nt+1),'ShowText','on');
line([0 d.time.nt],[elev2 elev2],'Color',[102/255 51/255 0],'LineWidth',2)
xlabel('Timer [hr]');ylabel('elevation');title('Pressure at pond')
end