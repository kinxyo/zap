# Performance Benchmark Report: curl vs zap

## Test Configuration
- **Tool**: hyperfine v1.x
- **Warmup runs**: 3
- **Benchmark runs**: 50 per command
- **Server**: localhost:8000
- **Compared tools**: curl vs zap

---

## Executive Summary

The benchmarks reveal that **zap** and **curl** have comparable performance with context-dependent trade-offs. Zap excels in simpler requests and demonstrates lower overhead for basic operations, while curl maintains a significant advantage when handling large response bodies that require processing.

---

## Detailed Results

### Test 1: Slow Endpoint (`/slow`)
**Winner: zap (marginal)**

| Metric | curl | zap | Difference |
|--------|------|-----|------------|
| Mean time | 106.4 ms ± 0.5 ms | 104.3 ms ± 0.3 ms | **2.1 ms faster** |
| Range | 105.5 - 108.2 ms | 103.7 - 105.0 ms | More consistent |
| User CPU | 2.8 ms | 1.3 ms | 54% less |
| System CPU | 2.8 ms | 3.0 ms | Similar |

**Speedup**: 1.02x faster  
**Analysis**: On network-bound requests, zap shows slightly better performance with more consistent timing and lower user CPU usage. The difference is minimal, suggesting both tools have comparable network handling overhead.

---

### Test 2: Gzip Compressed Response (`/gzip`)
**Winner: zap (moderate)**

| Metric | curl | zap | Difference |
|--------|------|-----|------------|
| Mean time | 8.2 ms ± 0.4 ms | 7.2 ms ± 0.7 ms | **1.0 ms faster** |
| Range | 7.6 - 9.4 ms | 6.2 - 8.7 ms | Wider variance |
| User CPU | 2.1 ms | 2.5 ms | Similar |
| System CPU | 2.4 ms | 3.4 ms | 42% more |

**Speedup**: 1.14x faster  
**Analysis**: Zap handles compressed responses faster despite higher variance and increased system CPU time. The 12% performance advantage suggests efficient decompression handling, though the wider range indicates less predictable performance.

---

### Test 3: Large JSON Response (`/json/large`)
**Winner: curl (significant)**

| Metric | curl | zap | Difference |
|--------|------|-----|------------|
| Mean time | 5.3 ms ± 0.3 ms | 17.8 ms ± 2.1 ms | **12.5 ms slower** |
| Range | 4.8 - 5.9 ms | 15.4 - 23.8 ms | Much wider |
| User CPU | 2.4 ms | 14.8 ms | 517% more |
| System CPU | 2.2 ms | 5.9 ms | 168% more |

**Speedup**: curl is 3.37x faster  
**Analysis**: This reveals zap's significant weakness with large JSON payloads. The dramatically higher user CPU time (14.8 ms vs 2.4 ms) suggests zap is performing expensive JSON parsing or processing that curl skips. The high variance indicates inconsistent processing times.

---

### Test 4: Huge Response (`/huge`)
**Winner: curl (significant)**

| Metric | curl | zap | Difference |
|--------|------|-----|------------|
| Mean time | 9.2 ms ± 0.4 ms | 17.0 ms ± 0.7 ms | **7.8 ms slower** |
| Range | 8.4 - 10.2 ms | 15.7 - 18.7 ms | Wider |
| User CPU | 3.0 ms | 13.8 ms | 360% more |
| System CPU | 3.7 ms | 11.7 ms | 216% more |

**Speedup**: curl is 1.86x faster  
**Analysis**: Large payloads expose zap's overhead in response processing. Both user and system CPU usage are dramatically higher, suggesting memory allocation or data processing bottlenecks when handling substantial response bodies.

---

## Key Insights

### Zap's Strengths
- **Low latency operations**: 2-12% faster on simple requests
- **Reduced user CPU overhead**: Up to 54% less on network-bound requests
- **Efficient basic operations**: Better baseline performance

### Zap's Weaknesses
- **Large response handling**: 1.9-3.4x slower with substantial payloads
- **JSON processing overhead**: Significant CPU usage on structured data
- **Memory/processing bottleneck**: Performance degrades with response size

### Recommendations

**Use zap when:**
- Making quick health checks or status requests
- Working with small responses
- Minimizing client-side CPU usage matters
- Baseline request latency is critical

**Use curl when:**
- Downloading large files or responses
- Processing substantial JSON payloads
- Consistent performance across response sizes is needed
- Response body processing should be deferred or skipped

**For zap development priorities:**
1. Optimize large payload handling (streaming, lazy parsing)
2. Make JSON parsing optional or lazy
3. Reduce memory allocations for big responses
4. Consider zero-copy techniques for response bodies
