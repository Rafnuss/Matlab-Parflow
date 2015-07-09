function Mayboom(d)


% Create the point
 d.pt.pond=[round(d.grid.nx/2) round(d.grid.ny/2)];
d.pt.mid=[round(d.grid.nx/2) round(d.grid.ny/4)];
d.pt.hill=[round(d.grid.nx/2) 1];
depth1=.5;
depth2=4;
depth3=9;
  
  
pt.pond{1} =[d.pt.pond max(0,round((d.dem(d.pt.pond(1),d.pt.pond(2))-depth1)/d.grid.dz))];
pt.pond{2} =[d.pt.pond max(0,round((d.dem(d.pt.pond(1),d.pt.pond(2))-depth2)/d.grid.dz))];
pt.pond{3} =[d.pt.pond max(0,round((d.dem(d.pt.pond(1),d.pt.pond(2))-depth3)/d.grid.dz))];
%pt.pond{1} =[d.pt.pond 12/d.grid.dz];
%pt.pond{2} =[d.pt.pond 3/d.grid.dz];
%pt.pond{3} =[d.pt.pond max(0,round((d.dem(d.pt.pond(1),d.pt.pond(2))-depth3)/d.grid.dz))];
pt.pond{4} = 'b';

pt.mid{1} =[d.pt.mid max(0,round((d.dem(d.pt.mid(1),d.pt.mid(2))-depth1)/d.grid.dz))];
pt.mid{2} =[d.pt.mid max(0,round((d.dem(d.pt.mid(1),d.pt.mid(2))-depth2)/d.grid.dz))];
pt.mid{3} =[d.pt.mid max(0,round((d.dem(d.pt.mid(1),d.pt.mid(2))-depth3)/d.grid.dz))];
%pt.mid{1} =[d.pt.mid 13/d.grid.dz];
%pt.mid{2} =[d.pt.mid 3/d.grid.dz];
%pt.mid{3} =[d.pt.mid max(0,round((d.dem(d.pt.mid(1),d.pt.mid(2))-depth3)/d.grid.dz))];
pt.mid{4} = 'g';

pt.hill{1} =[d.pt.hill max(0,round((d.dem(d.pt.hill(1),d.pt.hill(2))-depth1)/d.grid.dz))];
pt.hill{2} =[d.pt.hill max(0,round((d.dem(d.pt.hill(1),d.pt.hill(2))-depth2)/d.grid.dz))];
pt.hill{3} =[d.pt.hill max(0,round((d.dem(d.pt.hill(1),d.pt.hill(2))-depth3)/d.grid.dz))];
%pt.hill{1} =[d.pt.hill 13/d.grid.dz];
%pt.hill{2} =[d.pt.hill 3/d.grid.dz];
%pt.hill{3} =[d.pt.hill max(0,round((d.dem(d.pt.hill(1),d.pt.hill(2))-depth3)/d.grid.dz))];
pt.hill{4} = 'r';


%% plot the point (head)

fig=figure('units','normalized','outerposition',[0 0 1 1]);

subplot(3,2,1);hold on; grid on; box on
[X,Y]=ndgrid(d.x,d.y);contourf(X,Y,d.dem,'Lines','-.');axis equal
colormap('Gray')
plot(d.x(pt.pond{1}(1)),d.y(pt.pond{1}(2)),'rx','MarkerSize',10,'LineWidth',2)
%plot(d.x(pt.pond{2}(1)),d.y(pt.pond{2}(2)),'rx','MarkerSize',10,'LineWidth',2)
%plot(d.x(pt.pond{3}(1)),d.y(pt.pond{3}(2)),'-.rx','MarkerSize',10,'LineWidth',2)

plot(d.x(pt.mid{1}(1)),d.y(pt.mid{1}(2)),'bx','MarkerSize',10,'LineWidth',2)
%plot(d.x(pt.mid{2}(1)),d.y(pt.mid{2}(2)),'bx','MarkerSize',10,'LineWidth',2)
%plot(d.x(pt.mid{3}(1)),d.y(pt.mid{3}(2)),'-.bx','MarkerSize',10,'LineWidth',2)

