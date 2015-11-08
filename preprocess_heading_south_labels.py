''' Preprocess data, pipe output into labels file'''

LIST_FILENAME = 'labels/list_south.txt'
LABEL_FILENAME = 'labels/labels.tsv'

image_names_south = []
with open(LIST_FILENAME) as f:
	for line in f:
		image_names_south.append(line.strip())

with open(LABEL_FILENAME) as l:
	for line in l:
		fields = line.strip().split('\t')
		image_name = fields[0].split('/')[-1]
		if image_name in image_names_south:
			print line.strip()
