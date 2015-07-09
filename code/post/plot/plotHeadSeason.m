function plotHeadSeason(d)


[Y,Z]=meshgrid(d.y(d.yy),d.z(d.zz));

[~, M, ~, ~, ~, ~]=datevec(d.date);

T1=datenum('20 october 2002');
T2=datenum('17 Mars 2003');
T3=datenum('8 April 2003');
T4=datenum('1 September 2003');

t1=datenum(d.date)>T1 & datenum(d.date)<T2;
t2=datenum(d.date)>T2 & datenum(d.date)<T3;
t3=datenum(d.date)>T3 & datenum(d.date)<T4;
t4=M>=9;

fig=figure('units','normalized','outerposition',[0 0 1 1]);


subplot(2,3,1); box on; grid on; hold on;
h{6}=pcolor(Y,Z,reshape(mean(dhomo.pressure(dhomo.coupe(1),dhomo.yy,dhomo.zz,t1),4),numel(dhomo.yy),numel(dhomo.zz))');
set(h{6}, 'EdgeColor', 'none');
contour(Y,Z,reshape(mean(dhomo.head(dhomo.coupe(1),dhomo.yy,dhomo.zz,t1),4),numel(dhomo.yy),numel(dhomo.zz))',10,'k','ShowText','on');
plot(dhomo.y(dhomo.yy),dhomo.dem(dhomo.coupe(1),dhomo.yy),'k','lineWidth',2)
plot(dhomo.y(dhomo.yy),mean(dhomo.wlevelextrap(dhomo.coupe(1),dhomo.yy,t1),3),'b','lineWidth',2)
ylabel('constant K');title([datestr(T1) ' - ' datestr(T2)])

subplot(2,3,2); box on; grid on; hold on;
h{6}=pcolor(Y,Z,reshape(mean(dhomo.pressure(dhomo.coupe(1),dhomo.yy,dhomo.zz,t2),4),numel(dhomo.yy),numel(dhomo.zz))');
set(h{6}, 'EdgeColor', 'none');
contour(Y,Z,reshape(mean(dhomo.head(dhomo.coupe(1),dhomo.yy,dhomo.zz,t2),4),numel(dhomo.yy),numel(dhomo.zz))',10,'k','ShowText','on');
plot(dhomo.y(dhomo.yy),dhomo.dem(dhomo.coupe(1),dhomo.yy),'k','lineWidth',2)
plot(dhomo.y(dhomo.yy),mean(dhomo.wlevelextrap(dhomo.coupe(1),dhomo.yy,t2),3),'b','lineWidth',2)
title([datestr(T2) ' - ' datestr(T3)])

subplot(2,3,3); box on; grid on; hold on;
h{6}=pcolor(Y,Z,reshape(mean(dhomo.pressure(dhomo.coupe(1),dhomo.yy,dhomo.zz,t3),4),numel(dhomo.yy),numel(dhomo.zz))');
set(h{6}, 'EdgeColor', 'none');
contour(Y,Z,reshape(mean(dhomo.head(dhomo.coupe(1),dhomo.yy,dhomo.zz,t3),4),numel(dhomo.yy),numel(dhomo.zz))',10,'k','ShowText','on');
plot(dhomo.y(dhomo.yy),dhomo.dem(dhomo.coupe(1),dhomo.yy),'k','lineWidth',2)
plot(dhomo.y(dhomo.yy),mean(dhomo.wlevelextrap(dhomo.coupe(1),dhomo.yy,t3),3),'b','lineWidth',2)
title([datestr(T3) ' - ' datestr(T4)])


subplot(2,3,4); box on; grid on; hold on;
h{6}=pcolor(Y,Z,reshape(mean(dexp.pressure(dexp.coupe(1),dexp.yy,dexp.zz,t1),4),numel(dexp.yy),numel(dexp.zz))');
set(h{6}, 'EdgeColor', 'none');
contour(Y,Z,reshape(mean(dexp.head(dexp.coupe(1),dexp.yy,dexp.zz,t1),4),numel(dexp.yy),numel(dexp.zz))',10,'k','ShowText','on');
plot(dexp.y(dexp.yy),dexp.dem(dexp.coupe(1),dexp.yy),'k','lineWidth',2)
plot(dexp.y(dexp.yy),mean(dexp.wlevelextrap(dexp.coupe(1),dexp.yy,t1),3),'b','lineWidth',2)
ylabel('exponential K')

subplot(2,3,5); box on; grid on; hold on;
h{6}=pcolor(Y,Z,reshape(mean(dexp.pressure(dexp.coupe(1),dexp.yy,dexp.zz,t2),4),numel(dexp.yy),numel(dexp.zz))');
set(h{6}, 'EdgeColor', 'none');
contour(Y,Z,reshape(mean(dexp.head(dexp.coupe(1),dexp.yy,dexp.zz,t2),4),numel(dexp.yy),numel(dexp.zz))',10,'k','ShowText','on');
plot(dexp.y(dexp.yy),dexp.dem(dexp.coupe(1),dexp.yy),'k','lineWidth',2)
plot(dexp.y(dexp.yy),mean(dexp.wlevelextrap(dexp.coupe(1),dexp.yy,t2),3),'b','lineWidth',2)


subplot(2,3,6); box on; grid on; hold on;
h{6}=pcolor(Y,Z,reshape(mean(dexp.pressure(dexp.coupe(1),dexp.yy,dexp.zz,t3),4),numel(dexp.yy),numel(dexp.zz))');
set(h{6}, 'EdgeColor', 'none');
contour(Y,Z,reshape(mean(dexp.head(dexp.coupe(1),dexp.yy,dexp.zz,t3),4),numel(dexp.yy),numel(dexp.zz))',10,'k','ShowText','on');
plot(dexp.y(dexp.yy),dexp.dem(dexp.coupe(1),dexp.yy),'k','lineWidth',2)
plot(dexp.y(dexp.yy),mean(dexp.wlevelextrap(dexp.coupe(1),dexp.yy,t3),3),'b','lineWidth',2)






fig=figure('units','normalized','outerposition',[0 0 1 1]);


subplot(2,3,1); box on; grid on; hold on;
contourf(mean(dhomo.wlevelextrap(:,:,t1),3));ylabel('constant K');colorbar
    axis equal;title([datestr(T1) ' - ' datestr(T2)])

subplot(2,3,2); box on; grid on; hold on;
contourf(mean(dhomo.wlevelextrap(:,:,t2),3));colorbar
    axis equal;title([datestr(T2) ' - ' datestr(T3)])

subplot(2,3,3); box on; grid on; hold on;
contourf(mean(dhomo.wlevelextrap(:,:,t3),3));colorbar
    axis equal;title([datestr(T3) ' - ' datestr(T4)])

    
subplot(2,3,4); box on; grid on; hold on;
contourf(mean(dexp.wlevelextrap(:,:,t1),3));ylabel('exponential K');colorbar
    axis equal

subplot(2,3,5); box on; grid on; hold on;
contourf(mean(dexp.wlevelextrap(:,:,t2),3));colorbar
    axis equal

subplot(2,3,6); box on; grid on; hold on;
contourf(mean(dexp.wlevelextrap(:,:,t3),3));colorbar
    axis equal
