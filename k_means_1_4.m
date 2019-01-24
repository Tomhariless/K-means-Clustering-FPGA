function [K_image,K_Means]=k_means_1_4(images,k)

%K_Means algorithm is to find k clusters, which could minimize the sum of
%the squared distance. " argmin?(i=1:k)?(x is in cluster s)||x_p-miu_p||^2 ",
%where miu_p is the mean of the specific cluster.

[x,y] = size(images); %size of the image
K_image = zeros(x,y);
K_Means=zeros(1,k);  % the vector to store the means of each clusters
Distance=zeros(1,3);% distance of (k-1 k and k+1)
Distance_new=0;
NewDistance = 0;
totalDistance = 0;
totalDistanceNew = 2;
%initial the K_means
temp = 255/(k-1);
% K_Means=[40,130,210];
K_Means = 0:temp:255;
K_Means_mid = zeros(1,(k-1));
K_Means_n=zeros(1,k);
%     K_Means = K_Means;
%initial the cluster index
Index = zeros(x,y);
%image with index
%GTR = zeros(x,y,k);
GTR = images;
counter = 0;
NewDistane = 0;
%initialize the K_Means_mid
for i=1:(k-1)
    K_Means_mid(i) = (K_Means(i)+K_Means(i+1))/2;
end
for i=1:x
    for j=1:y
        for m=1:(k-1)
            %find the index of the cluster for the pixcel
            if (GTR(i,j)<=K_Means_mid(m))
                Index(i,j) = m;
                break;
            else
                Index(i,j) = k; 
            end
                %cluster each pixcel in different cluster,
            %GTR is the image with Index
        end
    end
end
%to do the k-means clustering, there are three states: first is to
%calculate the mean of each clusters, second is to compare the distance
%between elements and means, third is to put the abnormal elements to
%a new cluster.
sum = zeros(1,k);
wcount = 0;
ID = 1;
while (totalDistance~=totalDistanceNew)
    totalDistance = 0;
    totalDistanceNew = 0;
    Distance_new = 0;
    wcount = wcount+1;
    %K_Means of each cluster
    for m = 1:k
        counter(m) = 0;
        sum(m) = 0;
        for i=1:x %image x and y
            for j=1:y
                if (Index(i,j)==m)
                    sum(m) = sum(m) + GTR(i,j);
                    counter(m) = counter(m)+1;
                end
            end
            
        end
        if (counter(m)~=0)
            K_Means(m) = sum(m)/counter(m);
        end
    end
    %comparsion of distance of each element and move
    for i=1:x
        for j=1:y
            ID = Index(i,j);
            if (ID==1)
                Distance(1) = 10000;
                Distance(2) = abs(GTR(i,j) - K_Means(ID));
                Distance(3) = abs(GTR(i,j) - K_Means(ID+1));
            elseif (ID>1 && ID<k)
                Distance(1) = abs(GTR(i,j) - K_Means(ID-1));
                Distance(2) = abs(GTR(i,j) - K_Means(ID));
                Distance(3) = abs(GTR(i,j) - K_Means(ID+1));
            else
                Distance(1) = abs(GTR(i,j) - K_Means(ID-1));
                Distance(2) = abs(GTR(i,j) - K_Means(ID));
                Distance(3) = 10000;
            end
            %old distance before moving the elements
            totalDistance = totalDistance + Distance(2)^2;
            % the means of each cluster is ordered, so only
            % need to compare with the neighbour, and change
            % the cluster of abnormal elements
            if (Distance(2)>Distance(1)&Distance(2)<Distance(3))
                Index(i,j) = ID-1;
            elseif (Distance(2)>Distance(3)&Distance(2)<Distance(1))
                Index(i,j) = ID+1;
            else
                Index(i,j) = ID;
            end
        end
    end
    %recalculate the K_Means of each cluster
    for m = 1:k
        counter_n(m) = 0;
        New_sum(m) = 0;
        for i=1:x 
            for j=1:y
                if (Index(i,j)==m)
                    New_sum(m) = New_sum(m) + GTR(i,j);
                    counter_n(m) = counter_n(m) +1;
%                 else
%                     New_sum(m) = New_sum(m) + 0;
                end
            end
        end
        if(counter_n(m)~=0)
            K_Means_n(m) = New_sum(m)/counter_n(m);
        end
    end
    %recalculate the distance between each element and mean
    for i=1:x
        for j=1:y
            ID = Index(i,j);
            Distance_new = abs(GTR(i,j) - K_Means_n(ID));
            %NewDistance = abs(GTR(i,j) - K_Means(ID));
            totalDistanceNew = totalDistanceNew + Distance_new^2;
        end
    end
end
% reassign the image using the index.

ID = 1;
for i=1:x
    for j=1:y
        ID = Index(i,j);
        K_image(i,j) = K_Means(ID);
    end

end
    wcount
end
