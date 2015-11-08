SRC_FOLDER = 'data/imgs_subset';
DST_FOLDER = 'data/sat_imgs';

pathnames = dir(SRC_FOLDER);

for i=1:length(pathnames)
    if i < 3
        continue
    end
    pathname = pathnames(i).name
    img = imread(strcat(SRC_FOLDER, '/', pathname));
    hsv = rgb2hsv(img);
    gray = hsv(:,:,2);
    imwrite(gray, strcat(DST_FOLDER, '/', pathname));
end