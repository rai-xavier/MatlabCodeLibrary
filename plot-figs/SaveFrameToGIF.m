function SaveFrameToGIF(fignum,framenum, fn_gif, FPS)

frame = getframe(fignum);

im = frame2im(frame);
[imind,cm] = rgb2ind(im,256);

if framenum == 1
    imwrite(imind,cm,fn_gif,'gif', 'Loopcount',inf,'DelayTime',1/FPS);
else
    imwrite(imind,cm,fn_gif,'gif','WriteMode','append','DelayTime',1/FPS);
end

return
end