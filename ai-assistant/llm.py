"""LLM client — mặc định OpenAI, hỗ trợ base_url tùy chỉnh (Ollama/OpenAI-compatible)."""
import os
from openai import OpenAI

_client = None


def get_client():
    global _client
    if _client is None:
        kwargs = {}
        base_url = os.getenv("OPENAI_BASE_URL")
        if base_url:
            kwargs["base_url"] = base_url
        # Ollama không cần key thật; đặt tạm để SDK khỏi lỗi
        kwargs["api_key"] = os.getenv("OPENAI_API_KEY", "ollama")
        _client = OpenAI(**kwargs)
    return _client


def analyze(system_prompt: str, user_prompt: str) -> str:
    model = os.getenv("OPENAI_MODEL", "gpt-4o-mini")
    resp = get_client().chat.completions.create(
        model=model,
        temperature=0.2,
        messages=[
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": user_prompt},
        ],
    )
    return resp.choices[0].message.content
