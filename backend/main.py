from flask import Blueprint, render_template, request, jsonify, session, make_response, current_app
import math
from enum import Enum
import json


main = Blueprint('main', __name__)


@main.route('/')
def index():
    return "hello world!"

@main.route('/profile')
def profile():
    return 'profile here'

@main.route("/test_post", methods=['POST'])
def test_post():
    print("\nTEST POST")
    print(request.get_json())

    return jsonify({"success": "data was posted"}), 200

@main.route("/test_get", methods=['GET'])
def test_get():
    print("\nTEST GET")
    print(request.get_json())

    return jsonify({"success": "data was gotted"}), 200

@main.route("/calc", methods=['POST'])
def calc():
    analysis_set = request.get_json()
    try:
        analysis_set = json.loads(analysis_set)
        results = analyze_formations(analysis_set)
        return jsonify(results), 200
    except Exception as e:
        return jsonify({'error': e}), 400


class HPosition(Enum):
    CENTER = 'center'
    LEFT = 'left'
    RIGHT = 'right'

class VPosition(Enum):
    FRONT = 'front'
    BACK = 'back'

def analyze_formations(anly_set):
    # print("start")
    formations = anly_set['formations']
    total_width = 0
    total_height = 0
    general_results = []
    formation_results = {}
    transition_results = {}
    num = anly_set['numDancers']
    set_results = {
        'dancers': num,
        'total_len': 0,
        'dance_time': 0,
        'transition_time': 0,
        'total_distance': 0,
        'avg_transition_speed': 0,
        'avg_formation_w': 0,
        'avg_formation_h': 0,
    }
    # key: dancerId
    # info: number, name, distance, lTime, rTime, cTime, fTime, bTime, path
    dancer_results = {}
    for dancer in formations[0]['dancers']:
        new_obj = {
            'name': dancer['name'],
            'number': dancer['number'],
            'distance': 0,
            'lTime': 0,
            'rTime': 0,
            'cTime': 0,
            'fTime': 0,
            'bTime': 0,
            'path': []
        }
        dancer_results[dancer['id']] = new_obj

    for i, formation in enumerate(formations):
        tag = formation['tag']
        print(f'formation {tag}')
        #calc formation stuff
        gen_info = {
            'total_len': formation['formationDuration'] + formation['transitionDuration'],
            'dancers': {}
        }
        formation_info = {
            'formation_time': formation['formationDuration'],
            'width': 0,
            'height': 0
        }
        #calc transition stuff
        transition_info = {
            'transition_time': formation['transitionDuration'],
            'total_distance': 0,
            'avg_speed': 0,
        }
        #calc dancer stuff
        dancers = formation['dancers']
        positions = [p['position'] for p in dancers]
        xpositions = [x['position'][0] for x in dancers]
        ypositions = [y['position'][1] for y in dancers]
        min_height = min(ypositions)
        max_height = max(ypositions)
        min_width = min(xpositions)
        max_width = max(xpositions)

        dancer_info = {}
        nextDancers = None if i == len(formations)-1 else formations[i+1]['dancers']
        for dancer in dancers:
            print(f"dancer {dancer['number']}")
            total_path = []
            total_path.append(dancer['position'])
            total_path.extend(dancer['path'])
            end = getNextPosition(nextDancers, dancer['id'])
            if end is not None: 
                total_path.append(end)
            distance_travelled = calc_dist_travelled(total_path)
            speed = distance_travelled / formation['transitionDuration']
            center = check_center(xpositions, positions, dancer['position'])
            if not center:
                left = findLeftorFront(min_width, max_width, dancer['position'][0])
                front = findLeftorFront(min_height, max_height, dancer['position'][1])
            else:
                left = False
                front = False

            temp = {
                'number': dancer['number'],
                'name': dancer['name'],
                'distance': distance_travelled,
                'speed': speed,
                'center': center,
                'left': left,
                'front': front,
                'path': total_path
            }
            gen_info['dancers'][dancer['id']] = temp
            transition_info["total_distance"] += distance_travelled

            #add path to total path
            #update results
            curr_dancer = dancer_results[dancer['id']]
            curr_dancer['path'].extend(dancer['path'])
            curr_dancer['distance'] = distance_travelled
            duration = formation['formationDuration']
            if center:
                curr_dancer['cTime'] += duration
            else: 
                curr_dancer['lTime'] = curr_dancer['lTime'] + duration if left == True else curr_dancer['lTime']
                curr_dancer['rTime'] = curr_dancer['rTime'] + duration if left == False else curr_dancer['rTime']
                curr_dancer['fTime'] = curr_dancer['fTime'] + duration if front == True else curr_dancer['fTime']
                curr_dancer['bTime'] = curr_dancer['bTime'] + duration if front == False else curr_dancer['bTime']
        
            dancer_results[dancer['id']] = curr_dancer

        #calc single set stuff
        formation_info['width'] = (max_width - min_width)*100
        formation_info['height'] = (max_height - min_height)*100
        # print(f"formation results before: {formation_results}")
        formation_results[formation['tag']] = formation_info
        # print(f"formation results after: {formation_results}")
        transition_info['avg_speed'] = transition_info["total_distance"] / len(dancers)
        transition_results[formation['tag']] = transition_info
        gen_info.update(formation_info)
        gen_info.update(transition_info)
        general_results.append(gen_info)

        #calc full set stuff
        total_width += (max_width - min_width)*100
        total_height += (max_height - min_height)*100
        set_results['total_len'] += gen_info["total_len"]
        set_results['dance_time'] += formation_info["formation_time"]
        set_results['transition_time'] += transition_info["transition_time"]
        set_results['total_distance'] += transition_info["total_distance"]

    #calc full set stuff
    set_results['avg_transition_speed'] = set_results['total_distance'] / (set_results['transition_time'] * num)
    set_results["avg_formation_w"] = total_width / len(formations)
    set_results["avg_formation_h"] = total_height / len(formations)

    ret = {
        'set_results': set_results,
        'dancer_results': dancer_results,
        'formation_results': formation_results,
        'transition_results': transition_results,
        'general_results': general_results,
    }

    return ret


