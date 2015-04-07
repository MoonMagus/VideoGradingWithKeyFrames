a=rand(30,2);
hl = plot(a(:,1),a(:,2),'o');
hb=uicontrol('style','pushbutton','units','normal','position',[0.92,0.8,0.07,0.06],'string','| |','callback',@pauseplay);
while 1
x=get(hl, 'xdata');
y=get(hl, 'ydata');
set(hl,'xdata', x+(rand(size(x))-0.5)./10, 'ydata',y+(rand(size(y))-0.5)./10)
set(gca,'xlim', [min(x),max(x)], 'ylim', [min(y),max(y)])
pause(0.05)
end