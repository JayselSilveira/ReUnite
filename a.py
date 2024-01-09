from flask import Flask, render_template, request, jsonify
from image import process_image, select_image
from flask import send_file
import base64
import os
app = Flask(__name__)

@app.route('/')
def home():
    
    return render_template('index.html')

@app.route('/process_image', methods=['POST'])
def process_image_route():
    try:
        file = request.files['image']
        target_age = int(request.form['target-age'])
        image_path = 'uploaded_image.jpg'
        file.save(image_path)
        result_image_path = process_image(image_path, target_age)
        return jsonify({'success': True, 'target_age': target_age})
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)})


@app.route('/select_image', methods=['GET'])
def select_image_route():
    image_path = select_image()
    return jsonify({'image_path': image_path})

if __name__ == '__main__':
    app.run(host='localhost', port=5000)
