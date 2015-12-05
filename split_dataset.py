import random

LABELS_FILENAME = 'labels/train.csv'
TRAINING_FILENAME = 'labels/training_set.csv'
TESTING_FILENAME = 'labels/testing_set.csv'

training_data = {}
test_data = []

with open(LABELS_FILENAME) as f:
	for i, line in enumerate(f):
		if i == 0:
			continue
		line = line.strip().split(',')
		whale = line[1]
		img = line[0]
		if whale in training_data:
			if random.random() < .9:
				training_data[whale].append(img)
			else:
				test_data.append((img,whale))
		else:
			training_data[whale] = [img]


out_train = open(TRAINING_FILENAME,'w')
for wh in training_data:
	for img in training_data[wh]:
		out_train.write(img+','+wh+'\n')
out_train.close()

out_test = open(TESTING_FILENAME,'w')
for tup in test_data:
	out_test.write(tup[0] + ',' + tup[1]+'\n')
out_test.close()