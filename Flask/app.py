import os
from flask import Flask, request, send_file
from rembg import remove
from PIL import Image

app = Flask(__name__)

@app.route('/process_images', methods=['POST'])
def process_images():
    input_dir = 'input'
    os.makedirs(input_dir, exist_ok=True)

    image_file = request.files['image']
    image_path = os.path.join(input_dir, image_file.filename)
    image_file.save(image_path)

    # Open the input image
    input_image = Image.open(image_path)

    # Remove the background
    output_image = remove(input_image)

    # Save the output image with a sequential name (overwrite the original image)
    output_path = os.path.join(input_dir, str(image_file.filename.split('.')[0]) + '.png')
    output_image.save(output_path)

    # Close the images
    input_image.close()
    output_image.close()

    # Convert the output image to bytes
    with open(output_path, 'rb') as file:
        image_bytes = file.read()

    # Remove the temporary output file
    os.remove(output_path)

    return image_bytes, 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
