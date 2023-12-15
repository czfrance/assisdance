# assisdance

# Features

## Front-End / Formation

### Home

- **Create Unlimited Sets of Formations**
- **Analyze Dance Button**
  - Calls up a modal.
  - Asks for demo and user video, as well as start timestamps in seconds.
  - Submission makes API call to Python Flask backend for dance analysis (see backend section below).

### Set Creation

- Upon creation of a new set, specify the name and number of dancers.
- The first formation of a set is automatically created, initialized with the specified number of dancers on stage.
- Per formation,
  - Dancer icons are labeled with identifying numbers.
  - Drag around dancer icons on stage.
  - Icons cannot be moved outside of the stage area (move off the screen).
  - When moved, the icon becomes bigger (for better UI).
  - Specify the length of formation and transition in seconds.
  - Draw the transition path for a specified dancer.

### Draw Path 

- Displays the current formation with 100% opacity and the next formation with lesser opacity for easy identification.
- Only allows the user to draw 1 continuous line (to prevent confusion).
- User can clear the current path and draw again.
- Upon path confirmation, the user will move in this way to the next formation.

### Toggle Between Different Formations

- Moving formations from one to the next features the dancers animating to their next position.
  - If specified, the icon will follow the drawn path.
  - If not specified, the icon will take a straight line path.
- Users can add as many formations as desired.
- The stage is laid out in a grid for easy viewing.
- Dancer position is dynamic and will adjust based on the size of the stage displayed, so their location will always be relative to the grid.
- Save button to save formations to persistent storage.
- Analyze button makes API call to Python Flask backend to analyze set statistics for the current set (see backend section below).
- Export formations to PDF (in progress).

## Back-End / Analysis

- **Python Flask Server**
- Communicates with the front end via HTTP requests to the backend API.

### Formation Statistic Analysis
- Purpose: provide statistics on the holistic view of a user’s set of formations
- Receives API calls from front end app
- Takes in a list of formations in the set, each containing information such as dancer position and path to next formation, formation length, transition length, etc
- Iterates through the given information to calculate statistics based on these subcategories:
    - Entire Set summary
    - Per dancer summary
    - Per formation summary
    - Per transition summary
    - Step-by-Step summary

#### Entire Set Summary

- Provides aggregates, averages, and a summary of entire set information.
  - Num dancers.
  - Total length of piece.
  - Time spent dancing.
  - Transition time.
  - Total distance traveled.
  - Avg speed of transition (movement).
  - Avg size of formations.

#### Per Dancer Summary

- Provides aggregates, averages, and summary information for each individual dancer over the entire set.
  - Total distance traveled.
  - Avg transition speed.
  - Left/right time distribution.
  - Center time.
  - Front/back time distribution (of formation).
  - Summary of path taken on stage.

#### Per Formation Summary

- Provides aggregates, averages, and summary information for each individual formation.
  - Size (width, height) of formation.
  - Time in formation.
  - Total length (formation + transition).

#### Per Transition Summary

- Provides aggregates, averages, and summary information for each individual transition.
  - Time in transition.
  - Speed of transition.
  - Distance traveled.

#### Step-By-Step Summary

- Provides aggregates, averages, and summary information over each formation and combines relevant information about the dancers, formation, and transition taking place.
  - Total length (formation + transition).
  - Width.
  - Height.
  - Total traveled distance.
  - Average speed of movement (over all dancers).
  - Per dancer:
    - Name.
    - Distance traveled.
    - Speed of travel.
    - Position in formation (center, left/right, front/back).
    - Transition path.

### Dance Choreography Analysis

- Purpose: Analyze the user’s dancing accuracy compared to the original choreography demo.
- Takes in 2 videos of 1 person dancing: one should be the “example/original/demo” video, and the other being the user’s self-taken video, as well as timestamps in seconds denoting where the choreography starts in each video.
- Automatically aligns videos based on the given timestamp for frame-by-frame analysis.
- Uses MediaPipe’s pose estimation to find landmarks on the person’s body position in each video.
  - Relevant landmarks: Left and right shoulder, elbows, wrist, hip, knees, ankles, and foot.
- From the landmarks, connections are drawn.
- Conducts frame-by-frame analysis of each video to calculate angles between connections.
  - Left and right wrist, elbow, shoulder, inner hip, outer hip, knee, ankle angles.
- Compares all angles in each frame between demo and user video to calculate the percentage difference, as well as take note of which angles are too far different from the original.
- For each frame, “good” and “bad” body angles are written on the screen, which displays a side-by-side view of the original and user video with landmarks superimposed.
- In the end, a “percentage match” score is given (sort of like a karaoke score).
- Eventual goal: Received API calls from front-end app, is passed 2 videos and timestamps (not completely implemented).



# Project Setup and Running Instructions

## Frontend

1. Open XCode project.
2. Connect a physical device to the computer.
3. Select the physical device as the simulator target.
4. Click the play button.

## Backend

1. Open the backend directory in VSCode.

### One-time Setup:

- Create a Python environment (requires Python 3.10).
- Activate the Python environment:
  ```bash
  source [virtual environment name]/bin/activate
  ```
- install necessary packages

### To run the Flask App:
- Set flask environment
  ```bash
  source [virtual environment name]/bin/activate
  ```
- run the app
  ```bash
  source [virtual environment name]/bin/activate
  ```

From here, you should be able to make API calls from the frontend to the backend. Results to the API calls will be printed to terminal
- formation results: printed as a dictionary
- dance analysis results: final percentage match score is printed, comparison video name final.mp4 is uploaded to backend folder