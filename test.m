TEST_PATH = 'data/imgs_subset';
DETECTOR_PATH = 'cascade.xml';

MINSIZE = [300, 300];
MERGE_THRESHOLD = 10;

detector = vision.CascadeObjectDetector(DETECTOR_PATH, 'MinSize', MINSIZE,...
                                        'MergeThreshold', 10);

pathnames = dir(TEST_PATH);

for i=1:length(pathnames)
    if i < 3
        continue
    end
    pathname = pathnames(i).name
    img = imread(strcat(TEST_PATH, '/', pathname));
    bbox = step(detector, img);
    detectedImg = insertObjectAnnotation(img,'rectangle',bbox,'whale');
    imshow(detectedImg);
    k = waitforbuttonpress;
end