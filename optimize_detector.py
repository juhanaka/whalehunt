import numpy
import cv2

SCALE_FACTOR = 1
THRESHOLD_SUCCESS = .4
THRESHOLD_VALID_BOX = .25

'''
Compare two boxes: return (B1 AND B2) / (B1 OR B2) 
'''
def compare_boxes(gt_box, pred_box):
    x11 = gt_box[0]; x21 = pred_box[0]
    w1 = gt_box[2]; w2 = pred_box[2]
    x12 = x11 + w1; x22 = x21 + w2
    y11 = gt_box[1]; y21 = pred_box[1]
    h1 = gt_box[3]; h2 = pred_box[3]
    y12 = y11 + h1; y22 = y21 + h2

    x_overlap = max(0, min(x12,x22) -max(x11,x21))
    y_overlap = max(0, min(y12,y22) - max(y11,y21))
    overlap_area = x_overlap * y_overlap;

    gt_area = w1 * h1
    pred_area = w2 * h2
    union_area = float(gt_area + pred_area - overlap_area)
    print 'overlap ' ,overlap_area
    print 'union  ', union_area
    return (overlap_area/union_area)

'''
Checks if box aligns with the K-means mask
'''
def valid_box(box, mask_image_path):
    mask_img_or = cv2.imread(mask_image_path, cv2.CV_LOAD_IMAGE_GRAYSCALE)
    ret, mask_img = cv2.threshold(mask_img_or,127,1,cv2.THRESH_BINARY)
    
    #print max(mask_img.reshape(mask_img.size,1))
    '''
    cv2.namedWindow('mask', cv2.WINDOW_NORMAL)
    cv2.resizeWindow('mask', 1080, 720)
    mask_img_res = cv2.resize(mask_img,(1080,720));
    cv2.imshow('mask',numpy.multiply(mask_img_res,255))
    '''
    box_im = numpy.zeros(mask_img.shape)
    (x,y,w,h) = box
    box_im[y:y+h,x:x+w] = 1
    '''
    cv2.namedWindow('box', cv2.WINDOW_NORMAL)
    cv2.resizeWindow('box', 1080, 720)
    mask_img_res = cv2.resize(box_im,(1080,720));
    cv2.imshow('box',mask_img_res)
    cv2.waitKey(0)
    '''
    intersection_pixels = sum(sum(numpy.multiply(mask_img,box_im)))
    return intersection_pixels/float(h*w) > THRESHOLD_VALID_BOX

'''
Get overall precision of our model for the best bounding box
'''
def get_precision(gt_box, boxes):
    if len(boxes) == 0:
        return 0
    matches = []
    for box in boxes:
        matches.append(compare_boxes(box, gt_box))
    best_box = max(matches)
    print best_box
    if best_box > THRESHOLD_SUCCESS:
        return 1
    else:
        return 0

def vizualize_head(img, boxes, path_img, mask_image_path):
    k = 1
    for i,box in enumerate(boxes):
        (x, y, w, h) = box
        #if valid_box(box, mask_image_path):
        cv2.rectangle(img, (x,y),(x+w,y+h),(0,0,255),10)
        # Create cropped image from box
        current_output_image = img[y:y+h, x:x+w]
        original_img_name = path_img.split('/')[-1]
        current_output_name = original_img_name.split('.')[0] + '_' + str(k) +'.png'
        current_output_path = 'data/heads/'+current_output_name
        cv2.imwrite(current_output_path, current_output_image)
        k += 1
        #else:
            #cv2.rectangle(img, (x,y),(x+w,y+h),(0,255,0),2)
        #cv2.putText(img, str(i), (x,y),cv2.FONT_HERSHEY_PLAIN, 6, 10, thickness=5)
        print i,'\t' , path_img, '\t' , x, ' ',y,' ',w,' ',h
    screen_res = 1280, 720
    scale_width = screen_res[0] / float(img.shape[1])
    scale_height = screen_res[1] / float(img.shape[0])
    scale = min(scale_width, scale_height)
    window_width = int(img.shape[1] * scale)
    window_height = int(img.shape[0] * scale)
    cv2.namedWindow('window', cv2.WINDOW_NORMAL)
    cv2.resizeWindow('window', window_width, window_height)
    tmp = cv2.resize(img,(window_width,window_height));
    #cv2.imshow('window',tmp)
    #cv2.waitKey(0)
    cv2.destroyAllWindows()

def get_performance(classifier, test_path_label):
    '''
    classifier is the trained classifier to test
    test_path_label is a TSV containing two columns: path of the original image, bounding box
    '''
    matches = 0
    tests = 0.0
    correct_mask = 0
    with open(test_path_label) as f:
        for i, line in enumerate(f):
            if i > 500:
                break
            line = line.strip().split('\t')
            path_img = line[0]
            mask_image_path = 'data/kmeans_imgs/'+path_img.strip().split('/')[-1]
            gt_box = [int(x) for x in line[2].split(' ')]
            (x_gt, y_gt, w_gt, h_gt) = gt_box
            # Read image and detect the whale
            path_parts = path_img.split('/')
            path_img = '/'.join(path_parts[1:])
            img = cv2.imread(path_img)
            print path_img
            gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
            pred_boxes = classifier.detectMultiScale(gray, minSize = (200,200), maxSize = (700,700))#,
            current_match = get_precision(gt_box,pred_boxes)
            print 'precision ', current_match
            matches += current_match
            #cv2.rectangle(img, (x_gt,y_gt),(x_gt+w_gt,y_gt+h_gt),(0,0,255),2)

            # ESTIMATE PROBABILITY OF CORRECT MASK
            if valid_box(gt_box,mask_image_path):
                correct_mask += 1

            vizualize_head(img, pred_boxes, path_img, mask_image_path)
            tests += 1.0
    print correct_mask/tests
    # return precision
    return matches/tests

south_classifier = cv2.CascadeClassifier('data/haarcascade_south_FA35_with_hardneg/cascade.xml')
test_path_label = ('labels/labels_south.tsv')
precision = get_performance(south_classifier,test_path_label)
print precision



