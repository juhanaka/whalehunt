import numpy
import cv2

SCALE_FACTOR = 1
MIN_SIZE = (30, 30)

def compare_boxes(gt_box, pred_box):
    return 0

def vizualize_head(img, boxes):
    for box in boxes:
        (x, y, w, h) = box
        cv2.rectangle(img, (x,y),(x+w,y+h),(255,0,0),2)
    screen_res = 1280, 720
    scale_width = screen_res[0] / float(img.shape[1])
    scale_height = screen_res[1] / float(img.shape[0])
    scale = min(scale_width, scale_height)
    print scale
    window_width = int(img.shape[1] * scale)
    window_height = int(img.shape[0] * scale)
    cv2.namedWindow('window', cv2.WINDOW_NORMAL)
    cv2.resizeWindow('window', window_width, window_height)
    tmp = cv2.resize(img,(window_width,window_height));
    cv2.imshow('window',tmp)
    cv2.waitKey(0)
    cv2.destroyAllWindows()

def get_performance(classifier, test_path_label):
    '''
    classifier is the trained classifier to test
    test_path_label is a TSV containing two columns: path of the original image, bounding box
    '''
    matches = 0
    tests = 0.0
    with open(test_path_label) as f:
        for i, line in enumerate(f):
            line = line.strip().split('\t')
            path_img = line[0]
            gt_box = [int(x) for x in line[2].split(' ')]
            # Read image and detect the whale
            path_parts = path_img.split('/')
            path_img = '/'.join(path_parts[1:])
            img = cv2.imread(path_img)
            print path_img
            gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
            pred_boxes = classifier.detectMultiScale(gray)
            print 'finished detecting'#,
             #scale_factor = SCALE_FACTOR, min_size = MIN_SIZE)
            vizualize_head(img, pred_boxes)
            matches += compare_boxes(gt_box,pred_boxes)
            tests += 1.0
    # return precision
    return matches/tests



classifier = cv2.CascadeClassifier('data/haarcascade_south/cascade.xml')
test_path_label = ('labels/labels_south.tsv')
get_performance(classifier,test_path_label)



