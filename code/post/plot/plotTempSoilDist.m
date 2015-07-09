function plotTempSoilDist(d)
warning('off','all');
x1=1;
%d.pt.pond(1);
y1=1;%d.pt.pond(2);
elev1=d.top.level(x1,y1)/d.grid.dz;

[T,Z]=meshgrid(datenum(d.date),d.z((elev1-9):elev1));
[T1,Z1]=meshgrid(datenum(d.date),d.z(1:elev1));


fig=figure('units','normalized','outerposition',[0 0 1 1]);
Rect=get(gcf,'DefaultaxesPosition');
Rect(1)=Rect(1)-0.05;
%Rect = [0.19, 0.07, 0.775, 0.845];
AxisPos = moPlotPos(1, 4, Rect);


%subplot(4,1,1);hold on; box on;grid on;
axes('Position', [AxisPos(1,1) AxisPos(1,2)-0.05 AxisPos(1,3) AxisPos(1,4)+0.05]); hold on; box on;grid on;
    plot(d.date,reshape(d.snow(x1,y1,:),d.time.nt+1,1),'k');
    plot(d.date,100*(reshape(d.surface.storage(x1,y1,:),d.time.nt+1,1)-d.surface.storage(x1,y1,1)),'g');
    plot(d.date,100*(reshape(d.subsurface.storage(x1,y1,:),d.time.nt+1,1)-d.subsurface.storage(x1,y1,1)),'m');
    bar(datenum(d.date),24*1000*d.flux.P);
    %plot(d.date,reshape(d.flux.I(x1,y1,:),d.time.nt+1,1)*24,'g')
    plot(d.date,24*1000*reshape(d.flux.E.t(x1,y1,:),d.time.nt+1,1),'y')
    plot(d.date,24*1000*reshape(d.flux.R(x1,y1,:),d.time.nt+1,1),'r')
    
    
%     X=[datenum(d.date) datenum(d.date) datenum(d.date)];
%     Y1=[reshape(d.snow(x1,y1,:)/1000,d.time.nt+1,1) reshape(d.surface.storage(x1,y1,:),d.time.nt+1,1) reshape(d.subsurface.storage(x1,y1,:),d.time.nt+1,1)-d.subsurface.storage(x1,y1,1) ];
%     Y2=1000*[d.flux.P reshape(d.flux.E.t(x1,y1,:),d.time.nt+1,1) reshape(d.flux.R(x1,y1,:),d.time.nt+1,1)];
%     [AX,H1,H2] =plotyy(X,Y1,X,Y2);   
%     set(H1(1),'Color','k');set(H1(2),'Color','g');set(H1(3),'Color','m');
%     set(H2(1),'Color','b');set(H2(2),'Color','y');set(H2(3),'Color','r');
%     xlim(AX(1),[datenum(d.date(1)) datenum(d.date(end))]); xlim(AX(2),[datenum(d.date(1)) datenum(d.date(end))]); 
%     ylim(AX(2),[0 max(d.flux.P)]);ylim(AX(1),[0 max([d.snow(:)/1000; d.subsurface.storage(:)-d.subsurface.storage(1)])])
%     ylabel(AX(1),'[m]');ylabel(AX(2),'[m/hr]');
    
    datetick('x','mmmm');xlim([datenum(d.date(1)) datenum(d.date(end))]);set(gca,'XTickLabel','');axis tight
    legend('Snow [mm]','\Delta S_{surf} [cm]','\Delta S_{sub} [cm]','Precipitation [mm]','ET [mm]','Runoff [mm]','Location','Best','Orientation','Horizontal')
    %legend('Snow','Precipitation','ET','Runoff','Location','North','Orientation','Horizontal')
    
    
%subplot(4,1,2);hold on; box on;grid on;
axes('Position', [AxisPos(2,1) AxisPos(2,2)-0.03 AxisPos(2,3) AxisPos(2,4)+0.03]);hold on;box on;grid on;
    plot(d.date,d.temp.a);plot(d.date,reshape(d.temp.grnd(x1,y1,:),d.time.nt+1,1));
    plot([datenum(d.date(1)) datenum(d.date(end))],[0 0],'--k')
    xlim([datenum(d.date(1)) datenum(d.date(end))]); ylim([min([d.temp.a(:) ; d.temp.grnd(:)]) max([d.temp.a(:) ; d.temp.grnd(:)])])
    ylabel('Temperature [C]');datetick('x','mmmm');xlim([datenum(d.date(1)) datenum(d.date(end))]);set(gca,'XTickLabel','');
    legend('Air','Ground','Location','Best');

    
    
