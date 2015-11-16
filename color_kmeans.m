SRC_FOLDER = 'data/imgs';
DST_FOLDER = 'data/kmeans_imgs';
N_CLUSTERS = 3;
SCALE = 0.3;
IMAGES_RNG = 1:1000;
IMG_PREFIX = 'w_';
IMG_POSTFIX = '.jpg';

for i=IMAGES_RNG
    img = imread(strcat(SRC_FOLDER, '/', IMG_PREFIX, int2str(i), IMG_POSTFIX));
    resized = imresize(img, SCALE);
    hsv = rgb2hsv(resized);
    pixel_matrix = reshape(hsv,[size(hsv,1)*size(hsv,2), 3]);
    [idx, C] = kmeans(pixel_matrix, N_CLUSTERS);
    background_cluster = mode(idx);
    centroid_image = reshape(idx, [size(hsv, 1), size(hsv, 2)]);
    clustered_image = zeros(size(hsv)); 

    for i=1:size(centroid_image,1)
        for j=1:size(centroid_image,2)
            if centroid_image(i,j) == background_cluster
                value = [0,0,0];
            else
                value = [1,0,1];
            end
            clustered_image(i,j,:) = value;
        end
    end
    binary = clustered_image(:,:,1);
    eroded = imerode(binary, ones(5, 5));
    labels = bwlabel(eroded);
    labels(labels == 0) = NaN;
    dominant = mode(labels(:));
    labels(labels ~= dominant) = 0;
    mask = labels ./ dominant;
    mask = imdilate(mask, ones(20,20));
    mask = imresize(mask, 1/SCALE);
    mask = mask(1:size(img, 1),1:size(img,2));
    imwrite(mask, strcat(DST_FOLDER, '/', pathname));
end