def findLeftorFront(min, max, pos):
    mid = (min + max) / 2
    if pos < mid:
        return True
    return False


def check_center(xpos, pos, dpos):
    #criteria:
        #in center of the stage and center of the formation and noone is in front of them
        #or in center percentage of the formation and noone is in front
    x = dpos[0]
    y = dpos[1]
    center_stage = abs(x-0.5) < 0.1
    formation_center = (max(xpos) + min(xpos)) / 2
    center_formation = abs(x-formation_center) < 0.1
    not_middle = abs(formation_center - 0.5) > 0.09

    inFront = True
    for p in pos:
        dx = p[0]
        dy = p[1]
        if not (dx == x and dy == y):
            if abs(dx - x) < 0.03 and (dy < y) > 0.049: 
                inFront = False
    if (center_stage and inFront and center_formation) or (not_middle and center_formation and inFront):
        return True
    return False


def getNextPosition(nextForm, dId):
    if nextForm is None:
        return None
    
    for d in nextForm:
        if d['id'] == dId:
            return d['position']
    
    return None



def calc_dist_travelled(total_path):
    distance = 0
    for i in range(0, len(total_path)-1):
        distance += calc_dist(total_path[i], total_path[i+1])

    return distance
    

def calc_dist(p1, p2):
    p1x = p1[0]*100
    p1y = p1[1]*100
    p2x = p2[0]*100
    p2y = p2[1]*100

    d = math.sqrt(math.pow((p2x-p1x), 2) + math.pow((p2y-p1y), 2))
    return d
    

