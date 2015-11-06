SAT_PERCENTILE = 0.1;

TEST_PATH = 'data/imgs_subset';
pathnames = dir(TEST_PATH);

for i=1:length(pathnames)
    if i < 3
        continue
    end
    pathname = pathnames(i).name;
    img = imread(strcat(TEST_PATH, '/', pathname));
    imshow(img);
    hsv = rgb2hsv(img);
    sat = hsv(:,:,3);
    imshow(sat);
%     threshold = prctile(sat(:), 30);
%     foreground = sat < threshold;
%     foreground = imerode(foreground, ones(30,30));
%     imshow(foreground);
    k = waitforbuttonpress;
end