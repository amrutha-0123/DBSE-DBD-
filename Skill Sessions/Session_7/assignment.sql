-- DBMS ASSIGNMENT - SESSION 7
-- Session Outcome:
-- Explain embeddings, similarity metrics and ANN indexing techniques.


-- ============================================================
-- FILE: 01_vector_similarity.sql
-- ============================================================

-- SESSION 7: Embeddings & Similarity
-- PostgreSQL demonstration of vector concepts using pgvector.
-- If pgvector is installed, enable it with:
-- CREATE EXTENSION vector;

-- Example vector type:
-- CREATE TABLE text_embeddings (
--     id SERIAL PRIMARY KEY,
--     text_content TEXT,
--     embedding VECTOR(3)
-- );

-- Example similarity operators in pgvector:
-- <->  Euclidean distance
-- <=>  cosine distance
-- <#>  negative inner product

-- Example:
-- SELECT text_content
-- FROM text_embeddings
-- ORDER BY embedding <=> '[0.10,0.20,0.30]'::vector
-- LIMIT 5;

-- ANN indexes:
-- CREATE INDEX ON text_embeddings
-- USING hnsw (embedding vector_cosine_ops);

-- Concepts covered:
-- 1. Dense embeddings
-- 2. Cosine similarity
-- 3. Dot product
-- 4. Euclidean distance
-- 5. HNSW
-- 6. IVF

