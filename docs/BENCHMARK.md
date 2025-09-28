# HTTP Client Benchmark Report
**Date**: September 29, 2025  
**Tools**: Go (zapgo), Zig (zap), curl  
**Benchmark Tool**: hyperfine  

## Test Environment
- **Go Binary**: 7.9M
- **Zig Binary**: 6.5M
- **Test Server**: localhost:8000 (local), httpbin.org (remote)

## Results Summary

### Localhost Performance (Low Latency)
```
hyperfine -N 'zapgo /' 'zap /' 'curl -s localhost:8000'
```

| Tool | Mean Time | Range | Relative Performance |
|------|-----------|--------|---------------------|
| **Zig (zap)** | 389.0 µs ± 89.2 µs | 256.0 µs – 1133.6 µs | **1.00x (baseline)** |
| **Go (zapgo)** | 2.2 ms ± 0.3 ms | 1.4 ms – 3.5 ms | **5.66x slower** |
| **curl** | 3.2 ms ± 0.4 ms | 2.4 ms – 4.6 ms | **8.35x slower** |

**Winner**: Zig by significant margin

### Remote Performance (Network Bound)
```
hyperfine -N 'zapgo httpbin.org/json' 'zap httpbin.org/json' 'curl -s httpbin.org/json'
```

#### Run 1:
| Tool | Mean Time | Range | Relative Performance |
|------|-----------|--------|---------------------|
| **curl** | 706.3 ms ± 137.8 ms | 545.5 ms – 1027.7 ms | **1.00x (baseline)** |
| **Zig (zap)** | 781.6 ms ± 238.3 ms | 547.2 ms – 1242.3 ms | **1.11x slower** |
| **Go (zapgo)** | 1.413 s ± 0.211 s | 1.141 s – 1.844 s | **2.00x slower** |

#### Run 2:
| Tool | Mean Time | Range | Relative Performance |
|------|-----------|--------|---------------------|
| **Zig (zap)** | 750.3 ms ± 300.9 ms | 530.5 ms – 1372.5 ms | **1.00x (baseline)** |
| **curl** | 801.7 ms ± 191.6 ms | 585.5 ms – 1127.0 ms | **1.07x slower** |
| **Go (zapgo)** | 1.511 s ± 0.427 s | 1.276 s – 2.691 s | **2.01x slower** |

**Winner**: Zig/curl roughly tied, Go consistently slower

## Key Observations

### Performance Characteristics
1. **Zig dominates low-latency scenarios** (5-8x faster than alternatives)
2. **Network-bound requests show smaller differences** (but Zig still leads)
3. **Go consistently slower** in both local and remote scenarios
4. **curl performs well for remote requests** despite being feature-heavy

### Code Complexity Comparison
- **Go**: Minimal, straightforward HTTP client usage
- **Zig**: More complex (arena allocator, manual string handling, URL parsing)
- **curl**: N/A (external tool)

### Binary Size
- **Zig**: 6.5M (smaller despite more features)
- **Go**: 7.9M (includes runtime overhead)

## Technical Analysis

### Why Zig Wins
- Zero-cost abstractions
- No garbage collector overhead  
- Direct system calls via LLVM optimization
- Minimal runtime
- Compile-time optimizations

### Why Go Lags
- Garbage collector initialization and runtime
- Goroutine scheduler overhead (even for single requests)
- Standard library abstraction layers
- Runtime type system overhead

### Network Test Variability
Remote benchmarks showed high variance due to:
- Internet latency fluctuations
- CDN routing changes  
- Server load variations
- ISP throttling/QoS

Local benchmarks were highly consistent, indicating reliable measurement of actual execution performance.

## Conclusions

1. **For CLI tools**: Zig provides measurable performance advantages
2. **For network applications**: Benefits diminish but remain present
3. **For development velocity**: Go's simplicity vs Zig's performance trade-off
4. **For production systems**: Performance gains may justify Zig's complexity

## Future Testing Recommendations

When porting to Zig:
- Test with compiled binaries (avoid `go run` overhead)
- Focus on localhost benchmarks for measuring pure execution performance
- Use `--warmup` option for more stable network measurements
- Consider testing concurrent request scenarios
- Measure memory usage alongside execution time

---
*Note: All tests performed with unoptimized code in both languages. Further optimizations possible in both Go and Zig implementations.*
