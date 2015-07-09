
%T(1)=datenum('01 september 2006');
T(1)=datenum('20 October 2002');
T(2)=datenum('18 Mars 2002');
T(3)=datenum('25 Mars 2002');
%T(5)=datenum('5 April 2007');
T(4)=datenum('1 June 2002');

t(1)=find(datenum(d.date)==T(1));
t(2)=find(datenum(d.date)==T(2));
t(3)=find(datenum(d.date)==T(3));
t(4)=find(datenum(d.date)==T(4));
%t(5)=find(datenum(d.date)==T(5));
%t(6)=find(datenum(d.date)==T(6));
[Y,Z]=meshgrid(d.y,d.z);

t=round(linspace(1,175,12));

for i=1:numel(t)
    subplot(3,4,i);hold on
    h=pcolor(X,Y,d.snow(:,:,t(i))');
    contour(X,Y,d.temp.soil(:,:,end,t(i)),[0 0],'r')
    %colorbar%('location','South')
    set(h, 'EdgeColor', 'none');
    xlabel(datestr(d.date(t(i))))
    caxis([0 max(d.snow(:))])
    axis tight
    axis equal
end
subplot(1,1,1); 
caxis([0 max(d.snow(:))])