temp_test = {"formations":
    [
        {
            "formationDuration":5,
            "tag":0,
            "dancers":[
                {"name":"",
                    "id":"20AA3439-1FB8-4D8B-A069-1966B75DEF75",
                    "number":1,
                    "path":[],
                    "position":[0.1,0.5]},
                {"position":[0.2,0.5],
                    "id":"746102F1-B426-487C-B99E-43BFD42329D0",
                    "path":[],
                    "number":2,
                    "name":""},
                {"number":3,
                    "position":[0.30000000000000004,0.5],
                    "name":"",
                    "path":[],
                    "id":"9F530CA0-BC4C-43E6-A703-ABFEEFC01F67"},
                {"path":[],
                    "name":"",
                    "id":"79680441-C6E8-4C25-993D-30F3120C5402",
                    "number":4,
                    "position":[0.4,0.5]},
                {"name":"",
                    "position":[0.5,0.5],
                    "id":"99E691AD-32A8-47AD-A33C-EC3D921A427C",
                    "number":5,
                    "path":[]}],
                "name":"formation 1",
                "id":"67C475B7-6545-4C3E-93A7-D9E08C9F05C9",
                "transitionDuration":1},
        {
            "transitionDuration":1,"name":"formation 2","formationDuration":5,"id":"FC8BFE6C-871C-401B-BC6B-880B88A3682F","dancers":[{"number":1,"path":[],"id":"20AA3439-1FB8-4D8B-A069-1966B75DEF75","position":[0.18304297328687574,0.33739837398373984],"name":""},{"number":2,"position":[0.2847851335656214,0.3265582655826558],"id":"746102F1-B426-487C-B99E-43BFD42329D0","path":[],"name":""},{"number":3,"id":"9F530CA0-BC4C-43E6-A703-ABFEEFC01F67","position":[0.45911730545876894,0.25687185443283],"path":[],"name":""},{"position":[0.6427409988385598,0.21815718157181574],"path":[],"name":"","number":4,"id":"79680441-C6E8-4C25-993D-30F3120C5402"},{"name":"","position":[0.7839721254355401,0.31804103755323265],"path":[],"id":"99E691AD-32A8-47AD-A33C-EC3D921A427C","number":5}],"tag":1},
            {"formationDuration":5,"tag":2,"transitionDuration":2.000000000000001,"id":"55D4C0BE-85E7-4D85-9E48-638B76D69FFB","dancers":[{"id":"20AA3439-1FB8-4D8B-A069-1966B75DEF75","path":[],"number":1,"position":[0.12380952380952381,0.7098335269066977],"name":""},{"id":"746102F1-B426-487C-B99E-43BFD42329D0","position":[0.2632984901277584,0.759388308168796],"path":[],"number":2,"name":""},{"position":[0.3342624854819977,0.6873790166473093],"name":"","number":3,"id":"9F530CA0-BC4C-43E6-A703-ABFEEFC01F67","path":[]},{"path":[],"id":"79680441-C6E8-4C25-993D-30F3120C5402","number":4,"position":[0.47665505226480837,0.6494386372435152],"name":""},{"number":5,"name":"","id":"99E691AD-32A8-47AD-A33C-EC3D921A427C","position":[0.5725900116144018,1.0660085172280294],"path":[]}],"name":"formation 3"},
            {"tag":3,"id":"D141338A-4249-4338-B99F-AC22BF9B60A6","transitionDuration":1,"dancers":[{"id":"20AA3439-1FB8-4D8B-A069-1966B75DEF75","name":"","number":1,"path":[],"position":[0.7329849012775842,0.6726674409601239]},{"number":2,"name":"","id":"746102F1-B426-487C-B99E-43BFD42329D0","position":[0.7801393728222996,0.759388308168796],"path":[]},{"number":3,"name":"","id":"9F530CA0-BC4C-43E6-A703-ABFEEFC01F67","position":[0.6472706155632986,0.5456833139759969],"path":[]},{"path":[],"name":"","id":"79680441-C6E8-4C25-993D-30F3120C5402","number":4,"position":[0.7728222996515679,0.40940766550522645]},{"id":"99E691AD-32A8-47AD-A33C-EC3D921A427C","name":"","number":5,"position":[0.5725900116144018,1.0660085172280294],"path":[]}],"name":"formation 4","formationDuration":5}
    ],
    "numDancers":5,
    "name":"set 1",
    "id":"F4DAE3A5-7EEB-4B9A-80DB-05B3598AE16E"}

results = analyze_formations(temp_test)
print(results)


