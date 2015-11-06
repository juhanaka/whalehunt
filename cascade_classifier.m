POS_PATH = '/Users/juhanakangaspunta/stanford/whales/rois_0-249.mat';
NEG_PATH = '/Users/juhanakangaspunta/stanford/whales/data/negatives';
FALSE_ALARM = 0.5;
NUM_STAGES = 15;
FEATURE_TYPE = 'LBP';

positives = load(POS_PATH);
trainCascadeObjectDetector('cascade.xml', positives.positiveInstances, ...
    NEG_PATH, 'NumCascadeStages',NUM_STAGES,'FalseAlarmRate',...
    FALSE_ALARM,'FeatureType',FEATURE_TYPE);