import os
from pathlib import Path
from dotenv import load_dotenv

load_dotenv(".env.llm")

PROMPT = """Return only one Lean theorem candidate about a positive constant implying nonzero.
Do not use sorry or natural language.
Use this style:
theorem example_name : ... := by
  ...
"""

def short(s, n=500):
    s = (s or "").strip()
    return s[:n].replace("\n\n", "\n")

def test_openai():
    from openai import OpenAI
    key = os.getenv("OPENAI_API_KEY", "")
    model = os.getenv("OPENAI_MODEL", "")
    if not key or not model:
        print("OPENAI: SKIP")
        return
    client = OpenAI(api_key=key)
    r = client.responses.create(
        model=model,
        input=PROMPT,
        max_output_tokens=200,
    )
    print("OPENAI: OK")
    print("model:", model)
    print(short(r.output_text))

def test_anthropic():
    import anthropic
    key = os.getenv("ANTHROPIC_API_KEY", "")
    model = os.getenv("ANTHROPIC_MODEL", "")
    if not key or not model:
        print("ANTHROPIC: SKIP")
        return
    client = anthropic.Anthropic(api_key=key)
    r = client.messages.create(
        model=model,
        max_tokens=200,
        messages=[{"role": "user", "content": PROMPT}],
    )
    text = "\n".join(
        block.text for block in r.content
        if getattr(block, "type", None) == "text"
    )
    print("ANTHROPIC: OK")
    print("model:", model)
    print(short(text))

def test_gemini():
    from google import genai
    key = os.getenv("GEMINI_API_KEY", "")
    model = os.getenv("GEMINI_MODEL", "")
    if not key or not model:
        print("GEMINI: SKIP")
        return
    client = genai.Client(api_key=key)
    r = client.models.generate_content(
        model=model,
        contents=PROMPT,
    )
    print("GEMINI: OK")
    print("model:", model)
    print(short(getattr(r, "text", "")))

for name, fn in [
    ("OPENAI", test_openai),
    ("ANTHROPIC", test_anthropic),
    ("GEMINI", test_gemini),
]:
    print("\n" + "=" * 80)
    print(name)
    try:
        fn()
    except Exception as e:
        print(f"{name}: ERROR")
        print(type(e).__name__, str(e)[:1000])
