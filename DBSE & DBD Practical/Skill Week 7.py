# SKILL SESSION 07: VECTOR DATABASES — FOUNDATIONS
# Demonstrates embeddings and cosine, dot-product, and Euclidean similarity.
# No external package required.

import math

documents = {
    "The Martian": [0.10, 0.80, 0.20],
    "Dune": [0.15, 0.75, 0.25],
    "Clean Code": [0.80, 0.20, 0.10],
    "Atomic Habits": [0.40, 0.40, 0.20],
}

query = [0.12, 0.78, 0.22]

def dot_product(a, b):
    return sum(x * y for x, y in zip(a, b))

def euclidean_distance(a, b):
    return math.sqrt(sum((x - y) ** 2 for x, y in zip(a, b)))

def cosine_similarity(a, b):
    numerator = dot_product(a, b)
    denominator = math.sqrt(dot_product(a, a)) * math.sqrt(dot_product(b, b))
    return numerator / denominator if denominator else 0.0

print("Query vector:", query)
print("\nSimilarity results:")

results = []

for title, vector in documents.items():
    results.append({
        "title": title,
        "cosine": cosine_similarity(query, vector),
        "dot_product": dot_product(query, vector),
        "euclidean": euclidean_distance(query, vector)
    })

for item in sorted(results, key=lambda x: x["cosine"], reverse=True):
    print(
        f"{item['title']}: "
        f"cosine={item['cosine']:.4f}, "
        f"dot={item['dot_product']:.4f}, "
        f"euclidean={item['euclidean']:.4f}"
    )

print("\nConcepts demonstrated:")
print("- Dense vector representations")
print("- Cosine similarity")
print("- Dot product")
print("- Euclidean distance")
print("- Similarity search")
print("- Exact nearest-neighbour comparison")
print("- ANN concepts such as HNSW and IVF are indexing approaches")
