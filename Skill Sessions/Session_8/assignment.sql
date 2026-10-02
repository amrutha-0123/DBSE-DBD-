-- DBMS ASSIGNMENT - SESSION 8
-- Session Outcome:
-- Implement pgvector similarity search and understand vector retrieval, hybrid search and RAG.


-- ============================================================
-- FILE: 01_pgvector.sql
-- ============================================================

-- SESSION 8: pgvector Similarity Search
-- Requires PostgreSQL + pgvector.

CREATE EXTENSION IF NOT EXISTS vector;

DROP TABLE IF EXISTS documents;

CREATE TABLE documents (
    id SERIAL PRIMARY KEY,
    content TEXT NOT NULL,
    embedding VECTOR(3)
);

-- Demo 3-dimensional vectors.
INSERT INTO documents (content, embedding) VALUES
('PostgreSQL is a relational database', '[0.10,0.20,0.30]'),
('MongoDB stores documents', '[0.80,0.10,0.20]'),
('Vector search finds similar meanings', '[0.11,0.21,0.29]');

-- Euclidean distance
SELECT id, content,
       embedding <-> '[0.10,0.20,0.30]' AS distance
FROM documents
ORDER BY embedding <-> '[0.10,0.20,0.30]'
LIMIT 3;

-- Cosine distance
SELECT id, content,
       embedding <=> '[0.10,0.20,0.30]' AS cosine_distance
FROM documents
ORDER BY embedding <=> '[0.10,0.20,0.30]'
LIMIT 3;

-- Inner product
SELECT id, content,
       embedding <#> '[0.10,0.20,0.30]' AS negative_inner_product
FROM documents
ORDER BY embedding <#> '[0.10,0.20,0.30]'
LIMIT 3;

-- HNSW index
CREATE INDEX documents_embedding_hnsw
ON documents
USING hnsw (embedding vector_cosine_ops);

-- Example metadata column can be added:
ALTER TABLE documents
ADD COLUMN category TEXT;

UPDATE documents
SET category = 'database';

-- Hybrid-search idea:
-- Combine a PostgreSQL keyword condition with vector ranking.
SELECT id, content
FROM documents
WHERE content ILIKE '%database%'
ORDER BY embedding <=> '[0.10,0.20,0.30]'
LIMIT 5;

