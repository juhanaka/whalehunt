FILENAME = 'labels/hard_neg_labels.txt';

examples = tdfread(FILENAME);
formatStr = 'data/hard_negatives/hard_neg%d.jpg';   % Output format for negatives
for i = 1:size(examples.path,1)
    current_path = strtrim(examples.path(i,:));
    current_bb = examples.BoundingBox(i,:);
    initialIm = imread(current_path);
    imcropped = imcrop(initialIm, current_bb);
    fileName = sprintf(formatStr,i);
    imwrite(imcropped,fileName); % Save negative images
end
    
    