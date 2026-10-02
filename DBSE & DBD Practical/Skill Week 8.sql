-- SKILL SESSION 08: VECTOR DATABASES — IMPLEMENTATION & INTEGRATION
-- Requires PostgreSQL with pgvector installed.

CREATE EXTENSION IF NOT EXISTS vector;

CREATE TABLE IF NOT EXISTS book_vectors (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    embedding vector(3) NOT NULL
);

INSERT INTO book_vectors (title, embedding) VALUES
('The Martian', '[0.10,0.80,0.20]'),
('Dune', '[0.15,0.75,0.25]'),
('Clean Code', '[0.80,0.20,0.10]'),
('Atomic Habits', '[0.40,0.40,0.20]')
ON CONFLICT DO NOTHING;

-- L2 / Euclidean distance
SELECT
    book_id,
    title,
    embedding <-> '[0.12,0.78,0.22]'::vector AS l2_distance
FROM book_vectors
ORDER BY embedding <-> '[0.12,0.78,0.22]'::vector
LIMIT 3;

-- Cosine distance
SELECT
    book_id,
    title,
    embedding <=> '[0.12,0.78,0.22]'::vector AS cosine_distance
FROM book_vectors
ORDER BY embedding <=> '[0.12,0.78,0.22]'::vector
LIMIT 3;

-- Inner product
SELECT
    book_id,
    title,
    embedding <#> '[0.12,0.78,0.22]'::vector AS negative_inner_product
FROM book_vectors
ORDER BY embedding <#> '[0.12,0.78,0.22]'::vector
LIMIT 3;

-- HNSW index for cosine similarity
CREATE INDEX IF NOT EXISTS idx_book_vectors_hnsw
ON book_vectors
USING hnsw (embedding vector_cosine_ops);

-- Example metadata filtering + vector search
SELECT
    title,
    embedding <=> '[0.12,0.78,0.22]'::vector AS cosine_distance
FROM book_vectors
WHERE book_id > 0
ORDER BY embedding <=> '[0.12,0.78,0.22]'::vector
LIMIT 3;
