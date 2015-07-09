%function screen2image(filename,d)
%SCREEN2JPEG Generate a JPEG file of the current figure with
%   dimensions consistent with the figure's screen dimensions.
%
%   SCREEN2JPEG('filename') saves the current figure to the
%   JPEG file "filename".
%
%    Sean P. McCarthy
%    Copyright (c) 1984-98 by MathWorks, Inc. All Rights Reserved
% if nargin < 1
%      error('Not enough input arguments!')
% end
cd(d.path.save);
oldscreenunits = get(gcf,'Units');
oldpaperunits = get(gcf,'PaperUnits');
oldpaperpos = get(gcf,'PaperPosition');
set(gcf,'Units','pixels');
scrpos = get(gcf,'Position');
newpos = scrpos/100;
set(gcf,'PaperUnits','inches',...
     'PaperPosition',newpos)
%print('-djpeg', filename, '-r200');
%print('-dpdf',filename,'-r200')
print('-dpng',filename,'-r200')
print('-depsc',filename,'-r200')
drawnow
set(gcf,'Units',oldscreenunits,...
     'PaperUnits',oldpaperunits,...
     'PaperPosition',oldpaperpos)
 cd([d.path.core '/post/plot']);