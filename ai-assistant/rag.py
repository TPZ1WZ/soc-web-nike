"""
RAG pipeline: nạp Knowledge Base (markdown) -> vector DB (Chroma) -> truy hồi
tài liệu liên quan tới 1 alert. Dùng embedding mặc định của Chroma (MiniLM, local).
"""
import os
import glob
import chromadb
from chromadb.utils import embedding_functions

KB_DIR = os.path.join(os.path.dirname(__file__), "knowledge_base")


def _chunk_markdown(text: str, source: str):
    """Cắt tài liệu theo mục '## ' để mỗi chunk là 1 đơn vị kiến thức."""
    chunks = []
    current_title = source
    buff = []
    for line in text.splitlines():
        if line.startswith("## ") or line.startswith("# "):
            if buff:
                chunks.append((current_title, "\n".join(buff).strip()))
                buff = []
            current_title = line.lstrip("# ").strip()
        buff.append(line)
    if buff:
        chunks.append((current_title, "\n".join(buff).strip()))
    return [(t, c) for t, c in chunks if c]


class KnowledgeBase:
    def __init__(self):
        self.client = chromadb.Client()
        self.ef = embedding_functions.DefaultEmbeddingFunction()
        self.col = self.client.get_or_create_collection(
            name="soc_kb", embedding_function=self.ef
        )
        self._loaded = False

    def load(self):
        """Nạp toàn bộ markdown trong knowledge_base/ vào vector DB."""
        docs, ids, metas = [], [], []
        for path in glob.glob(os.path.join(KB_DIR, "*.md")):
            source = os.path.basename(path)
            with open(path, encoding="utf-8") as f:
                text = f.read()
            for i, (title, chunk) in enumerate(_chunk_markdown(text, source)):
                docs.append(chunk)
                ids.append(f"{source}::{i}")
                metas.append({"source": source, "title": title})
        if docs:
            self.col.upsert(documents=docs, ids=ids, metadatas=metas)
        self._loaded = True
        return len(docs)

    def retrieve(self, query: str, k: int = 4):
        """Trả về k đoạn kiến thức liên quan nhất tới query (nội dung alert)."""
        if not self._loaded:
            self.load()
        res = self.col.query(query_texts=[query], n_results=k)
        out = []
        docs = res.get("documents", [[]])[0]
        metas = res.get("metadatas", [[]])[0]
        for doc, meta in zip(docs, metas):
            out.append({"source": meta.get("source"), "title": meta.get("title"), "text": doc})
        return out


# singleton
kb = KnowledgeBase()
