
LABEL_FILENAME = 'labels/labels.tsv'
DIRECTION_FILENAME = 'labels/direction_labels_0-499.tsv'
SOUTH_LABEL_FILENAME = 'labels/south500.tsv'
NORTH_LABEL_FILENAME = 'labels/north500.tsv'
EAST_LABEL_FILENAME = 'labels/east500.tsv'
WEST_LABEL_FILENAME = 'labels/west500.tsv'

south = open(SOUTH_LABEL_FILENAME, 'w')
north = open(NORTH_LABEL_FILENAME, 'w')
east = open(EAST_LABEL_FILENAME,'w')
west = open(WEST_LABEL_FILENAME,'w')

direction = open(DIRECTION_FILENAME)
with open(LABEL_FILENAME) as labels:
	for i, line in enumerate(labels):
		current_direction = direction.readline().strip().split('\t')[1]
		if current_direction == 's':
			south.write(line)
		elif current_direction == 'n':
			north.write(line)
		elif current_direction == 'e':
			east.write(line)
		elif current_direction == 'w':
			west.write(line)
south.close()
north.close()
east.close()
west.close()
direction.close()