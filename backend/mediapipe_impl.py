from mediapipe import solutions
from mediapipe.framework.formats import landmark_pb2
import mediapipe as mp
from mediapipe.tasks import python
from mediapipe.tasks.python import vision
import numpy as np
import cv2
from matplotlib import pyplot as plt

def process_video(userVideo, choreoVideo, uStart, cStart, detector, size=(1080,1920)):
    """
    Paramaters
    ---------
    video: file (mp4 format)
        a user-recorded, input video from the /analyze endpoint
    """
    uStart_msec, cStart_msec = uStart*1000, cStart*1000
    #read video with OpenCV VideoCaptrue
    user_video = cv2.VideoCapture(userVideo)
    choreo_video = cv2.VideoCapture(choreoVideo)
    ## video properties
    # user_width, user_height = int(user_video.get(3)), int(user_video.get(4))
    # choreo_width, choreo_height = int(choreo_video.get(3)), int(choreo_video.get(4))
    fps = user_video.get(cv2.CAP_PROP_FPS)
    video_size = (size[0]*2, size[1])
    user_record_at = uStart_msec - min(uStart_msec, cStart_msec)
    choreo_record_at = cStart_msec - min(uStart_msec, cStart_msec)
    user_video.set(cv2.CAP_PROP_POS_MSEC, user_record_at - (1000/30))
    choreo_video.set(cv2.CAP_PROP_POS_MSEC, choreo_record_at - (1000/30))
    # instatiate video writer for annotated frames
    final = cv2.VideoWriter('final.mp4', 
                        cv2.VideoWriter_fourcc(*'avc1'),
                        fps, video_size)
    user_ret, choreo_ret = True, True
    while user_ret and choreo_ret:
        user_ret, user_frame = user_video.read()
        choreo_ret, choreo_frame = choreo_video.read()
        if user_ret and choreo_ret:
            # initialize annotated frame
            user_frame = cv2.resize(user_frame, size)
            choreo_frame = cv2.resize(choreo_frame, size)
            ## process your frame, frame is a numpy array of your image
            user_annotated_frame = process_frame(user_frame, detector)
            choreo_annotated_frame = process_frame(choreo_frame, detector)
            combined_image = np.hstack((choreo_annotated_frame, user_annotated_frame)) 
            final.write(combined_image)
    # make sure to release
    user_video.release()
    choreo_video.release()
    final.release()
    return None

def process_frame(image, detector):
  rgb_frame = mp.Image(image_format=mp.ImageFormat.SRGB, data=cv2.cvtColor(image, cv2.COLOR_BGR2RGB))

  # STEP 3: Load the input image.
  # image = mp.Image.create_from_file("image.jpg")

  # STEP 4: Detect pose landmarks from the input image.
  detection_result = detector.detect(rgb_frame)

  # STEP 5: Process the detection result. In this case, visualize it.
  # annotated_image = draw_landmarks_on_image(image.numpy_view()[:,:,:3], detection_result)
  annotated_image = draw_landmarks_on_image(image, detection_result)

  # plt.imshow(cv2.cvtColor(annotated_image, cv2.COLOR_RGB2BGR))
  # plt.show()
  return annotated_image

def draw_landmarks_on_image(rgb_image, detection_result):
  pose_landmarks_list = detection_result.pose_landmarks
  annotated_image = np.copy(rgb_image)

  # Loop through the detected poses to visualize.
  for idx in range(len(pose_landmarks_list)):
    pose_landmarks = pose_landmarks_list[idx]

    # Draw the pose landmarks.
    pose_landmarks_proto = landmark_pb2.NormalizedLandmarkList()
    pose_landmarks_proto.landmark.extend([
      landmark_pb2.NormalizedLandmark(x=landmark.x, y=landmark.y, z=landmark.z) for landmark in pose_landmarks
    ])

    print(pose_landmarks_proto)
    solutions.drawing_utils.draw_landmarks(
      annotated_image,
      pose_landmarks_proto,
      solutions.pose.POSE_CONNECTIONS,
      solutions.drawing_styles.get_default_pose_landmarks_style())
  return annotated_image


def compare_videos():
  # STEP 2: Create an PoseLandmarker object.
  base_options = python.BaseOptions(model_asset_path='pose_landmarker_heavy.task')
  options = vision.PoseLandmarkerOptions(
      base_options=base_options,
      output_segmentation_masks=True)
  detector = vision.PoseLandmarker.create_from_options(options)

  choreo_vid = 'sakura_very_short.mp4'
  choreo_timestamp = 1.940
  user_vid = 'harrison.mov'
  user_timestamp = 1.220

  vid = process_video(user_vid, choreo_vid, user_timestamp, choreo_timestamp, detector)
  return vid

# img = cv2.imread("image.jpg")
# plt.imshow(img)

# from google.colab import files
# uploaded = files.upload()

# segmentation_mask = detection_result.segmentation_masks[0].numpy_view()
# visualized_mask = np.repeat(segmentation_mask[:, :, np.newaxis], 3, axis=2) * 255
# plt.imshow(visualized_mask)