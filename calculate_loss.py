import math

CLASSIFIED_WHALES_PATH = 'classified.csv'
LABELS_PATH = 'labels/train.csv'


def calculate_probabilities(f_classified):
    max_per_image = {}
    header = f_classified.readline()
    whale_ids = header.split(',')[1:]
    for line in f_classified:
        line_arr = line.split(',')
        img_name = line_arr[0].split('_b')[0] + '.png'
        if img_name not in max_per_image:
            max_per_image[img_name] = {}

        for i, n_matches in enumerate(line_arr[1:]):
            whale_name = whale_ids[i]
            n_matches = int(n_matches) ** 3
            max_per_image[img_name][whale_name] = max_per_image[img_name].get(whale_name, 0) + n_matches

    probs_per_image = {}
    for img_name in max_per_image:
        sum_of_matches = sum(max_per_image[img_name].values())
        if sum_of_matches == 0:
            {whale_name: 0 for whale_name in max_per_image[img_name]}
        else:
            probs = {whale_name: max_per_image[img_name][whale_name] / float(sum_of_matches) for whale_name in max_per_image[img_name]}
        probs_per_image[img_name] = probs
    return probs_per_image

def read_labels(f_labels):
    labels = {}
    for line in f_labels:
        img_name, whale_name = line.strip().split(',')
        labels[img_name] = whale_name
    return labels

def calculate_log_loss(probs, labels):
    s = 0
    for img_name in probs:
        label = labels[img_name.replace('png', 'jpg')]
        prob = max([min([probs[img_name][label],1-1e-15]),1e-15])
        s += math.log(prob)
    return (-1.0 / len(probs)) * s


def main():
    f_classified = open(CLASSIFIED_WHALES_PATH)
    f_labels = open(LABELS_PATH)

    probs = calculate_probabilities(f_classified)
    labels = read_labels(f_labels)
    loss = calculate_log_loss(probs, labels)
    print loss

if __name__ == '__main__':
    main()

