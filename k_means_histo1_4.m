function [K_image,miu_k,performance]=k_means_histo1_4(images,k)

%K_Means algorithm is to find k clusters, which could minimize the sum of
%the squared distance.
%" argmin?(i=1:k)?(x is in cluster s)||x_p-miu_p||^2 ",
%where miu_p is the mean of the specific cluster.

[x,y] = size(images); %size of the image
K_image = zeros(x,y);
miu_k=zeros(1,k);  % the vector to store the means of each clusters
Distance=zeros(1,k);% distance of (k-1 k and k+1)
Distance_new=zeros(1,k);  %distance after moving the element

totalDistance = 0; %the sum of squared distance
totalDistanceNew = 2; %the sum of squared distance after moving the element

%initial the K_means
temp = 255/(k-1);
% miu_k is the means of each clusters
miu_k = (255/(2*k)):255/k:255;


%miu_k_mid is used to initial the Index of each pixels
bounds = zeros(1,(k+1));
%means of cluster after moving element
miu_k_new=zeros(1,k);

%initial the cluster index
Index_p = zeros(x,y);

GTR = images; %copy of the images
counter = 0;
sum = zeros(1,k); %to calculate the mean value of each cluster
wcount = 0; % while loop counter
ID = 1; % temp value of index of the cluster of each pixels
average = zeros(1,k);
% initialize the bounds
% for i=1:(k-1)
%     bounds(i) = floor((miu_k(i)+miu_k(i+1))/2+0.5);
% end
bounds = zeros(1,(k+1));
bounds = 0:floor(255/k):255;
bounds(1) = 0;
bounds(k+1) = 255;
%get the histogram of the images
histo_image = zeros(1,256);
for i = 1:x
    for j = 1:y
        gray_ID = floor(GTR(i,j));
        histo_image(1,gray_ID+1) = histo_image(1,gray_ID+1) + 1;
    end
end

% go through the histogram to identify the bounds and clustering
while (wcount<6) %when the totalDistance is converge

    wcount = wcount+1;
    Distance=0;
    %Means of each cluster
    for i = 1:k
        number_cluster(i) = 0;
        sum(i) = 0;
        temp = 0;
        for m = (1+bounds(i)):1:bounds(i+1)
            number_grayl = histo_image(1,m);
            total_gl = number_grayl * m;
            sum(i) = sum(i) + total_gl;
            number_cluster(i) = number_cluster(i) + number_grayl;
        end
  
        if (number_cluster(i)~=0)
            miu_k(i) = (sum(i)/number_cluster(i))-1;
        end
%         for p=1:bounds(i+1)
%             for q=1:histo_image(p)
%                 if(number_cluster(i)~=0)
%                     temp = temp + p*(1/(2^number_cluster(i)));
%                     number_cluster = number_cluster -1;
%                 end
%             end
%         end
%         average(i) = temp;
%     end
    %bounds should be move then
    i=1;
    for i=1:(k-1)
        bounds(i+1) = floor((miu_k(i)+miu_k(i+1))/2+0.5);
    end
    bounds(1) = 0;
    bounds(k+1) = 255;
end
% reassign the image using the index.
for i=1:x
    for j=1:y
        for m=1:k
        if(GTR(i,j)<bounds(m+1))
            K_image(i,j) = miu_k(m);
            break;
        else
            K_image(i,j) = miu_k(k);
        end
    end
    end
end

% wcount %return the counts of while loop in command window
miu_k


end
