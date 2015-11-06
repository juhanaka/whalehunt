yous = load('rois_250-310.mat');
structs = yous.Head250310;

for i=1:length(structs)
    struct = structs(i);
    fname = struct.imageFilename;
    new_fname = regexprep(fname,'/Users/Youssef/Cours/Fall2016/EE368/Midterm', '/Users/juhanakangaspunta/stanford/whales/data')
    structs(i).imageFilename = new_fname;
end