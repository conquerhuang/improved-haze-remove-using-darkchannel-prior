f=imread('2.png');

f=mat2gray(f);

tic

g=improved_darkchannel(f);

used_time=toc;

disp(['totally used time ' num2str(used_time) 's']);

figure

imshow([f g]);