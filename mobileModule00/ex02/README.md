# Exercise 02: More Buttons

UI for standard calculator app.

## Objectives

### UI Components
- **AppBar**: Display title "Calculator" at the top
- **TextFields**:
  - Expression display (shows "0" initially)
  - Result display (shows "0" initially)
- **Buttons**:
  - Number pad (0-9)
  - Decimal point (.)
  - Operations: `+`, `-`, `*`, `/`
  - Clear all (AC)
  - Delete last character (C)
  - Equals (=)

### Functionality
- Debug logging: Print button text to console on each press
- Responsive layout: Adapt to all device sizes (phone, tablet, etc.)

## Setup & Running

This project uses **Flutter Web in Docker** for a consistent development environment without local SDK installation.

### Prerequisites

- Docker installed and running
- Port 8080 available

Check port availability:
```powershell
docker container ls
```

If port 8080 is in use, stop the container:
```powershell
docker stop <container-id>
```

### Quick Start

1. Navigate to the project:
   ```powershell
   cd ./ex02
   ```

2. Start the development environment:
   ```powershell
   ./script.sh
   ```

3. Open [http://localhost:8080](http://localhost:8080) in your browser

4. Test button functionality and debug output

5. Exit when finished

