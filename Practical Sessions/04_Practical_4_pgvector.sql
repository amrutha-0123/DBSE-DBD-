CREATE EXTENSION IF NOT EXISTS vector;
ALTER TABLE Books ADD COLUMN IF NOT EXISTS embedding VECTOR(3);

UPDATE Books SET embedding='[0.10,0.80,0.20]' WHERE isbn='9780553418026';
UPDATE Books SET embedding='[0.15,0.75,0.25]' WHERE isbn='9780441172719';
UPDATE Books SET embedding='[0.80,0.20,0.10]' WHERE isbn='9780132350884';

SELECT book_id,title,embedding <-> '[0.12,0.78,0.22]'::vector AS l2_distance
FROM Books WHERE embedding IS NOT NULL
ORDER BY embedding <-> '[0.12,0.78,0.22]'::vector LIMIT 3;

SELECT book_id,title,embedding <=> '[0.12,0.78,0.22]'::vector AS cosine_distance
FROM Books WHERE embedding IS NOT NULL
ORDER BY embedding <=> '[0.12,0.78,0.22]'::vector LIMIT 3;
