function plotMet(varargin)
d=varargin{1};
if nargin ==2
    t=varargin{2};
else
    t=1:d.time.nt;
end
figure('units','normalized','outerposition',[0 0 1 1]);
subplot(3,3,1); hold on; box on
plot(d.date(t),d.energy.Sin(t)');
xlabel('Time'); ylabel('Sin[W/m^2]');
subplot(3,3,2); hold on; box on
plot(d.date(t),d.energy.Lin(t));
xlabel('Time'); ylabel('Lin[W/m^2]');
subplot(3,3,3); hold on; box on
plot(d.date(t),d.flux.P(t));
xlabel('Time'); ylabel('P[mm/s]');
subplot(3,3,4); hold on; box on
plot(d.date(t),d.temp.a(t));
xlabel('Time'); ylabel('Tatm[K]');
subplot(3,3,5); hold on; box on
plot(d.date(t),d.windspeed.EW(t));
xlabel('Time'); ylabel('EWspeed[m/s]');
subplot(3,3,6); hold on; box on
plot(d.date(t),d.windspeed.NS(t));
xlabel('Time'); ylabel('NSspeed[m/s]');
subplot(3,3,7); hold on; box on
plot(d.date(t),d.air.pressure(t));
xlabel('Time'); ylabel('Press[Pa]');
subplot(3,3,8); hold on; box on
plot(d.date(t),d.air.SH(t));
xlabel('Time'); ylabel('[SH-]');
subplot(3,3,9); hold on; box on

end
