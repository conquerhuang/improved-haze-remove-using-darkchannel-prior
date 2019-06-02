function [g ] = improved_darkchannel( f,window_1,omega )
%改进了的暗通道滤波，将暗通道模板改为圆形模板，生成的暗通道图采用导向滤波增加边缘信息
%   此处显示详细说明
    if nargin==1
        window_1=5;
        omega=1;
    end
    eps=10^(-6);
    dark_chanal=get_dark_chanal(f,window_1);
    atmosphere = get_atmosphere(f, dark_chanal);%得到大气光照图
    [m,n,~]=size(f);
    rep_atmosphere = repmat(reshape(atmosphere, [1, 1, 3]), m, n);
    trans_est = 1 - omega * get_dark_chanal( f ./ rep_atmosphere, window_1);
    transmission=guidedfilter(rgb2gray(f),trans_est,4*window_1,eps);
 %   figure;imshow(transmission);
    transmission=-0.52*(transmission.^3)+1.28*(transmission.^2)+0.24;
%    figure;imshow(transmission);
    g = get_radiance(f, transmission, atmosphere);
    g=imadjust(g,[0,1],[0,1],0.75);
end

function [g]=get_dark_chanal(f,window_1)
%生成暗通道圆形模板
    mode=generate_circle(window_1);
    %增加图像尺寸，防止在后续的计算过程中受到边界干扰
    f=padarray(f,[window_1-1 window_1-1]/2,'replicate','both');
    %生成导向图
    gray=rgb2gray(f);
    %计算区域最小值，生成暗通道图
    min_chanal=imerode(min(f,[],3),mode);
    %进行导向滤波，以保留图像边缘信息
    g=imguidedfilter(min_chanal,gray);
%    g=min_chanal;
    %恢复图像原来尺寸
    g=g((window_1+1)/2:end-(window_1-1)/2,(window_1+1)/2:end-(window_1-1)/2,1:end);
end