plot(d.x(pt.hill{1}(1)),d.y(pt.hill{1}(2)),'gx','MarkerSize',10,'LineWidth',2)
%plot(d.x(pt.hill{2}(1)),d.y(pt.hill{2}(2)),'gx','MarkerSize',10,'LineWidth',2)
%plot(d.x(pt.hill{3}(1)),d.y(pt.hill{3}(2)),'-.gx','MarkerSize',10,'LineWidth',2)






subplot(3,2,2);hold on; grid on; box on
area(d.y,d.dem(d.coupe(1),:),'FaceColor',[102/255 51/255 0])

plot(d.y(pt.pond{1}(2)),d.z(pt.pond{1}(3)),'rx','MarkerSize',10,'LineWidth',2)
plot(d.y(pt.pond{2}(2)),d.z(pt.pond{2}(3)),'rv','MarkerSize',10,'LineWidth',2)
plot(d.y(pt.pond{3}(2)),d.z(pt.pond{3}(3)),'rs','MarkerSize',10,'LineWidth',2)

plot(d.y(pt.mid{1}(2)),d.z(pt.mid{1}(3)),'bx','MarkerSize',10,'LineWidth',2)
plot(d.y(pt.mid{2}(2)),d.z(pt.mid{2}(3)),'bv','MarkerSize',10,'LineWidth',2)
plot(d.y(pt.mid{3}(2)),d.z(pt.mid{3}(3)),'bs','MarkerSize',10,'LineWidth',2)

plot(d.y(pt.hill{1}(2)),d.z(pt.hill{1}(3)),'gx','MarkerSize',10,'LineWidth',2)
plot(d.y(pt.hill{2}(2)),d.z(pt.hill{2}(3)),'gv','MarkerSize',10,'LineWidth',2)
plot(d.y(pt.hill{3}(2)),d.z(pt.hill{3}(3)),'gs','MarkerSize',10,'LineWidth',2)

    plot(d.y,max(d.wlevelextrap(d.coupe(1),1:numel(d.y),:),[],3),'--k');
    plot(d.y,mean(d.wlevelextrap(d.coupe(1),1:numel(d.y),:),3)-std(d.wlevelextrap(d.coupe(1),1:numel(d.y),:),[],3),'--k');
    plot(d.y,mean(d.wlevelextrap(d.coupe(1),1:numel(d.y),:),3),'-ok');



subplot(3,2,[3,4,5,6]);hold on; grid on; box on

plot(d.date,reshape(d.head(pt.pond{1}(1),pt.pond{1}(2),pt.pond{1}(3),:),366,1),'-rx')
plot(d.date,reshape(d.head(pt.pond{2}(1),pt.pond{2}(2),pt.pond{2}(3),:),366,1),'-rv')
plot(d.date,reshape(d.head(pt.pond{3}(1),pt.pond{3}(2),pt.pond{3}(3),:),366,1),'-rs')

plot(d.date,reshape(d.head(pt.mid{1}(1),pt.mid{1}(2),pt.mid{1}(3),:),366,1),'-bx')
plot(d.date,reshape(d.head(pt.mid{2}(1),pt.mid{2}(2),pt.mid{2}(3),:),366,1),'-bv')
plot(d.date,reshape(d.head(pt.mid{3}(1),pt.mid{3}(2),pt.mid{3}(3),:),366,1),'-bs')

plot(d.date,reshape(d.head(pt.hill{1}(1),pt.hill{1}(2),pt.hill{1}(3),:),366,1),'-gx')
plot(d.date,reshape(d.head(pt.hill{2}(1),pt.hill{2}(2),pt.hill{2}(3),:),366,1),'-gv')
plot(d.date,reshape(d.head(pt.hill{3}(1),pt.hill{3}(2),pt.hill{3}(3),:),366,1),'-gs')
ylabel('head')

axis tight
