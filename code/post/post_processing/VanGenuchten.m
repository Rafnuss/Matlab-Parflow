function VanGenuchten(d)

perc=20/100; % plot +/- perc of the standard value

alpha=[d.soil.alpha-perc*d.soil.alpha d.soil.alpha d.soil.alpha+perc*d.soil.alpha];
n=[d.soil.n-perc*d.soil.n d.soil.n d.soil.n+perc*d.soil.n];
thetaR=d.soil.SRes;
thetaS=d.soil.SSat;

%press=linspace(min(d.pressure(:)),min([0 max(d.pressure(:))]),100);
press=-200:0;
k=1;
for i= alpha
    theta(k,:) = thetaR + (thetaS - thetaR)./( 1+(i .*abs(press)).^n(2) ).^(1-1/n(2));
    k=k+1;
end
for j = n
    theta(k,:) = thetaR + (thetaS - thetaR)./( 1+(alpha(2) .*abs(press)).^j ).^(1-1/j);
    k=k+1;
end


figure;box on; grid on; hold on;
plot(press,theta); 
xlabel('pressure [m]');ylabel('theta [-]')
legend(sprintf('alpha= %.3f | n= %.3f',alpha(1),n(2)),...
    sprintf('alpha= %.3f | n= %.3f',alpha(2),n(2)),...
    sprintf('alpha= %.3f | n= %.3f',alpha(3),n(2)),...
    sprintf('alpha= %.3f | n= %.3f',alpha(2),n(1)),...
    sprintf('alpha= %.3f | n= %.3f',alpha(2),n(2)),...
    sprintf('alpha= %.3f | n= %.3f',alpha(2),n(3)))