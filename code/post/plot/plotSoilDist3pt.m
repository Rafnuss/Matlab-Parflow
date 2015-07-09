
warning('off','all');
x1=1;
y1=10;
x2=5;
y2=10;
x3=10;
y3=10;

fig=figure('units','normalized','outerposition',[0 0 1 1]);


subplot(4,1,1);hold on; box on;grid on;
    plot(d.date,100*reshape(d.snow(x1,y1,:),d.time.nt+1,1),'k');
    plot(d.date,24*1000*reshape(d.flux.E.t(x2,y2,:),d.time.nt+1,1),'--y')
    plot(d.date,10*(reshape(d.subsurface.storage(x3,y3,:)+d.surface.storage(x3,y3,:)-d.surface.storage(x3,y3,1)-d.subsurface.storage(x3,y3,1),d.time.nt+1,1)),':g');

    
    plot(d.date,100*reshape(d.snow(x2,y2,:),d.time.nt+1,1),'--k');
    plot(d.date,100*reshape(d.snow(x3,y3,:),d.time.nt+1,1),':k');
    
    plot(d.date,24*1000*reshape(d.flux.E.t(x1,y1,:),d.time.nt+1,1),'y')
    plot(d.date,24*1000*reshape(d.flux.E.t(x3,y3,:),d.time.nt+1,1),':y')
    
    plot(d.date,10*(reshape(d.subsurface.storage(x1,y1,:)+d.surface.storage(x1,y1,:)-d.surface.storage(x1,y1,1)-d.subsurface.storage(x1,y1,1),d.time.nt+1,1)),'g');
    plot(d.date,10*(reshape(d.subsurface.storage(x2,y2,:)+d.surface.storage(x2,y2,:)-d.surface.storage(x2,y2,1)-d.subsurface.storage(x2,y2,1),d.time.nt+1,1)),'--g');
    
    datetick('x','mmmm');xlim([datenum(d.date(1)) datenum(d.date(end))]);set(gca,'XTickLabel','');axis tight
    legend('Snow at hill [cm]','ET at middle [mm/d]','\Delta Storage at pond [dm]','Location','Best','Orientation','Horizontal')
    
    
    
subplot(4,1,2);hold on; box on; grid on;
    elev1=d.top.level(x1,y1)/d.grid.dz;
    [T,Z]=meshgrid(datenum(d.date),d.z((elev1-9):elev1));
    [T1,Z1]=meshgrid(datenum(d.date),d.z(1:elev1));
    
    h=pcolor(T,Z,reshape(d.temp.soil(x1,y1,:,:),10,d.time.nt+1));set(h, 'EdgeColor', 'none');
    contour(T,Z,reshape(d.temp.soil(x1,y1,:,:),10,d.time.nt+1),'k','ShowText','on','LineWidth',0.5);
    contour(T,Z,reshape(d.temp.soil(x1,y1,:,:),10,d.time.nt+1),[0 0],'r','ShowText','on','LineWidth',2);
    contour(T1,Z1,reshape(d.saturation(x1,y1,1:elev1,:),size(Z1,1),d.time.nt+1),'--','Color',[.5 .5 .5],'ShowText','on','LineWidth',0.25);
    line([datenum(d.date(1)) datenum(d.date(end))],[d.z(elev1) d.z(elev1)],'Color',[102/255 51/255 0],'LineWidth',2)
    plot(datenum(d.date),reshape(d.wlevelextrap(x1,y1,:),d.time.nt+1,1),'b','lineWidth',2)
    ylabel('Elevation [m]');
    datetick('x','mmmm');xlim([datenum(d.date(1)) datenum(d.date(end))]);drawnow
    ylim([max([0 min([reshape(d.grid.dz*d.wlevel(x1,y1,:),d.time.nt+1,1);min(Z(:))])]) max(Z(:)) ])    
    set(gca,'XTickLabel','');

    
subplot(4,1,3);hold on; box on; grid on;
    elev1=d.top.level(x2,y2)/d.grid.dz;
    [T,Z]=meshgrid(datenum(d.date),d.z((elev1-9):elev1));
    [T1,Z1]=meshgrid(datenum(d.date),d.z(1:elev1));
    
    h2=pcolor(T,Z,reshape(d.temp.soil(x2,y2,:,:),10,d.time.nt+1));set(h2, 'EdgeColor', 'none');
    contour(T,Z,reshape(d.temp.soil(x2,y2,:,:),10,d.time.nt+1),'k','ShowText','on','LineWidth',0.5);
    contour(T,Z,reshape(d.temp.soil(x2,y2,:,:),10,d.time.nt+1),[0 0],'r','ShowText','on','LineWidth',2);
    contour(T1,Z1,reshape(d.saturation(x2,y2,1:elev1,:),size(Z1,1),d.time.nt+1),'--','Color',[.5 .5 .5],'ShowText','on','LineWidth',0.25);
    line([datenum(d.date(1)) datenum(d.date(end))],[d.z(elev1) d.z(elev1)],'Color',[102/255 51/255 0],'LineWidth',2)
    plot(datenum(d.date),reshape(d.wlevelextrap(x2,y2,:),d.time.nt+1,1),'b','lineWidth',2)
    ylabel('Elevation [m]');
    datetick('x','mmmm');xlim([datenum(d.date(1)) datenum(d.date(end))]);drawnow
    ylim([max([0 min([reshape(d.grid.dz*d.wlevel(x2,y2,:),d.time.nt+1,1);min(Z(:))])]) max(Z(:)) ])    
    set(gca,'XTickLabel','');
    
    
subplot(4,1,4);hold on; box on; grid on;
    elev1=d.top.level(x3,y3)/d.grid.dz;
    [T,Z]=meshgrid(datenum(d.date),d.z((elev1-9):elev1));
    [T1,Z1]=meshgrid(datenum(d.date),d.z(1:elev1));
    
    h3=pcolor(T,Z,reshape(d.temp.soil(x3,y3,:,:),10,d.time.nt+1));set(h3, 'EdgeColor', 'none');
    contour(T,Z,reshape(d.temp.soil(x3,y3,:,:),10,d.time.nt+1),'k','ShowText','on','LineWidth',0.5);
    contour(T,Z,reshape(d.temp.soil(x3,y3,:,:),10,d.time.nt+1),[0 0],'r','ShowText','on','LineWidth',2);
    contour(T1,Z1,reshape(d.saturation(x3,y3,1:elev1,:),size(Z1,1),d.time.nt+1),'--','Color',[.5 .5 .5],'ShowText','on','LineWidth',0.25);
    line([datenum(d.date(1)) datenum(d.date(end))],[d.z(elev1) d.z(elev1)],'Color',[102/255 51/255 0],'LineWidth',2)
    plot(datenum(d.date),reshape(d.wlevelextrap(x3,y3,:),d.time.nt+1,1),'b','lineWidth',2)
    ylabel('Elevation [m]');
    datetick('x','mmmm');xlim([datenum(d.date(1)) datenum(d.date(end))]);drawnow
    ylim([max([0 min([reshape(d.wlevelextrap(x3,y3,:),d.time.nt+1,1);min(Z(:))])]) max([Z(:) ; max(d.wlevelextrap(x3,y3,:))]) ])    