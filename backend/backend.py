import google.generativeai as genai
import requests
from dotenv import load_dotenv
from flask import Flask, request, jsonify
import PIL.Image
import os
from ftlangdetect import detect
from google.cloud import translate_v2 as translate
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

GOOGLE_API_KEY=os.getenv('GEMINI_KEY')
os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = 'GOOGLE_KEY'
genai.configure(api_key=GOOGLE_API_KEY)
model = genai.GenerativeModel('gemini-pro-vision')
chat = model.start_chat(history=[])
load_dotenv()


def is_image(img):
    return img.lower().endswith(('.png', '.jpg', '.jpeg', '.gif', '.bmp'))

def img_description(img):
    # loads up image
    img_path = path[0] 
    img = PIL.Image.open(img_path)

    prompt = """
        "Imagine you are a medical professional writing a detailed report, filling in the description of an injury.Provide a detailed analysis of the injury, 
        describing the seriousness of the injury, how much in danger the victim is, and more. Please make this description only TWO to THREE sentences long.
          Please keep the language general and easy to understand-- avoid using overly medical terms.
            """
    response = model.generate_content([prompt, img], stream=True)
    response.resolve()
    return response

# TRANSLATION PORTION #

def check_language(user_input):
  result = detect(text=f"{user_input}", low_memory=False)
  language = result['lang']
  return language

@app.route('/process_request', methods=['GET', 'POST'])
def process_request():
    if not request.is_json:
        return jsonify({"error": "Missing JSON in request or Content-Type header is not set to application/json"}), 400
    
    data = request.get_json()
    user_input = data.get('user_text', '')
    user_image = data.get('user_image', None)  
    
    # checks to see if user submitted both picture and image 
    if user_image and is_image(user_image):
        description = img_description(user_image)
        full_message = f"{description} -- {user_input}"
    else:
        full_message = user_input

    # translates to english if need be 
    if check_language(full_message) != 'en':
        translate_client = translate.Client()
        full_message = translate_client.translate(full_message, target_language='en')['translatedText']

    # process the message using the chat function
    response = chat.send_message(full_message)

    # translate back to the original language if needed
    original_language = check_language(user_input)
    if original_language != 'en':
        translated_response = translate_client.translate(response.text, target_language=original_language)['translatedText']
    else:
        translated_response = response.text

    return jsonify({'response': translated_response})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)