import sys


def assert_version(v, expected):
    assert expected in v, f"Expected version {expected}, got {v}"

checks = []

def check(lable, fn):
    try:
        fn()
        checks.append(("PASS",lable))
    except Exception as e:
        checks.append(("FAIL",f"{lable} -> {e}"))

check("Python 3.11", lambda: assert_version(sys.version,"3.11"))
check("Jupyter Lab", lambda: __import__("jupyterlab"))
check("Ollama Client", lambda: __import__("ollama").list())
check("LangChain-Ollama", lambda: __import__("langchain_ollama"))
check("LlamaIndex", lambda: __import__("llama_index"))
check("CrewAI", lambda: __import__("crewai"))
check("AutoGen", lambda: __import__("autogen_agentchat"))
check("Chromadb", lambda: __import__("chromadb").Client())
check("SentenceTransformers", lambda: __import__("sentence_transformers"))
check("FAISS", lambda: __import__("faiss"))
check("Whisper", lambda: __import__("whisper"))
check("PyAudio", lambda: __import__("pyaudio"))
check("pyttsx3", lambda: __import__("pyttsx3"))
check("FastAPI", lambda: __import__("fastapi"))
check("spaCy model", lambda: __import__("spacy").load("en_core_web_sm"))



for status, lable in checks:
    icon = "✅" if status == "PASS" else "❌"
    print(f"{icon} {lable}")

failed = [l for s, l in checks if s == "FAIL"]
print(f"\n{len(checks) - len(failed)}/{len(checks)} checks passed:")