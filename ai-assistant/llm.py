"""LLM client — hỗ trợ OpenAI và Anthropic (Claude). Chọn qua LLM_PROVIDER trong .env."""
import os

_openai_client = None
_anthropic_client = None


def analyze(system_prompt: str, user_prompt: str) -> str:
    provider = os.getenv("LLM_PROVIDER", "openai").lower()
    if provider == "anthropic":
        return _analyze_anthropic(system_prompt, user_prompt)
    return _analyze_openai(system_prompt, user_prompt)


# ---------- OpenAI (mặc định) ----------
def _get_openai():
    global _openai_client
    if _openai_client is None:
        from openai import OpenAI
        kwargs = {"api_key": os.getenv("OPENAI_API_KEY", "ollama")}
        if os.getenv("OPENAI_BASE_URL"):
            kwargs["base_url"] = os.getenv("OPENAI_BASE_URL")
        _openai_client = OpenAI(**kwargs)
    return _openai_client


def _analyze_openai(system_prompt: str, user_prompt: str) -> str:
    model = os.getenv("OPENAI_MODEL", "gpt-4o-mini")
    resp = _get_openai().chat.completions.create(
        model=model, temperature=0.2,
        messages=[{"role": "system", "content": system_prompt},
                  {"role": "user", "content": user_prompt}],
    )
    return resp.choices[0].message.content


# ---------- Anthropic (Claude) ----------
def _get_anthropic():
    global _anthropic_client
    if _anthropic_client is None:
        import anthropic
        _anthropic_client = anthropic.Anthropic(api_key=os.getenv("ANTHROPIC_API_KEY"))
    return _anthropic_client


def _analyze_anthropic(system_prompt: str, user_prompt: str) -> str:
    model = os.getenv("ANTHROPIC_MODEL", "claude-sonnet-4-5")
    msg = _get_anthropic().messages.create(
        model=model, max_tokens=1500,
        system=system_prompt,
        messages=[{"role": "user", "content": user_prompt}],
    )
    return "".join(b.text for b in msg.content if getattr(b, "type", "") == "text")
