import cv2
import matplotlib
import numpy

def image_classification(model_weights, model_architecture, image):   
    blob = cv2.dnn.blobFromImage(image, 0.017, (224, 224), (103.94,116.78,123.68))
    global model, classes
    rows = open('Resources/model/denseNet/synset_words.txt').read().strip().split("\n")
    image_classes = [r[r.find(" ") + 1:].split(",")[0] for r in rows]
    model = cv2.dnn.readNetFromCaffe(model_architecture, model_weights)  
    model.setInput(blob)    
    output = model.forward()    
    new_output = output.reshape(len(output[0][:]))   
    expanded = np.exp(new_output - np.max(new_output))
    prob =  expanded / expanded.sum()    
    conf= np.max(prob)    
    index = np.argmax(prob)
    label = image_classes[index]   
    text = "Label: {}, {:.2f}%".format(label, conf*100)
    cv2.putText(image, "{}: {:.2f}% confidence".format(label, conf *100), (5, 40), cv2.FONT_HERSHEY_COMPLEX, 1, (255, 255, 255), 2)
model_architecture ='Resources/model/denseNet/DenseNet_121.prototxt.txt'
model_weights = 'Resources/model/denseNet/DenseNet_121.caffemodel'
image1 = cv2.imread('Resources/images/persian_cat.jpg')
classify1 = image_classification(model_weights, model_architecture, image1)
image2 = cv2.imread('Resources/images/dog.jpg')
classify2 = image_classification(model_weights, model_architecture, image2)
