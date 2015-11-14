POS_PATH = '/Users/Youssef/Cours/Fall2016/EE368/Midterm/whalehunt/labels/south_labels.mat';
NEG_PATH = '/Users/Youssef/Cours/Fall2016/EE368/Midterm/whalehunt/data/negatives';
FALSE_ALARM = 0.5;
NUM_STAGES = 15;
FEATURE_TYPE = 'LBP';

positives = load(POS_PATH);
trainCascadeObjectDetector('cascade.xml', positives.positiveInstances, ...
    NEG_PATH, 'NumCascadeStages',NUM_STAGES,'FalseAlarmRate',...
    FALSE_ALARM,'FeatureType',FEATURE_TYPE);