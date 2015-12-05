import numpy
import cv2


THRESHOLD_VALID_BOX = .25
IMAGES_PATHS_FILENAME = 'data/train_copy.csv'

'''
Checks if box aligns with the K-means mask
'''
def valid_box(box, mask_image_path):
    mask_img_or = cv2.imread(mask_image_path, cv2.CV_LOAD_IMAGE_GRAYSCALE)
    ret, mask_img = cv2.threshold(mask_img_or,127,1,cv2.THRESH_BINARY)
    box_im = numpy.zeros(mask_img.shape)
    (x,y,w,h) = box
    box_im[y:y+h,x:x+w] = 1
    intersection_pixels = sum(sum(numpy.multiply(mask_img,box_im)))
    return intersection_pixels/float(h*w) > THRESHOLD_VALID_BOX

south_classifier = cv2.CascadeClassifier('data/haarcascade_south_FA35_with_hardneg/cascade.xml')
north_classifier = cv2.CascadeClassifier('data/haarcascade_north/cascade.xml')
east_classifier = cv2.CascadeClassifier('data/haarcascade_east/cascade.xml')
west_classifier = cv2.CascadeClassifier('data/haarcascade_west/cascade.xml')

with open(IMAGES_PATHS_FILENAME) as f:
    for i,line in enumerate(f):
        if i == 0:
            continue
        img_name = line.strip().split(',')[0]
        print img_name
        path_img = 'data/imgs/'+img_name
        mask_image_path = 'data/kmeans_imgs/'+img_name
        # Read image and detect the whale
        img = cv2.imread(path_img)
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        south_boxes = south_classifier.detectMultiScale(gray, minSize = (200,200), maxSize = (700,700))
        north_boxes = north_classifier.detectMultiScale(gray, minSize = (200,200), maxSize = (700,700))
        east_boxes = east_classifier.detectMultiScale(gray, minSize = (200,200), maxSize = (700,700))
        west_boxes = west_classifier.detectMultiScale(gray, minSize = (200,200), maxSize = (700,700))
        
        if len(south_boxes) > 0 :
            boxes = south_boxes
        else:
            boxes = numpy.ndarray(shape=(0,4))

        if len(north_boxes) > 0:
            boxes = numpy.vstack([boxes, north_boxes])
        if len(east_boxes) > 0:
            boxes = numpy.vstack([boxes, east_boxes])
        if len(west_boxes) > 0:
            boxes = numpy.vstack([boxes, west_boxes])

        for k,box in enumerate(boxes):
            if valid_box(box, mask_image_path):
                # we output it
                (x, y, w, h) = box
                current_output_image = img[y:y+h, x:x+w]
                current_output_name = img_name.split('.')[0] + '_b' + str(k) +'.png'
                current_output_path = 'data/labeled_heads/'+current_output_name
                cv2.imwrite(current_output_path, current_output_image)




