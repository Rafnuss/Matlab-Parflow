y1=5:10;
y2=11:15;
y3=16:19;


WSbpond1=reshape(sum(sum(d.subsurface.storage(:,y1,end-365:end),1),2),1,366);
WShill=reshape(sum(sum(d.subsurface.storage(:,y2,end-365:end),1),2),1,366);
WSbpond2=reshape(sum(sum(d.subsurface.storage(:,y3,end-365:end),1),2),1,366);
WSpond1=reshape(sum(sum(d.surface.storage(:,y1,end-365:end),1),2),1,366);
WSpond2=reshape(sum(sum(d.surface.storage(:,y3,end-365:end),1),2),1,366);



%fig=figure('units','normalized','outerposition',[0 0 1 1]);
% subplot(3,1,1); hold on; grid on;
%     [Y,Z]=meshgrid(datenum(d.date(end-365:end)),d.y);
%     h=pcolor(Y,Z,reshape(mean(d.flux.E.t(:,:,end-365:end),1),20,366));
%     set(h, 'EdgeColor', 'none');h2=colorbar('location','East');h2.Label.String = 'Total evaporation [m/hr]'; 
%    contour(Y,Z,reshape(mean(d.flux.E.t(:,:,end-365:end),1),20,366),[0,0],'r');
%    datetick('x');ylabel('distence y[m]');
%    caxis([min(min(min(d.flux.E.t(:,:,end-365:end)))) max(max(max(d.flux.E.t(:,:,end-365:end))))]);axis tight;
    


subplot(3,1,[2 3]); hold on; box on;
    plot(d.date(end-365:end),reshape(sum(sum(d.snow(:,:,end-365:end),1),2),366,1)/10,'k');
    plot(d.date(end-365:end),WSbpond1-WSbpond1(1))
    plot(d.date(end-365:end),WShill-WShill(1))
    plot(d.date(end-365:end),WSbpond2-WSbpond2(1))
    plot(d.date(end-365:end),WSpond2*10)
    plot(d.date(end-365:end),WSpond1*10)
    legend('snow [/10]','below lower pond','below hill','below upper pond','upper pond [x10]','lower pond [x10]')
    color=get(gca, 'ColorOrder');
    axis tight; ylabel('Change in storage [m^3]')


subplot(3,1,1); hold on;box on;
    area(d.y,reshape(mean(d.dem,1),1,numel(d.y)),'FaceColor',[102/255 51/255 0])
    area(d.y(y1),reshape(mean(d.dem(:,y1)),1,numel(y1)),'FaceColor',color(1,:))
    area(d.y(y2),reshape(mean(d.dem(:,y2)),1,numel(y2)),'FaceColor',color(2,:))
    area(d.y(y3),reshape(mean(d.dem(:,y3)),1,numel(y3)),'FaceColor',color(3,:))
    fill(d.y(y1),d.dem(:,y1),color(5,:))
    fill(d.y(y3),d.dem(:,y3),color(4,:))
    plot(d.y,min(d.wlevelextrap(d.coupe(1),1:numel(d.y),end-365:end),[],3),'--k');
    plot(d.y,max(d.wlevelextrap(d.coupe(1),1:numel(d.y),end-365:end),[],3),'--k');
    plot(d.y,mean(d.wlevelextrap(d.coupe(1),1:numel(d.y),end-365:end),3),'-ok');
    
   
    xlabel('y[m]');ylabel('elevation [m]');axis tight


