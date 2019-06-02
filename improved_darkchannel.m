function [g ] = improved_darkchannel( f,window_1,omega )
%�Ľ��˵İ�ͨ���˲�������ͨ��ģ���ΪԲ��ģ�壬���ɵİ�ͨ��ͼ���õ����˲����ӱ�Ե��Ϣ
%   �˴���ʾ��ϸ˵��
    if nargin==1
        window_1=5;
        omega=1;
    end
    eps=10^(-6);
    dark_chanal=get_dark_chanal(f,window_1);
    atmosphere = get_atmosphere(f, dark_chanal);%�õ���������ͼ
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
%���ɰ�ͨ��Բ��ģ��
    mode=generate_circle(window_1);
    %����ͼ��ߴ磬��ֹ�ں����ļ���������ܵ��߽����
    f=padarray(f,[window_1-1 window_1-1]/2,'replicate','both');
    %���ɵ���ͼ
    gray=rgb2gray(f);
    %����������Сֵ�����ɰ�ͨ��ͼ
    min_chanal=imerode(min(f,[],3),mode);
    %���е����˲����Ա���ͼ���Ե��Ϣ
    g=imguidedfilter(min_chanal,gray);
%    g=min_chanal;
    %�ָ�ͼ��ԭ���ߴ�
    g=g((window_1+1)/2:end-(window_1-1)/2,(window_1+1)/2:end-(window_1-1)/2,1:end);
end

