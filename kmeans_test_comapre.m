% [x,y,z] = size(cellimage);
% ima = zeros(512,512);
% for i = 1:x
%     for j = 1:y
%         ima(i,j) =  cellimage(i,j,3);
%     end
% end
ima = rgb2gray(cellimage);
images = rgb2gray(cellimage);
% 4 clusters, kMeans are the correct answer
k = 3;
%kMeans = [54.2451,103.3722,145.5387,192.7866];
[miuk_ori, miuk_new, Kima,K_image_new]= kmeans_compare(ima,k);
figure(1)
imshow(ima,[0,256]);
figure(2)
imshow(Kima,[0,256]);
figure(3)
imshow(K_image_new,[0,256]);