"""
{"formations":
    [
        {
            "formationDuration":5,
            "tag":0,
            "dancers":[
                {"name":"",
                    "id":"20AA3439-1FB8-4D8B-A069-1966B75DEF75",
                    "number":1,
                    "path":[],
                    "position":[0.1,0.5]},
                {"position":[0.2,0.5],
                    "id":"746102F1-B426-487C-B99E-43BFD42329D0",
                    "path":[],
                    "number":2,
                    "name":""},
                {"number":3,
                    "position":[0.30000000000000004,0.5],
                    "name":"",
                    "path":[],
                    "id":"9F530CA0-BC4C-43E6-A703-ABFEEFC01F67"},
                {"path":[],
                    "name":"",
                    "id":"79680441-C6E8-4C25-993D-30F3120C5402",
                    "number":4,
                    "position":[0.4,0.5]},
                {"name":"",
                    "position":[0.5,0.5],
                    "id":"99E691AD-32A8-47AD-A33C-EC3D921A427C",
                    "number":5,
                    "path":[]}],
                "name":"formation 1",
                "id":"67C475B7-6545-4C3E-93A7-D9E08C9F05C9",
                "transitionDuration":1},
        {
            "transitionDuration":1,"name":"formation 2","formationDuration":5,"id":"FC8BFE6C-871C-401B-BC6B-880B88A3682F","dancers":[{"number":1,"path":[],"id":"20AA3439-1FB8-4D8B-A069-1966B75DEF75","position":[0.18304297328687574,0.33739837398373984],"name":""},{"number":2,"position":[0.2847851335656214,0.3265582655826558],"id":"746102F1-B426-487C-B99E-43BFD42329D0","path":[],"name":""},{"number":3,"id":"9F530CA0-BC4C-43E6-A703-ABFEEFC01F67","position":[0.45911730545876894,0.25687185443283],"path":[],"name":""},{"position":[0.6427409988385598,0.21815718157181574],"path":[],"name":"","number":4,"id":"79680441-C6E8-4C25-993D-30F3120C5402"},{"name":"","position":[0.7839721254355401,0.31804103755323265],"path":[],"id":"99E691AD-32A8-47AD-A33C-EC3D921A427C","number":5}],"tag":1},
            {"formationDuration":5,"tag":2,"transitionDuration":2.000000000000001,"id":"55D4C0BE-85E7-4D85-9E48-638B76D69FFB","dancers":[{"id":"20AA3439-1FB8-4D8B-A069-1966B75DEF75","path":[],"number":1,"position":[0.12380952380952381,0.7098335269066977],"name":""},{"id":"746102F1-B426-487C-B99E-43BFD42329D0","position":[0.2632984901277584,0.759388308168796],"path":[],"number":2,"name":""},{"position":[0.3342624854819977,0.6873790166473093],"name":"","number":3,"id":"9F530CA0-BC4C-43E6-A703-ABFEEFC01F67","path":[]},{"path":[],"id":"79680441-C6E8-4C25-993D-30F3120C5402","number":4,"position":[0.47665505226480837,0.6494386372435152],"name":""},{"number":5,"name":"","id":"99E691AD-32A8-47AD-A33C-EC3D921A427C","position":[0.5725900116144018,1.0660085172280294],"path":[]}],"name":"formation 3"},
            {"tag":3,"id":"D141338A-4249-4338-B99F-AC22BF9B60A6","transitionDuration":1,"dancers":[{"id":"20AA3439-1FB8-4D8B-A069-1966B75DEF75","name":"","number":1,"path":[],"position":[0.7329849012775842,0.6726674409601239]},{"number":2,"name":"","id":"746102F1-B426-487C-B99E-43BFD42329D0","position":[0.7801393728222996,0.759388308168796],"path":[]},{"number":3,"name":"","id":"9F530CA0-BC4C-43E6-A703-ABFEEFC01F67","position":[0.6472706155632986,0.5456833139759969],"path":[]},{"path":[],"name":"","id":"79680441-C6E8-4C25-993D-30F3120C5402","number":4,"position":[0.7728222996515679,0.40940766550522645]},{"id":"99E691AD-32A8-47AD-A33C-EC3D921A427C","name":"","number":5,"position":[0.5725900116144018,1.0660085172280294],"path":[]}],"name":"formation 4","formationDuration":5}
    ],
    "numDancers":5,
    "name":"set 1",
    "id":"F4DAE3A5-7EEB-4B9A-80DB-05B3598AE16E"}

"""