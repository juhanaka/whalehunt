from os import listdir

'''
Preprocessing and data formatting:
script to create labeled data set based on the extracted bounding boxes,
rather than the whole image
'''

OUTPUT_FILE = 'labels/labeled_boxes_testing.csv'
FILE2POPULATE = 'labels/testing_set.csv'

# Get all boxes and map them to images
img2boxes = {}
path = 'data/labeled_heads'
for i, f in enumerate(listdir(path)):
	if f[0] == '.':
		continue
	img_name = 'w_'+f.split('_')[1]+'.jpg'
	if img_name in img2boxes:
		img2boxes[img_name].append(f)
	else:
		img2boxes[img_name] = [f]

# now create a new training/testing set based on boxes
out = open(OUTPUT_FILE,'w')
with open(FILE2POPULATE) as f:
	for i, line in enumerate(f):
		line = line.strip().split(',')
		img_name = line[0]
		whale = line[1]
		if img_name in img2boxes:
			for bb_img in img2boxes[img_name]:
				out.write(bb_img+','+whale+'\n')
		else:
			print img_name+' NOT FOUND'
out.close()
