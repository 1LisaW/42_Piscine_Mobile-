# Exercise 01: Say Hello to the World

A Flutter exercise focused on implementing state management and user interaction.

## Objective

Build on Exercise 00 by implementing a stateful widget that toggles text display:
- Display "Hello World!" when the button is clicked
- Return to the initial text on the next click
- Continue toggling with each subsequent interaction

## Setup & Running

This project uses **Flutter Web in Docker** for a streamlined development environment.

### Prerequisites

Verify port 8080 availability:

```powershell
docker container ls
```

If port 8080 is already in use, stop the occupying container:

```powershell
docker stop <container-id>
```

### Getting Started

1. Navigate to the project directory:
   ```powershell
   cd ./ex01
   ```

2. Run the startup script:
   ```powershell
   ./script.sh
   ```

3. Open [http://localhost:8080](http://localhost:8080) in your browser

4. Test the button to verify the text toggling behavior

5. Exit the script when finished

### Why Docker?

- No local Flutter SDK installation required
- No emulator or special system permissions needed
- Consistent, isolated development environment
- Simple cleanup and project reset
