QUERY_IMG_PATH = 'data/heads/w_7812_b2.png';
DB_IMG_PATHS = {'data/heads/w_934_b0.png', 'data/heads/w_15_b81.png'};   

query_img = rgb2gray(im2single(imread(QUERY_IMG_PATH)));
db_imgs = {};

MATCH_THRESHOLD = 1;
UNIQUE = false;
MAX_RATIO = 0.6;
METRIC = 'SSD';

for path_idx=1:length(DB_IMG_PATHS)
    db_imgs = [db_imgs, rgb2gray(im2single(imread(DB_IMG_PATHS{path_idx})))];
end

points_q = detectSURFFeatures(query_img);
imshow(query_img); hold on;
plot(points_q.selectStrongest(20));


for img_idx=1:length(db_imgs)
    db_img = db_imgs{img_idx};
    points_db = detectSURFFeatures(db_img);
    [features_q, valid_points_q] = extractFeatures(query_img, points_q);
    [features_db, valid_points_db] = extractFeatures(db_img, points_db);
    indexPairs = matchFeatures(features_q, features_db,...
        'MatchThreshold', MATCH_THRESHOLD,...
        'Unique', UNIQUE, 'MaxRatio', MAX_RATIO,...
        'Metric', METRIC);
    matchedPoints_q = valid_points_q(indexPairs(:, 1), :);
    matchedPoints_db = valid_points_db(indexPairs(:, 2), :);
    figure; ax = axes;
    showMatchedFeatures(query_img,db_img,matchedPoints_q,matchedPoints_db,'montage', 'Parent',ax);
    legend(ax,'Matched points 1','Matched points 2');
end