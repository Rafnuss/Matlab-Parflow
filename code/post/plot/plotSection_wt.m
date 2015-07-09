function plotSection_wt(d)

t1=d.date(1);
tend=d.date(end);
t=find(t1==d.date):find(tend==d.date);


pt.pond1    = [d.grid.nx/2 d.grid.ny/4];
pt.rip1     = [d.grid.nx/2 d.grid.ny/4+2];
pt.pond2    = [d.grid.nx/2 3*d.grid.ny/4];
pt.rip2     = [d.grid.nx/2 3*d.grid.ny/4-2];
pt.middle   = [d.grid.nx/2 d.grid.ny/2];


[Y,Z]=meshgrid(d.y(d.yy),d.z(d.zz));
figure('units','normalized','outerposition',[0 0 1 1]);








subplot(2,1,1); hold on; box on;
h=pcolor(Y,Z,reshape(mean(d.head(d.coupe(1),d.yy,d.zz,t),4),d.grid.ny,d.grid.nz)');
set(h, 'EdgeColor', 'none');

WT=d.wlevel(d.coupe(1),d.yy,t)*d.grid.dz;
plot(d.y(d.yy),mean(WT,3),'b','lineWidth',2)
%plot(d.y(d.yy),mean(WT,3)+nanstd(WT,0,3),'--b')
%plot(d.y(d.yy),mean(WT,3)-nanstd(WT,0,3),'--b')
plot(d.y(d.yy),min(WT,[],3),'-.b')
plot(d.y(d.yy),max(WT,[],3),'-.b')

plot(d.y(d.yy),d.top.level(d.coupe(1),d.yy),'k','lineWidth',2)

plot([d.x(pt.pond1(2)) d.y(pt.pond1(2))],[0 max(d.z)],'lineWidth',2)
plot([d.y(pt.rip1(2)) d.y(pt.rip1(2))],[0 max(d.z)],'lineWidth',2)
plot([d.y(pt.pond2(2)) d.y(pt.pond2(2))],[0 max(d.z)],'lineWidth',2)
plot([d.y(pt.rip2(2)) d.y(pt.rip2(2))],[0 max(d.z)],'lineWidth',2)
plot([d.y(pt.middle(2)) d.y(pt.middle(2))],[0 max(d.z)],'lineWidth',2)
xlabel('y[m]');ylabel('Elevation [m]');legend('Head','mean WT level','min WT level','max WT level')








subplot(2,1,2); hold on; box on;

plot(d.date(t),reshape(d.wlevel(pt.pond1(1),pt.pond1(2),:),numel(t),1)*d.grid.dz)
plot(d.date(t),reshape(d.wlevel(pt.rip1(1),pt.rip1(2),:),numel(t),1)*d.grid.dz)
plot(d.date(t),reshape(d.wlevel(pt.pond2(1),pt.pond2(2),:),numel(t),1)*d.grid.dz)
plot(d.date(t),reshape(d.wlevel(pt.rip2(1),pt.rip2(2),:),numel(t),1)*d.grid.dz)
plot(d.date(t),reshape(d.wlevel(pt.middle(1),pt.middle(2),:),numel(t),1)*d.grid.dz)
