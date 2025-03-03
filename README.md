# Lincah ![](https://github.com/henxnomercy/Lincah/src/lincah.svg)
Light-weight open-source programming language designed for simplicity and graphics handling.

[![Build Status](https://img.shields.io/badge/build-passing-brightgreen)](https://github.com/henxnomercy/Lincah)  
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/henxnomercy/Lincah/blob/main/LICENSE)

## Overview
Lincah is a lightweight programming language focused on ease of use and graphics capabilities, suitable for game development and educational purposes. It currently supports basic constructs and graphics handling via a runtime library integrated with SDL.

## Fitur Utama

- **SDL2 Integration:** Inisialisasi jendela, input, dan event loop.
- **Vulkan Rendering:** Pipeline grafis tingkat rendah dengan optimasi memori, pipeline caching, dan GPU-driven rendering.
- **Sistem Fisika & Kolisi:** Deteksi tabrakan dengan tipe hitbox AABB dan Sphere.
- **Manajemen Aset:** Streaming aset asinkron dan cache LRU.
- **Multithreading:** Task scheduler dan job system untuk paralelisasi.
- **Optimasi Runtime:** Memory aliasing, pipeline barrier merging, dan adaptive compression.

## Directory Structure
- `src/`       : Source code for the Lincah compiler (lexer, parser, code generator).
- `runtime/`   : Runtime library for game engine integration (e.g., SDL-based graphics, input, sound).
- `examples/`  : Sample Lincah programs demonstrating usage.
- `build/`     : Generated files (ignored in git).

## Getting Started
### Prerequisites
- SDL2 library (`sudo apt-get install libsdl2-dev` on Ubuntu, or download for Windows).
- GCC or another C compiler for building the runtime.

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/henxnomercy/Lincah.git
   cd Lincah