%subplot(2,1,2); hold on; box on;
axes('Position', [AxisPos(4, 1:3) 2.5*AxisPos(3,4)]);hold on; box on; grid on;
    %h=pcolor(T1,Z1,repmat(reshape(d.temp.grnd(x1,y1,:),1,d.time.nt+1),size(Z1,1),1));set(h, 'EdgeColor', 'none');
    h=pcolor(T,Z,reshape(d.temp.soil(x1,y1,:,:),10,d.time.nt+1));set(h, 'EdgeColor', 'none');
    contour(T,Z,reshape(d.temp.soil(x1,y1,:,:),10,d.time.nt+1),'k','ShowText','on','LineWidth',0.5);
    contour(T,Z,reshape(d.temp.soil(x1,y1,:,:),10,d.time.nt+1),[0 0],'r','ShowText','on','LineWidth',2); %[d.soil.SRes 0.18  0.2 0.4 d.soil.SSat],
    contour(T1,Z1,reshape(d.saturation(x1,y1,1:elev1,:),size(Z1,1),d.time.nt+1),'--','Color',[.5 .5 .5],'ShowText','on','LineWidth',0.25);
    line([datenum(d.date(1)) datenum(d.date(end))],[d.z(elev1) d.z(elev1)],'Color',[102/255 51/255 0],'LineWidth',2)
    plot(datenum(d.date),reshape(d.wlevelextrap(x1,y1,:),d.time.nt+1,1),'b','lineWidth',2)
    ylabel('Elevation [m]');
    datetick('x','mmmm');xlim([datenum(d.date(1)) datenum(d.date(end))]);drawnow
    ylim([max([0 min([reshape(d.grid.dz*d.wlevel(x1,y1,:),d.time.nt+1,1);min(Z(:))])]) max(Z(:)) ])
    %caxis([0 20]); shading interp
    
    
    
axes('Position', [AxisPos(4,1)+AxisPos(4,3)+0.01 AxisPos(4,2) 0.13 2.5*AxisPos(3,4)]);hold on; box on; grid on;
    ind=find(d.temp.a<0); t=min(ind):max(ind);
    T=reshape(d.temp.soil(x1,y1,:,t),10,numel(t));
    set(gca,'YTickLabel','')
    [D,Z2]=meshgrid(datenum(d.date(t)),d.z((elev1-9):elev1));
    c = linspace(1,10,length(D(:)));
    n=hist3([T(:) Z2(:)]);n1 = n';
    n1(size(n,1) + 1, size(n,2) + 1) = 0;
    %h = pcolor(linspace(min(T(:)),max(T(:)),size(n,1)+1),linspace(min(Z(:)),max(Z(:)),size(n,1)+1),n1);
	plot(mean(T,2),d.z((elev1-9):elev1),'k')
    plot(mean(T,2)-std(T,1,2),d.z((elev1-9):elev1),'--k')
    plot(mean(T,2)+std(T,1,2),d.z((elev1-9):elev1),'--k')
    scatter(T(:),Z2(:),10,c,'fill','d');xlabel('T [°C]')
    axis tight

    
str1=sprintf('\nPrecipitation: %2.0f [mm]  \nET total: %2.0f [mm]  \nAverage snow: %3.1f [mm] (%d days) \nWatertable:  %4.1f[mAD]  \n\nK_{s}: %s [m/hr]\nS_{res}-por-S_{sat}: %s   \n\nT_{air}: %2.2f (+/- %2.2f)  \nfreezing indice: %2.1f \nT_{ini}: %2.1f [°C]  \n\nSoil cover: %s',...
    nanmean(d.flux.P)*24*numel(d.date)*1000,...
    nanmean(d.flux.E.t(x1,y1,:))*24*numel(d.date)*1000,...
    nanmean(d.snow(d.snow>0)),...
    sum(d.snow(x1,y1,:)>0),...
    d.ICPressVal,...
    [num2str(d.perm(1,1,1),3) '-' num2str(d.perm(1,1,end),3) '[m/hr] (Kosugi)'],...
    [num2str(d.soil.SRes) '-' num2str(d.soil.porosity) '-' num2str(d.soil.SSat)],...
    nanmean(d.temp.a),...
    nanstd(d.temp.a),...
    numel(d.temp.soil(d.temp.soil<=0))/numel(d.date)/10*100,...
    d.temp.a(2),...
    'Bare soil');

annotation('textbox',[AxisPos(4,1)+AxisPos(4,3)+0.01 AxisPos(2,2)-0.03 0.13 2.5*AxisPos(3,4)],'String',str1)
drawnow

% cd([d.info.chemin '/post/save']);
% screen2jpeg('plotTempSoilDist')
% saveas(fig,'plotTempSoilDist')
% cd([d.info.chemin '/post/plot']);
% close all


