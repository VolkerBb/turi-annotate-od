import turicreate as tc
import json

# # Name your model
modelName = "MyModel"

# # Build train JSON SFrame
with open('annotations.json') as j:
    annotations = json.load(j)

annotationData = tc.SFrame(annotations)
data = tc.load_images('images/')
data = data.join(annotationData)
trainData, testData = data.random_split(0.8)

# # Check ground truth
trainData['image_with_ground_truth'] =     tc.object_detector.util.draw_bounding_boxes(trainData['image'], trainData['annotations'])
# trainData.explore()

# # Train the model
model = tc.object_detector.create(trainData, feature="image", annotations="annotations", max_iterations=20)
model.save(modelName + '.model')

# # Predictions
predictions = model.predict(testData, confidence_threshold=0.0, verbose=True)
# predictions.explore()
metrics = model.evaluate(testData)
print('mAP: {:.1%}'.format(metrics['mean_average_precision_50']))
# metrics

# # Export model
model.export_coreml(modelName + '.mlmodel')
