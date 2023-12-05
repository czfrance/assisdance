from mediapipe import solutions
from mediapipe.framework.formats import landmark_pb2
import mediapipe as mp
from mediapipe.tasks import python
from mediapipe.tasks.python import vision
import numpy as np
from numpy.linalg import norm
import cv2
from matplotlib import pyplot as plt

def calculate_angle(a,b,c):
    a = np.array(a) # First
    b = np.array(b) # Mid
    c = np.array(c) # End
    
    radians = np.arctan2(c[1]-b[1], c[0]-b[0]) - np.arctan2(a[1]-b[1], a[0]-b[0])
    angle = np.abs(radians*180.0/np.pi)
    
    if angle >180.0:
        angle = 360-angle
        
    return angle

def process_video(userVideo, choreoVideo, uStart, cStart, detector, size=(1080,1920)):
    """
    Paramaters
    ---------
    video: file (mp4 format)
        a user-recorded, input video from the /analyze endpoint
    """
    angle_names = ['Left Shoulder', 'Left Elbow', 'Left Outer Hip', 'Left Inner Hip', 'Left Knee', 'Left Ankle',
            'Right Shoulder', 'Right Elbow', 'Right Outer Hip', 'Right Inner Hip', 'Right Knee', 'Left Knee']
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
    count = 0
    similarity = 0
    while user_ret and choreo_ret:
        user_ret, user_frame = user_video.read()
        choreo_ret, choreo_frame = choreo_video.read()
        if user_ret and choreo_ret:
            # initialize annotated frame
            user_frame = cv2.resize(user_frame, size)
            choreo_frame = cv2.resize(choreo_frame, size)
            ## process your frame, frame is a numpy array of your image
            user_annotated_frame, user_angles = process_frame(user_frame, detector)
            choreo_annotated_frame, choreo_angles = process_frame(choreo_frame, detector)

            # similarity += 1/(1 + np.linalg.norm(np.array(choreo_angles)-np.array(user_angles)))
            # count += 1
            good_angles = ""
            bad_angles = ""
            if user_angles and choreo_angles:
              temp = 0
              for i in range(len(user_angles)):
                if i < len(user_angles)-1:
                  choreo = [choreo_angles[i], choreo_angles[i+1]]
                  user = [user_angles[i], user_angles[i+1]]
                  temp += np.dot(choreo,user)/(norm(choreo)*norm(user))
                # print(f"({user_angles[i]}, {choreo_angles[i]})")
                if abs(choreo_angles[i] - user_angles[i]) < 5:
                  good_angles += f"{angle_names[i]}\n"
                else:
                  #  print("bad")
                  bad_angles += f"{angle_names[i]}\n"
              similarity += (temp / len(user_angles))
              count += 1
                 
            combined_image = np.hstack((choreo_annotated_frame, user_annotated_frame))

            font = cv2.FONT_HERSHEY_SIMPLEX
            scale = 2.5
            thickness = 5
            h, w, _ = combined_image.shape
            y = h-20
            for i, curr_angle in enumerate(good_angles.split('\n')):
                cv2.putText(combined_image, curr_angle, (20, y), font, scale, (0, 255, 0), thickness, cv2.LINE_AA)
                (_, text_height), _ = cv2.getTextSize(curr_angle, font, scale, thickness)
                y -= (2*text_height)

            y = h-20
            x = int((w/2)+20)
            for i, curr_angle in enumerate(bad_angles.split('\n')):
                cv2.putText(combined_image, curr_angle, (x, y), font, scale, (0, 0, 255), thickness, cv2.LINE_AA) 
                (_, text_height), _ = cv2.getTextSize(curr_angle, font, scale, thickness)
                y -= (2*text_height)

            final.write(combined_image)
    # make sure to release
    user_video.release()
    choreo_video.release()
    final.release()

    return (similarity / count) * 100

