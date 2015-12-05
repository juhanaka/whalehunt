%% Constants
TEST_SET_FILE = 'data/labeled_boxes_testing_subset.csv';
QUERY_SET_FILE = 'data/labeled_boxes_training.csv';
OUTPUT_FILE = 'classified.csv';
DATA_PATH = 'data/heads/';
WHALE_IDS_PATH = 'labels/unique_whale_ids.csv';

%% Model Parameters
MATCH_THRESHOLD = 1;
UNIQUE = false;
MAX_RATIO = 0.6;
METRIC = 'SSD';

%% Load whale ids
f = fopen(WHALE_IDS_PATH);
l = fgetl(f);
whale_ids = {};

while ischar(l)
    whale_ids = [whale_ids, strtrim(l)];
    l = fgetl(f);
end
fclose(f);

%% Process query set

f = fopen(QUERY_SET_FILE);
l = fgetl(f);
query_structs = {};

while ischar(l)
    parts = strsplit(l, ',');
    img_path = char(strcat(DATA_PATH, parts(1)));
    img = rgb2gray(im2single(imread(img_path)));
    points = detectSURFFeatures(img);
    [features, valid_points] = extractFeatures(img, points);
    s = struct('features', features, 'points', valid_points,...
               'label', parts(2));
    query_structs = [query_structs, s];
    l = fgetl(f);
end
fclose(f);


%% classify images

f = fopen(TEST_SET_FILE);
l = fgetl(f);
outf = fopen(OUTPUT_FILE, 'w');

fprintf(outf, strcat('Image,',strjoin(whale_ids, ',')));

lines = {};
while ischar(l)
    lines = [lines, l];
    l = fgetl(f);
end

fprintf('Classifying images...\n');
for line_idx=1:length(lines)
    disp(line_idx);
    l = lines{line_idx};
    img_path = char(strcat(DATA_PATH, l));
    test_img = rgb2gray(im2single(imread(img_path)));
    test_points = detectSURFFeatures(test_img);
    [features_test, valid_points_test] = extractFeatures(test_img, test_points);
    
    results = containers.Map;
    for q_idx=1:length(query_structs)
        q_struct = query_structs{q_idx};
        indexPairs = matchFeatures(features_test, q_struct.features,...
            'MatchThreshold', MATCH_THRESHOLD,...
            'Unique', UNIQUE, 'MaxRatio', MAX_RATIO,...
            'Metric', METRIC);
        n_matches = size(indexPairs, 1);
        if ~results.isKey(q_struct.label) || n_matches > results(q_struct.label)
            results(q_struct.label) = n_matches;
        end 
    end
    output_str = l;
    keys = results.keys;
    for i=1:length(whale_ids)
        id = char(whale_ids(i));
        value = '0';
        if results.isKey(id)
            value = int2str(results(id));
        end
        output_str = strcat(output_str, ',', value);
    end
    output_str = strcat(output_str, '\n');
    fprintf(outf, output_str);
end
fclose(f);
fclose(outf);