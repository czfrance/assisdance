from flask import Blueprint, render_template, request, jsonify, session, make_response, current_app


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
    return 