clear all

label = tdfread('labels/labels_south_kmeans_matlab.tsv')

for i = 1:size(label.path,1)
    positiveInstances(i).imageFilename = label.path(i,:)
    positiveInstances(i).objectBoundingBoxes = label.box(i,:)
end

save('labels/south_labels.mat','positiveInstances');