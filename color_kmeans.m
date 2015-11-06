TEST_PATH = 'data/imgs_subset';
N_CLUSTERS = 2;
SCALE = 0.2;

pathnames = dir(TEST_PATH);

for i=1:length(pathnames)
    if i < 3
        continue
    end
    pathname = pathnames(i).name
    img = imread(strcat(TEST_PATH, '/', pathname));
 
    resized = imresize(img, SCALE);
    resized = rgb2hsv(resized);
    pixel_matrix = reshape(resized,[size(resized,1)*size(resized,2), 3]);
    [idx, C] = kmeans(pixel_matrix, N_CLUSTERS);
    background_cluster = mode(idx);
    centroid_image = reshape(idx, [size(resized, 1), size(resized, 2)]);
    clustered_image = zeros(size(resized)); 

    for i=1:size(centroid_image,1)
        for j=1:size(centroid_image,2)
            if centroid_image(i,j) == background_cluster
                value = [1,0,1];
            else
                value = C(centroid_image(i,j),:);
            end
            clustered_image(i,j,:) = value;
        end
    end
    clustered_rgb = hsv2rgb(clustered_image);
    imshow(clustered_rgb);
    k = waitforbuttonpress;
end