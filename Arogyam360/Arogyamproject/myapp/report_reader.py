import PyPDF2
import pytesseract
from PIL import Image
import re


def extract_text(file_path):

    text = ""

    if file_path.lower().endswith(".pdf"):
        try:
            with open(file_path, 'rb') as f:
                reader = PyPDF2.PdfReader(f)
                for page in reader.pages:
                    text += page.extract_text() or ""
        except:
            pass

    else:
        try:
            img = Image.open(file_path)
            text = pytesseract.image_to_string(img)
        except:
            text = ""

    text = clean_medical_text(text)

    return text


def clean_medical_text(text):

    lines = text.splitlines()
    important_lines = []

    keywords = [
        "hemoglobin","hb","rbc","wbc","platelet",
        "glucose","sugar","cholesterol","hdl","ldl","triglyceride",
        "creatinine","urea","bilirubin","protein",
        "vitamin","b12","d3","calcium","iron",
        "bp","blood pressure","bmi","weight","height"
    ]

    for line in lines:
        low = line.lower()
        if any(k in low for k in keywords):
            important_lines.append(line.strip())

    short_text = "\n".join(important_lines)

    return short_text[:4000]
