img_path = 'data/imgs/w_0.jpg';
img = im2single(rgb2gray(imread(img_path)));
tic;
for i = 1:100
    test_points = detectSURFFeatures(img);
    [f,v] = extractFeatures(img,test_points);
end
time = toc