def process_frame(image, detector):
  rgb_frame = mp.Image(image_format=mp.ImageFormat.SRGB, data=cv2.cvtColor(image, cv2.COLOR_BGR2RGB))

  # STEP 4: Detect pose landmarks from the input image.
  detection_result = detector.detect(rgb_frame)

  # STEP 5: Process the detection result. In this case, visualize it.
  # annotated_image = draw_landmarks_on_image(image.numpy_view()[:,:,:3], detection_result)
  annotated_image = draw_landmarks_on_image(image, detection_result)

  # get landmark locations
  mp_pose = mp.solutions.pose
  if len(detection_result.pose_landmarks) == 0:
     return annotated_image, None
  
  landmarks = detection_result.pose_landmarks[0]
  lWrist = [landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].x,landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].y]
  lElbow = [landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].x,landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].y]
  lShoulder = [landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].x,landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].y]
  lHip = [landmarks[mp_pose.PoseLandmark.LEFT_HIP.value].x,landmarks[mp_pose.PoseLandmark.LEFT_HIP.value].y]
  lKnee = [landmarks[mp_pose.PoseLandmark.LEFT_KNEE.value].x,landmarks[mp_pose.PoseLandmark.LEFT_KNEE.value].y]
  lAnkle = [landmarks[mp_pose.PoseLandmark.LEFT_ANKLE.value].x,landmarks[mp_pose.PoseLandmark.LEFT_ANKLE.value].y]
  lFoot = [landmarks[mp_pose.PoseLandmark.LEFT_FOOT_INDEX.value].x,landmarks[mp_pose.PoseLandmark.LEFT_FOOT_INDEX.value].y]
  rWrist = [landmarks[mp_pose.PoseLandmark.RIGHT_WRIST.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_WRIST.value].y]
  rElbow = [landmarks[mp_pose.PoseLandmark.RIGHT_ELBOW.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_ELBOW.value].y]
  rShoulder = [landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].y]
  rHip = [landmarks[mp_pose.PoseLandmark.RIGHT_HIP.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_HIP.value].y]
  rKnee = [landmarks[mp_pose.PoseLandmark.RIGHT_KNEE.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_KNEE.value].y]
  rAnkle = [landmarks[mp_pose.PoseLandmark.RIGHT_ANKLE.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_ANKLE.value].y]
  rFoot = [landmarks[mp_pose.PoseLandmark.RIGHT_FOOT_INDEX.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_FOOT_INDEX.value].y]

  #calculate angles
  lShoulder_angle = calculate_angle(rShoulder, lShoulder, lElbow)
  lElbow_angle = calculate_angle(lShoulder, lElbow, lWrist)
  lHip_outer_angle = calculate_angle(lShoulder, lHip, lKnee)
  lHip_inner_angle = calculate_angle(rHip, lHip, lKnee)
  lKnee_angle = calculate_angle(lHip, lKnee, lAnkle)
  lAnkle_angle = calculate_angle(lKnee, lAnkle, lFoot)
  rShoulder_angle = calculate_angle(lShoulder, rShoulder, rElbow)
  rElbow_angle = calculate_angle(rShoulder, rElbow, rWrist)
  rHip_outer_angle = calculate_angle(rShoulder, rHip, rKnee)
  rHip_inner_angle = calculate_angle(lHip, rHip, rKnee)
  rKnee_angle = calculate_angle(rHip, rKnee, rAnkle)
  rAnkle_angle = calculate_angle(rKnee, rAnkle, rFoot)

  angles = [lShoulder_angle, lElbow_angle, lHip_outer_angle, lHip_inner_angle, lKnee_angle, lAnkle_angle,
            rShoulder_angle, rElbow_angle, rHip_outer_angle, rHip_inner_angle, rKnee_angle, rAnkle_angle]

  # plt.imshow(cv2.cvtColor(annotated_image, cv2.COLOR_RGB2BGR))
  # plt.show()
  return annotated_image, angles

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

    solutions.drawing_utils.draw_landmarks(
      annotated_image,
      pose_landmarks_proto,
      solutions.pose.POSE_CONNECTIONS,
      solutions.drawing_styles.get_default_pose_landmarks_style())
  return annotated_image


def compare_videos(choreo_path, choreo_start, user_path, user_start):
  # STEP 2: Create an PoseLandmarker object.
  base_options = python.BaseOptions(model_asset_path='pose_landmarker_heavy.task')
  options = vision.PoseLandmarkerOptions(
      base_options=base_options,
      output_segmentation_masks=True)
  detector = vision.PoseLandmarker.create_from_options(options)

  choreo_vid = choreo_path
  choreo_timestamp = choreo_start
  user_vid = user_path
  user_timestamp = user_start

  score = process_video(user_vid, choreo_vid, user_timestamp, choreo_timestamp, detector)
  return score

# img = cv2.imread("image.jpg")
# plt.imshow(img)

# from google.colab import files
# uploaded = files.upload()

# segmentation_mask = detection_result.segmentation_masks[0].numpy_view()
# visualized_mask = np.repeat(segmentation_mask[:, :, np.newaxis], 3, axis=2) * 255
# plt.imshow(visualized_mask)