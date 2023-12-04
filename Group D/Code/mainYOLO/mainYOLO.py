from ultralytics import YOLO
import cpuinfo
import torch
import cv2
import math
import time

# start webcam
cap = cv2.VideoCapture(0)
cap.set(3, 640)
cap.set(4, 480)

# allow model selection
print("Welcome to Camera Vision: YOLOv8!")
print("Creators: Michael Tolmajian, Youssef Ali, Javier Ramos, Ali Bou Haidar")
print("-----------------------------")
print("Please select a model of YOLOv8.")
print("Enter (1) for Nano")
print("Enter (2) for Small")
print("Enter (3) for Medium")
print("Enter (4) for Large")
print("Enter (5) for XLarge")
print("-----------------------------")

# initialize model
modelInput = input()
print("-----------------------------")
if modelInput == "1":
    print("Nano Model = \"yolov8n.pt\" selected.")
    model = YOLO('modelsYOLOv8/yolov8n.pt')
elif modelInput == "2":
    print("Small Model = \"yolov8s.pt\" selected.")    
    model = YOLO('modelsYOLOv8/yolov8s.pt')
elif modelInput == "3":
    print("Medium Model = \"yolov8m.pt\" selected.")    
    model = YOLO('modelsYOLOv8/yolov8m.pt')
elif modelInput == "4":
    print("Large Model = \"yolov8l.pt\" selected.")    
    model = YOLO('modelsYOLOv8/yolov8l.pt')
elif modelInput == "5":
    print("XLarge Model = \"yolov8x.pt\" selected.")    
    model = YOLO('modelsYOLOv8/yolov8x.pt')
else:
    print("Invalid input. Program terminated.")
    time.sleep(2)
    exit()

# allow device selection
print("-----------------------------")
print("Use your CPU or GPU?")
print("-----------------------------")
print("Please select the device to use.")
print("Enter (1) for Central Processing Unit (CPU)")
print("Enter (2) for Graphics Processing Unit (GPU)")
print("-----------------------------")

# initialize device
deviceInput = input()
print("-----------------------------")
if deviceInput == "1":
    print("CPU selected:")
    print('[' + cpuinfo.get_cpu_info()['brand_raw'] + ']')
    deviceStr = 'cpu'
elif deviceInput == "2":
    print("GPU selected:")
    print('[' + torch.cuda.get_device_name() + ']')
    deviceStr = 0
else:
    print("Invalid input. Program terminated.")
    time.sleep(2)
    exit()
print("Press (Q) to quit program.")
print("-----------------------------")
time.sleep(2)

# declare objects to be detected
classNames = ["person", "bicycle", "car", "motorbike", "airplane", "bus", "train", "truck", "boat",
              "traffic light", "fire hydrant", "stop sign", "parking meter", "bench", "bird", "cat",
              "dog", "horse", "sheep", "cow", "elephant", "bear", "zebra", "giraffe", "backpack", "umbrella",
              "handbag", "tie", "suitcase", "frisbee", "skis", "snowboard", "sports ball", "kite", "baseball bat",
              "baseball glove", "skateboard", "surfboard", "tennis racket", "bottle", "wine glass", "cup",
              "fork", "knife", "spoon", "bowl", "banana", "apple", "sandwich", "orange", "broccoli",
              "carrot", "hot dog", "pizza", "donut", "cake", "chair", "sofa", "potted plant", "bed",
              "dining table", "toilet", "TV monitor", "laptop", "mouse", "remote", "keyboard", "cell phone",
              "microwave", "oven", "toaster", "sink", "refrigerator", "book", "clock", "vase", "scissors",
              "teddy bear", "hair dryer", "toothbrush"
              ]
while True:
    ret, img= cap.read()
    results = model(img, stream=True, device=deviceStr)

    # coordinates
    for r in results:
        boxes = r.boxes

        for box in boxes:
            # bounding box
            x1, y1, x2, y2 = box.xyxy[0]
            x1, y1, x2, y2 = int(x1), int(y1), int(x2), int(y2) # convert to int values
            
            # confidence
            confidence = math.ceil((box.conf[0]*100))/100
            # class name
            cls = int(box.cls[0])

            # object details
            org = [x1, y1]
            font = cv2.FONT_HERSHEY_SIMPLEX
            fontScale = 1
            color = (255, 0, 0)
            thickness = 2
            
            cv2.rectangle(img, (x1, y1), (x2, y2), (255, 0, 255), 3) # put box in cam
            cv2.putText(img, classNames[cls], org, font, fontScale, color, thickness) # put text on box
            print("Confidence --->",confidence) # print confidence
            print("Class name -->", classNames[cls]) # print class name

    cv2.imshow('Webcam', img)
    if cv2.waitKey(1) == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
