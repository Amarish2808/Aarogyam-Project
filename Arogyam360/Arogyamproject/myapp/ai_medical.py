

import google.generativeai as genai

GOOGLE_API_KEY = "AIzaSyDXwWN13NgdU2fmtNNYoUEGuLbE-Epurhg"
genai.configure(api_key=GOOGLE_API_KEY)

model = genai.GenerativeModel("gemini-2.5-flash")


def generate_ai_health_report(report_text, user_note=""):

    summary_prompt = f"""
You are a medical report explanation assistant.

Explain the medical report in simple language.

Give:
1. Important findings
2. What it means
3. Risk level (Low/Moderate/High)
4. What to be careful about

User additional note:
{user_note}

Medical Report:
{report_text}
"""

    diet_prompt = f"""
You are a certified gym nutritionist AI.

Based on this medical report, create a SAFE gym diet plan.

Rules:
- Gym muscle gain friendly
- Avoid harmful foods based on report
- Include breakfast, lunch, dinner, snacks
- 7 day plan
- Indian foods preferred

Medical Report:
{report_text}

User note:
{user_note}
"""

    summary = model.generate_content(summary_prompt).text
    diet = model.generate_content(diet_prompt).text

    return summary, diet
