 ima = zeros(225,225);
 %ima = zeros(512,512);
[x,y] = size(ima);
for i = 1:225
    for j = 1:225
        ima(i,j) = images(i,j,1);
    end
end
k = 4;
kMeans = [54.2451,103.3722,145.5387,192.7866];
figure(1)
imshow(ima,[0,255]);

[New_ima,K_means] = k_means_histo1_4(ima,k);
figure(2)
imshow(New_ima,[0,255]);

figure(3)
histogram(New_ima);

figure(4)
histogram(ima);

[K_image,miu_k]=k_means_mathly1_1(ima,k);
figure(5)
imshow(K_image,[0,255]);

figure(6)
histogram(K_image);