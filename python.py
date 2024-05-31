from flask import Flask, request, jsonify
from waitress import serve
import json

app = Flask(__name__)

meshes_file = 'meshid.json'

def load():
    try:
        with open(meshes_file, 'r') as file:
            return json.load(file)
    except (IOError, ValueError):
        return {}

def save(mesh_ids):
    with open(meshes_file, 'w') as file:
        json.dump(mesh_ids, file)

@app.route('/uumeshids', methods=['POST'])
def upload():
    if not request.is_json:
        return jsonify({"status": "error", "message": "NO JSON"}), 400

    mesh_ids = request.get_json()
    existing = load()

    for key, value in mesh_ids.items():
        if key not in existing:
            existing[key] = value

    save(existing)
    return jsonify({"status": "success", "message": "UPDATED ID"}), 200

if __name__ == '__main__':
    serve(app, host='0.0.0.0', port=5000)
