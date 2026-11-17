---
name: html-js-graphics-3d
description: HTML/JS graphics and 3D data rendering - Canvas API, WebGL, Three.js, performance, and data visualization best practices.
license: MIT
compatibility: opencode
metadata:
  audience: all-agents
  priority: high
---

# HTML/JS Graphics & 3D Data Rendering

Covers 2D Canvas, WebGL, and Three.js for rendering interactive graphics and 3D data visualizations. Load when building or debugging browser-based graphics/3D.

## Core Technologies
1. **Canvas API (2D)** - For 2D drawing, charts, simple animations. Use when performance needs are moderate and no heavy 3D required.
2. **WebGL** - Low-level GPU API for high-performance 2D/3D. Use when you need fine control or maximum performance.
3. **Three.js** - High-level abstraction over WebGL. Recommended for most 3D web projects (easier, batteries-included).

## Decision Guide
1. **Static/simple 2D charts** → Canvas 2D API or SVG
2. **Interactive 2D animations** → Canvas 2D with requestAnimationFrame
3. **3D scenes/visualizations** → Three.js (preferred) unless extreme low-level control needed
4. **Compute-heavy custom shaders** → WebGL directly

## Best Practices
1. **Use requestAnimationFrame** - Never use setInterval for animations; sync to display refresh.
2. **Optimize draw calls** - Batch geometry, use instancing, merge geometries where possible.
3. **Manage assets** - Compress textures (KTX2/Basis), use DRACO for meshes, lazy load.
4. **Offload when heavy** - Use OffscreenCanvas + Web Workers for heavy computation/rendering.
5. **Dispose resources** - Call dispose() on geometries/materials/textures to avoid memory leaks.
6. **Use WebGPU when available** - Consider Three.js WebGPU renderer for modern browsers; fallback to WebGL.
7. **Responsive design** - Handle device pixel ratio, resize events, and mobile constraints.
8. **Accessibility** - Provide fallbacks, alt-text where possible, respect prefers-reduced-motion.

## 3D Data Visualization Tips
1. **Scale data appropriately** - Normalize values, use color maps, avoid visual distortion.
2. **Level of detail (LOD)** - Use LOD for large datasets to maintain performance.
3. **Culling** - Frustum culling, occlusion culling where applicable.
4. **Instancing** - Use InstancedMesh for repeated objects (thousands of points).
5. **Camera controls** - Provide intuitive orbit/pan/zoom controls.

## Guardrails
- Do NOT block main thread with heavy synchronous computation in render loop
- Do NOT leak GPU resources (always dispose)
- Do NOT ignore device pixel ratio (causes blurry rendering)
- Do NOT assume WebGL2 availability without fallback
- Do NOT load massive uncompressed assets
- Validate inputs for shaders (avoid undefined behavior)

## Verification
1. Check for console WebGL errors/warnings
2. Monitor FPS (use stats.js or built-in devtools)
3. Test on target devices/browsers
4. Verify memory usage (no unbounded growth)
5. Test with reduced motion preferences

## Provenance
- Sources: MDN WebGL Best Practices, MDN Canvas API, Three.js docs/community, WebGL vs Three.js comparisons (2026)
- Verified claims: Canvas/WebGL/Three.js distinctions, requestAnimationFrame, OffscreenCanvas, instancing, disposal (Verified - multiple sources)
- Repro example: Basic Three.js scene renders with requestAnimationFrame loop
- Known limitations: WebGPU support varies; mobile performance constraints
- Status: human-approved
- Created from: proactive gap
- Date: 2026-11-13
