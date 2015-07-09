

%T(1)=datenum('01 september 2006');
T(1)=datenum('20 October 2006');
T(2)=datenum('18 Mars 2007');
T(3)=datenum('25 Mars 2007');
%T(5)=datenum('5 April 2007');
T(4)=datenum('1 June 2007');

t(1)=find(datenum(d.date)==T(1));
t(2)=find(datenum(d.date)==T(2));
t(3)=find(datenum(d.date)==T(3));
t(4)=find(datenum(d.date)==T(4));
%t(5)=find(datenum(d.date)==T(5));
%t(6)=find(datenum(d.date)==T(6));
[Y,Z]=meshgrid(d.y,d.z);



%%
fig=figure('units','normalized','outerposition',[0 0 1 1]);
for i=1:numel(t)
    subplot(numel(t),1,i); hold on;
    h=pcolor(Y,Z,reshape(d.head(d.coupe(1),d.yy,d.zz,t(i)),numel(d.yy),numel(d.zz))');
    set(h, 'EdgeColor', 'none');
    plot(d.y,d.wlevelextrap(d.coupe(1),:,t(i)),'Color','b','lineWidth',2);
    contour(Y,Z,reshape(d.head(d.coupe(1),d.yy,d.zz,t(i)),numel(d.yy),numel(d.zz))',[10:0.1:11],'k','ShowText','on');
    plot(d.y(d.yy),d.dem(d.coupe(1),d.yy),'k','lineWidth',2);
    ylabel(datestr(T(i)));
end



%%
y=8:18;
[Y,Z]=meshgrid(d.y(y),d.z);
fig=figure('units','normalized','outerposition',[0 0 1 1]);hold on; box on
    h=pcolor(Y,Z,reshape(max(d.saturation(d.coupe(1),y,:,end-365:end),[],4)-min(d.saturation(d.coupe(1),y,:,end-365:end),[],4),numel(y),numel(d.zz))'); 
    set(h, 'EdgeColor', 'none');colormap('gray');colormap(flipud(colormap));    shading interp; 
    h2=colorbar('location','South');h2.Label.String = 'Seasonal change in water content [-]';
    plot(d.y(y),min(d.wlevelextrap(d.coupe(1),y,end-365:end),[],3),'--k');
    plot(d.y(y),max(d.wlevelextrap(d.coupe(1),y,end-365:end),[],3),'--k');
    plot(d.y(y),mean(d.wlevelextrap(d.coupe(1),y,end-365:end),3),'-ok');
    plot(d.y(y),d.dem(d.coupe(1),y),'Color','k','lineWidth',2);
    xlabel('Distence [m]');ylabel('Elevation [m]');legend('Seasonal water table fluctuation zone','Mean water table')
    axis tight
    
    
%%
y=8:18;
[Y,Z]=meshgrid(d.y(y),d.z);
fig=figure('units','normalized','outerposition',[0 0 1 1]);

subplot(3,1,1); hold on; box on;
    plot(d.y(y),mean(d.flux.E.t(d.coupe(1),y,end-365:end),3),'-ok');
    for i=1:numel(t);
        plot(d.y(y),d.flux.E.t(d.coupe(1),y,t(i)));
    end
    xlabel('');ylabel('Avearge of Total evaporation [m/hr]');legend('mean',datestr(T(1)),datestr(T(2)),datestr(T(3)),datestr(T(4)),'Ground level')
    axis tight;title('Total evaporation');
subplot(3,1,[2 3]); hold on; box on;
    plot(d.y(y),min(d.wlevelextrap(d.coupe(1),y,end-365:end),[],3),'--k');
    plot(d.y(y),max(d.wlevelextrap(d.coupe(1),y,end-365:end),[],3),'--k');
    plot(d.y(y),mean(d.wlevelextrap(d.coupe(1),y,end-365:end),3),'-ok');
    for i=1:numel(t);
        plot(d.y(y),d.wlevelextrap(d.coupe(1),y,t(i)));
    end
    plot(d.y(y),d.dem(d.coupe(1),y),'Color','k','lineWidth',2);title('Water table level');
    xlabel('Distence [m]');ylabel('Elevation [m]');legend('min','max','mean',datestr(T(1)),datestr(T(2)),datestr(T(3)),datestr(T(4)),'Ground level')
    axis tight




%%
n=numel(t);
fig=figure('units','normalized','outerposition',[0 0 1 1]);

for i=1:n
    if n<5
        subplot(2,2,i);
    elseif n<7
        subplot(3,2,i);
    elseif n<10
        subplot(3,3,i);
    elseif n<13;
        subplot(3,4,i);
    end
    hold on
    contourf(d.wlevelextrap(:,:,t(i)),5);
    [DX,DY] = gradient(-d.wlevelextrap(:,:,t(i)));
    quiver(DX,DY)
    axis equal;ylabel([datestr(T(i))])
    caxis([10 11])
end
