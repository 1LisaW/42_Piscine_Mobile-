# Calculator App - Exercise 03: It's Alive!

A fully functional calculator application built with Flutter, implementing arithmetic operations with a clean user interface.

## Features

### Core Operations
- ✓ Addition, Subtraction, Multiplication, Division
- ✓ Chained operations (e.g., `1 + 2 * 3 - 5 / 2`)
- ✓ Negative number input
- ✓ Decimal number support
- ✓ Delete last character (backspace)
- ✓ Clear expression and result

### UI Components
- Expression display field
- Result display field
- Interactive calculator buttons

## Getting Started

### Prerequisites

- Docker (installed and running)
- Port 8080 available on your machine

### Installation & Running

1. **Check port availability:**
   ```powershell
   docker container ls
   ```

2. **Free port 8080 if needed:**
   ```powershell
   docker stop <container-id>
   ```

3. **Start the development environment:**
   ```powershell
   cd ./calculator_app
   ./script.sh
   ```

4. **Access the app:**
   - Open [http://localhost:8080](http://localhost:8080) in your browser
   - Test button functionality and calculator operations
   - Press `Ctrl+C` to exit

## Development

This project uses **Flutter Web in Docker** for a consistent, containerized development environment without requiring local SDK installation.


